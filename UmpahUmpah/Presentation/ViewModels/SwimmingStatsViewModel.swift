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

    
    enum ComparisonState {
        case noDataAtAll        // 기록 자체가 없음
        case onlyPastExists     // 오늘 기록은 없고, 과거 기록은 있음
        case todayOnly          // 오늘 기록은 있으나 비교할 과거 기록 없음
        case compareReady       // 비교 가능 (오늘 기록도 있고, 과거 기록도 있고)
    }
    
	
	private var hk = HealthKitManager.shared
    @Published var didLoad = false
    
    @Published var workouts: [SwimmingWorkout] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedStroke: SwimmingStrokeType? = nil
    @Published var startDate: Date = .init()
    @Published var endDate: Date
    @Published var strokeInfos: [StrokeInfo] = []
    @Published var swimmingScore: SwimmingScore?
    @Published var selectedWorkout: SwimmingWorkout?
    @Published var dailySummaries: [DailySwimmingInfo] = [] {
        // 데이터 불러와질 때 비교뷰 데이터도 연동
        didSet {
            updateComparisonState()
        }
    }
    @Published var currentState: SwimmingDataState = .loading
    @Published var comparisonState: ComparisonState = .noDataAtAll
    
    // 선택된 날짜의 수영 데이터 반환
    var currentDailyInfo: DailySwimmingInfo? {
        let day = Calendar.current.startOfDay(for: startDate)
        return dailySummaries.first { Calendar.current.startOfDay(for: $0.date) == day }
    }
    
    // 가장 최신 워크아웃 (오늘 또는 가장 최근)
    var todayInfo: DailySwimmingInfo? {
        return dailySummaries.sorted(by: { $0.date > $1.date }).first
    }
    
    // 두 번째로 최신 워크아웃 (비교 대상)
    var pastInfo: DailySwimmingInfo? {
        return dailySummaries.sorted(by: { $0.date > $1.date }).dropFirst().first
    }
    
    // todayInfo의 날짜가 실제 오늘 날짜인지 여부
    var todayInfoIsActuallyToday: Bool {
        guard let todayInfo = todayInfo else { return false }
        return Calendar.current.isDateInToday(todayInfo.date)
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
    
    // 비교뷰 데이터 업데이트
    private func updateComparisonState() {
        let isTodayValid = todayInfoIsActuallyToday
        let hasPast = pastInfo != nil
        
        switch (isTodayValid, hasPast) {
        case (false, false):
            comparisonState = .noDataAtAll
        case (false, true):
            comparisonState = .onlyPastExists
        case (true, false):
            comparisonState = .todayOnly
        case (true, true):
            comparisonState = .compareReady
        }
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
    
    // MARK: 가장 최근 데이터 2개를 불러옴
    func loadLatestTwoSummaries() async {
        isLoading = true
        errorMessage = nil

        do {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
            
            let workouts = try await repository.fetchSwimmingWorkouts(
                start: calendar.date(byAdding: .year, value: -1, to: Date())!,
                end: Date(),
                strokeType: nil
            )
            
            let sorted = workouts.sorted(by: { $0.startDate > $1.startDate })
            
            let latestTwoDates = sorted.prefix(2).map { workout in
                calendar.startOfDay(for: workout.startDate)
            }
            
            await calculateDailySummaries(for: latestTwoDates)
            
        } catch {
            errorMessage = error.localizedDescription
            currentState = .noPermission
        }
        
        isLoading = false
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
            await HealthKitManager.shared.requestAuthorization()
            
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
    
    func loadStatsOnce() async {
            guard !didLoad else { return }
            didLoad = true
            await loadStats()
    }
    
    @MainActor
    func loadStats() async {
        isLoading = true
        errorMessage = nil
        
        do {
            await HealthKitManager.shared.requestAuthorization()
            
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
            updateComparisonState()
               
        } catch {
            errorMessage = error.localizedDescription
        }
        updateCurrentState()
    }
}
