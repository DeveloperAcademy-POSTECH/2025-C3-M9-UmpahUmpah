import Foundation
import HealthKit
import SwiftData
import SwiftUI

enum HealthKitAuthState {
    case unknown
    case authorized
    case denied
}

struct SettingView: View {
    @State private var swimmingData: [String: Any] = [:]
    @State private var selectedDate: Date = .init()
    @State private var healthKitAuthState: HealthKitAuthState = .unknown
    @AppStorage("isHealthKitEnabled") private var isHealthKitEnabled: Bool = true

//    let healthStore = HealthStore()

    var body: some View {
        Text("세팅뷰")
//        VStack(spacing: 24) {
//            switch healthKitAuthState {
//            case .unknown:
//                ProgressView("HealthKit 권한 확인 중...")
//
//            case .denied:
//                VStack(spacing: 16) {
//                    Image(systemName: "heart.slash.circle.fill")
//                        .font(.system(size: 48))
//                        .foregroundColor(.red)
//                    Text("HealthKit 접근 권한이 필요합니다.")
//                        .font(.title3)
//                        .multilineTextAlignment(.center)
//                    Button("권한 요청하기") {
//                        requestHealthKitAccess()
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .tint(.pink)
//                    Text("요청 중 문제가 발생했거나 접근이 거부되었습니다.\n설정 앱에서 권한을 수동으로 허용해주세요.")
//                        .foregroundColor(.red)
//                        .font(.footnote)
//                        .multilineTextAlignment(.center)
//                }
//
//            case .authorized:
//                VStack(spacing: 24) {
//                    Toggle(isOn: $isHealthKitEnabled) {
//                        Label("HealthKit 데이터 사용", systemImage: "heart.fill")
//                    }
//                    .toggleStyle(.switch)
//                    .tint(.green)
//
//                    // 캘린더 항상 노출
//                    DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
//                        .datePickerStyle(.graphical)
//                        .padding(.horizontal)
//
//                    if isHealthKitEnabled {
//                        // 조회된 날짜 표시
//                        Text("\(selectedDate, formatter: dateFormatter) 수영 데이터")
//                            .font(.title2)
//
//                        if !swimmingData.isEmpty, swimmingData.values.contains(where: { ($0 as? Double ?? 0) > 0 }) {
//                            VStack(alignment: .leading, spacing: 8) {
//                                if let duration = swimmingData["duration"] as? Double {
//                                    let totalSeconds = Int(duration)
//                                    let hours = totalSeconds / 3600
//                                    let minutes = (totalSeconds % 3600) / 60
//                                    if hours > 0 {
//                                        Text("운동시간: \(hours)시간 \(minutes)분")
//                                    } else {
//                                        Text("운동시간: \(minutes)분")
//                                    }
//                                }
//                                if let distance = swimmingData["workoutDistance"] as? Double {
//                                    Text("총 거리: \(distance, specifier: "%.2f") m")
//                                }
//                                if let calories = swimmingData["workoutCalories"] as? Double {
//                                    Text("칼로리: \(calories, specifier: "%.0f") kcal")
//                                }
//                                if let heartRate = swimmingData["heartRate"] as? Double {
//                                    Text("평균 심박수: \(heartRate, specifier: "%.0f") bpm")
//                                }
//                                // 평균 페이스, 랩수, SWOLF(향후 구현 예정)
//                                if swimmingData["avgPace"] != nil {
//                                    // TODO: 평균 페이스 계산 및 표시 구현 예정
//                                    Text("평균 페이스: (추후 구현)")
//                                }
//                                if swimmingData["lapCount"] != nil {
//                                    // TODO: 랩수 계산 및 표시 구현 예정
//                                    Text("랩 수: (추후 구현)")
//                                }
//                                if swimmingData["swolf"] != nil {
//                                    // TODO: SWOLF 지수 계산 및 표시 구현 예정
//                                    Text("SWOLF: (추후 구현)")
//                                }
//                            }
//                            .padding(.top, 8)
//                        } else {
//                            Text("해당 날짜의 수영 데이터가 없습니다.")
//                                .foregroundColor(.gray)
//                        }
//                    } else {
//                        Text("HealthKit 사용이 비활성화되었습니다.\n데이터를 조회하려면 토글을 켜주세요.")
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(.gray)
//                            .padding()
//                    }
//                }
//            }
//        }
        .padding()
        /*
        .onAppear {
            requestHealthKitAccess()
            fetchSwimmingDataForSelectedDate()
        }
        .onChange(of: selectedDate) {
            fetchSwimmingDataForSelectedDate()
        }
         */
    }
        
/*
    func requestHealthKitAccess() {
        guard HKHealthStore.isHealthDataAvailable() else {
            healthKitAuthState = .denied
            return
        }
        healthStore.requestAuthorization { success, _ in
            DispatchQueue.main.async {
                healthKitAuthState = success ? .authorized : .denied
            }
        }
    }
    */
    
/*
    func fetchSwimmingDataForSelectedDate() {
        let start = Calendar.current.startOfDay(for: selectedDate)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? start
        swimmingData = [:]
        healthStore.fetchSwimmingWorkouts { workouts in
            // 선택한 날짜의 workout 중 가장 최근 것만 사용
            guard let workout = workouts.first(where: { $0.startDate >= start && $0.startDate < end }) else {
                DispatchQueue.main.async {
                    swimmingData = [:]
                }
                return
            }
            let duration = workout.duration
            let distance = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
//            let lapCount = Double(workout.lapCount)
            var result: [String: Any] = [
                "duration": duration,
                "workoutDistance": distance,
//                "lapCount": lapCount
            ]
            let group = DispatchGroup()
            // 칼로리
            group.enter()
            healthStore.fetchQuantityStats(typeIdentifier: .activeEnergyBurned, startDate: workout.startDate, endDate: workout.endDate, unit: .kilocalorie()) { calories in
                if let calories = calories { result["workoutCalories"] = calories }
                group.leave()
            }
            // 심박수
            group.enter()
            healthStore.fetchHeartRateSamples(startDate: workout.startDate, endDate: workout.endDate) { samples in
                let avg = samples.map { $0.quantity.doubleValue(for: .init(from: "count/min")) }.average
                if let avg = avg { result["heartRate"] = avg }
                group.leave()
            }

            group.notify(queue: .main) {
                swimmingData = result
            }
        }
    }
*/
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

// Double 배열 평균/합 extension
private extension Array where Element == Double {
    var average: Double? { isEmpty ? nil : reduce(0, +) / Double(count) }
    var sum: Double? { isEmpty ? nil : reduce(0, +) }
}
