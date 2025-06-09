//
//  SwimmingStatsViewModel.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import Foundation

@MainActor
final class SwimmingStatsViewModel: ObservableObject {
    enum SwimmingDataState {
        case loading
        case noPermission
        case noWorkout
        case hasData
    }

    private var hk = HealthKitManager.shared

    @Published var workouts: [SwimmingWorkout] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedStroke: SwimmingStrokeType? = nil
    @Published var startDate: Date = .init()
    @Published var endDate: Date
    @Published var strokeInfos: [StrokeInfo] = []
    @Published var swimmingScore: SwimmingScore?
    @Published var selectedWorkout: SwimmingWorkout?
    @Published var dailySummaries: [DailySwimmingInfo] = []
    @Published var currentState: SwimmingDataState = .loading

    // 선택된 날짜의 수영 데이터 반환
    var currentDailyInfo: DailySwimmingInfo? {
        let day = Calendar.current.startOfDay(for: startDate)
        return dailySummaries.first { Calendar.current.startOfDay(for: $0.date) == day }
    }

    private let repository: SwimmingRepository = SwimmingRepositoryImpl()
    private let scoreUseCase: CalculateSwimmingScoresUseCase = CalculateSwimmingScoresUseCaseImpl()
    private let strokeData = SwimmingStrokeDataSource()

    init() {
        let calendar = Calendar.current
        let startDate = Date() // self.startDate 대신 새 지역변수로 초기값 복사
        let startOfDay = calendar.startOfDay(for: startDate)
        endDate = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
    }

    func loadStats(for date: Date) async {
        // 입력받은 날짜로 startDate 변경
        startDate = date
        // 기존의 loadStats() 호출
        await loadStats()
    }

    func loadSwimmingData(for date: Date) async {
        // 입력된 날짜로 startDate 설정
        startDate = date

        // 데이터 로드
        await loadStats()

        // 선택된 워크아웃에 대한 점수 업데이트
        await updateScoreForSelectedWorkout()

        // 스트로크 데이터 로드
        await loadStrokeData()
    }

    func loadLatestSwimmingData() async {
        isLoading = true
        errorMessage = nil

        do {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

            // 최근 1년간 워크아웃 조회
            let workouts = try await repository.fetchSwimmingWorkouts(
                start: calendar.date(byAdding: .year, value: -1, to: Date())!,
                end: Date(),
                strokeType: nil
            )

            // 시작 날짜 기준으로 내림차순 정렬
            let sortedWorkouts = workouts.sorted { $0.startDate > $1.startDate }

            // 가장 최근 워크아웃 날짜 (n=1)
            if let latestDate = sortedWorkouts.first?.startDate {
                await loadSwimmingData(for: latestDate)
            } else {
                errorMessage = "수영 데이터가 없습니다."
                currentState = .noWorkout
                isLoading = false
            }
        } catch {
            errorMessage = error.localizedDescription
            currentState = .noPermission
            isLoading = false
        }

        updateCurrentState()
    }

    func loadSecondLatestSwimmingData() async {
        isLoading = true
        errorMessage = nil

        do {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

            // 최근 1년간 워크아웃 조회
            let workouts = try await repository.fetchSwimmingWorkouts(
                start: calendar.date(byAdding: .year, value: -1, to: Date())!,
                end: Date(),
                strokeType: nil
            )

            // 시작 날짜 기준으로 내림차순 정렬
            let sortedWorkouts = workouts.sorted { $0.startDate > $1.startDate }

            // 두 번째로 최근 워크아웃 날짜 (n=2)
            if sortedWorkouts.count >= 2 {
                let secondLatestDate = sortedWorkouts[1].startDate
                await loadSwimmingData(for: secondLatestDate)
            } else {
                errorMessage = "두 번째로 최근 수영 데이터가 없습니다."
                currentState = .noWorkout
                isLoading = false
            }
        } catch {
            errorMessage = error.localizedDescription
            currentState = .noPermission
            isLoading = false
        }

        updateCurrentState()
    }

    private func updateCurrentState() {
        let status = hk.authorizationState
        print("healthKit permission status: \(status)")
        switch status {
        case .denied:
            currentState = .noPermission
        default:
            if isLoading {
                currentState = .loading
            } else if let error = errorMessage,
                      error.contains("authorization") || error.contains("권한")
            {
                currentState = .noPermission
            } else if currentDailyInfo == nil {
                currentState = .noWorkout
            } else {
                currentState = .hasData
            }
        }
    }

