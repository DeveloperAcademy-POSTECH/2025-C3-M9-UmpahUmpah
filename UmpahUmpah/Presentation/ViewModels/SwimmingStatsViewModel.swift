//
//  SwimmingStatsViewModel.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

// 삭제 예정
import Foundation

@MainActor
final class SwimmingStatsViewModel: ObservableObject {
    @Published var workouts: [SwimmingWorkout] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // 추가
    @Published var selectedStroke: SwimmingStrokeType? = nil
    @Published var startDate: Date = .init()
    @Published var endDate: Date
    @Published var strokeInfos: [StrokeInfo] = []
    @Published var swimmingScore: SwimmingScore?
    @Published var selectedWorkout: SwimmingWorkout?
    @Published var dailySummaries: [DailySwimmingInfo] = []
    
    // 오늘 날짜의 수영 데이터 반환
    var currentDailyInfo: DailySwimmingInfo? {
        let today = Calendar.current.startOfDay(for: Date())
        return dailySummaries.first { Calendar.current.startOfDay(for: $0.date) == today }
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
    }
}
