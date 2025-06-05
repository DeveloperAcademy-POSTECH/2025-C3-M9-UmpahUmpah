//
//  HealthKitManager.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/5/25.
//  통합 버전 – HealthKitHelper + HealthKitManager
//

import Combine
import Foundation
import HealthKit
import SwiftUI // @AppStorage

@MainActor
final class HealthKitManager: ObservableObject {
    // MARK: - Types

    enum AuthorizationState { case unknown, authorized, denied }

    // MARK: - Singleton

    static let shared = HealthKitManager()
    private init() {
        configureTypes()
        Task { await refreshAuthorizationStatus() }
    }

    // MARK: - 상태 (published)

    @Published private(set) var authorizationState: AuthorizationState = .unknown
    private var previousAuthState: AuthorizationState = .unknown

    /// 사용자가 “연동 사용” 토글을 끈 경우에도 값 유지 (@AppStorage)
    @AppStorage("IntegrationEnabled") var integrationEnabled: Bool = false {
        didSet {
            Task {
                if integrationEnabled { await activateIntegration() }
                else { await deactivateIntegration() }
            }
        }
    }

    /// “최초 승인 시 연동값을 true”로 자동 설정했는지 여부
    @AppStorage("IntegrationInitialized") private var integrationInit: Bool = false

    // MARK: - HealthKit

    let healthStore = HKHealthStore()
    private var readTypes: Set<HKObjectType> = [] // 일반 데이터
    private var shareTypes: Set<HKSampleType> = []
    private var activeQueries: [HKQuery] = []

    // 추가: 수영 관련 타입 세트
    private var swimmingTypes: Set<HKObjectType> = [
        HKObjectType.workoutType(),
        HKObjectType.quantityType(forIdentifier: .distanceSwimming)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
    ]

    // MARK: - 타입 구성

    private func configureTypes() {
        if let steps = HKObjectType.quantityType(forIdentifier: .stepCount),
           let heart = HKObjectType.quantityType(forIdentifier: .heartRate)
        {
            readTypes = [steps, heart]
            shareTypes = [steps, heart]
        }
    }

    // MARK: - 권한 상태 갱신

    func refreshAuthorizationStatus() async {
        guard HKHealthStore.isHealthDataAvailable(), !readTypes.isEmpty else {
            authorizationState = .denied
            previousAuthState = authorizationState
            return
        }

        // ① 현재 권한 판정
        let statuses = readTypes.map { healthStore.authorizationStatus(for: $0) }
        authorizationState = statuses.allSatisfy { $0 == .sharingAuthorized } ? .authorized : .denied

        // ② 권한 newly granted → 연동 ON
        if authorizationState == .authorized, previousAuthState != .authorized {
            integrationEnabled = true
        }

        // ③ 권한이 사라졌는데 토글이 ON이면 안전하게 OFF
        if authorizationState != .authorized, integrationEnabled == true {
            integrationEnabled = false
        }

        // ④ 다음 비교를 위해 저장
        previousAuthState = authorizationState
    }

    // MARK: - 일반 권한 요청 (steps / heart 등)

    //  - 기존 HealthKitHelper 의 API 와 동일: throws 없음
    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable(), !readTypes.isEmpty else {
            authorizationState = .denied; return
        }
        do {
            try await healthStore.requestAuthorization(toShare: shareTypes,
                                                       read: readTypes)
        } catch {
            // 사용자가 ‘취소’ 가능 – 오류 전파 없음 (기존 동작 유지)
        }
        await refreshAuthorizationStatus()
    }

    // MARK: - 수영 데이터 전용 권한 요청

    //  - 기존 HealthKitManager 의 API와 동일: throws 로 오류 전달
    func requestSwimmingAuthorization() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil,
                                             read: swimmingTypes)
            { success, error in
                if let error = error { continuation.resume(throwing: error) }
                else if success { continuation.resume() }
                else {
                    let err = NSError(domain: "HealthKit",
                                      code: 1,
                                      userInfo: [NSLocalizedDescriptionKey: "Authorization failed"])
                    continuation.resume(throwing: err)
                }
            }
        }
    }

    // MARK: - 연동 ON / OFF

    func activateIntegration() async {
        guard authorizationState == .authorized else { return }
        // 예: 쿼리 실행·백그라운드 업데이트 등록 등
    }

    func deactivateIntegration() async {
        for q in activeQueries {
            healthStore.stop(q)
        }
        activeQueries.removeAll()
        try? await healthStore.disableAllBackgroundDelivery()
    }
}