    func loadStrokeData() async {
        do {
            try await HealthKitManager.shared.requestAuthorization()

            let calendar = Calendar.current
            let normalizedStart = calendar.startOfDay(for: startDate)
            let normalizedEnd = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate))!.addingTimeInterval(-1)

            let infos = try await strokeData.fetchStrokeSamples(
                start: normalizedStart,
                end: normalizedEnd,
                strokeType: selectedStroke
            )
            strokeInfos = infos
        } catch {
            errorMessage = error.localizedDescription
        }
        updateCurrentState()
    }

    func loadStats() async {
        isLoading = true
        errorMessage = nil

        do {
            try await HealthKitManager.shared.requestAuthorization()

            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

            // ✨ 오직 하루만 대상
            let normalizedDate = calendar.startOfDay(for: startDate)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: normalizedDate)!.addingTimeInterval(-1)

            let workouts = try await repository.fetchSwimmingWorkouts(
                start: normalizedDate,
                end: dayEnd,
                strokeType: selectedStroke
            )

            self.workouts = workouts
            selectedWorkout = workouts.first

            // ✨ 선택된 하루만 계산
            await calculateDailySummaries(for: [normalizedDate])
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
        updateCurrentState()
    }

    func updateScoreForSelectedWorkout() async {
        guard let workout = selectedWorkout else { return }

        do {
            let heartRates = try await repository.fetchHeartRateSamples(
                start: workout.startDate,
                end: workout.endDate
            )

            let workoutStrokeInfos = strokeInfos.filter {
                $0.start >= workout.startDate && $0.end <= workout.endDate
            }

            let score = scoreUseCase.execute(
                workout: workout,
                heartRates: heartRates,
                strokeInfos: workoutStrokeInfos
            )
            swimmingScore = score
        } catch {
            errorMessage = error.localizedDescription
        }
        updateCurrentState()
    }

    func calculateDailySummaries(for selectedDates: [Date]) async {
        do {
            let calendar = Calendar(identifier: .gregorian)
            var calendarWithTimeZone = calendar
            calendarWithTimeZone.timeZone = TimeZone(identifier: "Asia/Seoul")!

            // 선택된 날짜들을 기준으로 시작/끝 범위 계산
            guard let firstDate = selectedDates.min(),
                  let lastDate = selectedDates.max() else { return }

            let normalizedStart = calendarWithTimeZone.startOfDay(for: firstDate)
            let normalizedEnd = calendarWithTimeZone.date(byAdding: .day, value: 1, to: calendarWithTimeZone.startOfDay(for: lastDate))!.addingTimeInterval(-1)

            let rawWorkouts = try await repository.fetchSwimmingWorkouts(
                start: normalizedStart,
                end: normalizedEnd,
                strokeType: selectedStroke
            )

            let heartRates = try await repository.fetchHeartRateSamples(start: normalizedStart, end: normalizedEnd)
            let allStrokeInfos = try await strokeData.fetchStrokeSamples(start: normalizedStart, end: normalizedEnd, strokeType: selectedStroke)

            // 날짜별 Workout 하나씩 매칭
            var summaries: [DailySwimmingInfo] = []

            for date in selectedDates {
                let dayStart = calendarWithTimeZone.startOfDay(for: date)
                let dayEnd = calendarWithTimeZone.date(byAdding: .day, value: 1, to: dayStart)!.addingTimeInterval(-1)

                guard let workout = rawWorkouts.first(where: {
                    $0.startDate >= dayStart && $0.startDate <= dayEnd
                }) else {
                    continue
                }

                let strokeInfos = allStrokeInfos.filter { $0.start >= workout.startDate && $0.end <= workout.endDate }
                let hrSamples = heartRates.filter { $0.date >= workout.startDate && $0.date <= workout.endDate }

                let score = scoreUseCase.execute(
                    workout: workout,
                    heartRates: hrSamples,
                    strokeInfos: strokeInfos
                )

                let overall = (scoreUseCase as? CalculateSwimmingScoresUseCaseImpl)?
                    .calculateComprehensiveDailyScore(
                        workout: workout,
                        heartRates: hrSamples,
                        strokeInfos: strokeInfos,
                        score: score
                    ) ?? 0

                let summary = DailySwimmingInfo(
                    date: dayStart,
                    workout: workout,
                    score: score,
                    heartRates: hrSamples,
                    strokeInfos: strokeInfos,
                    overallScore: overall
                )

                summaries.append(summary)
            }

            dailySummaries = summaries.sorted { $0.date < $1.date }

        } catch {
            errorMessage = error.localizedDescription
        }
        updateCurrentState()
    }
}
