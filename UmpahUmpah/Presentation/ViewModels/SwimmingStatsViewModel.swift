//
//  SwimmingStatsViewModel.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import Foundation

@MainActor
final class SwimmingStatsViewModel: ObservableObject {
    @Published var workouts: [SwimmingWorkout] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // 추가
    @Published var selectedStroke: SwimmingStrokeType? = nil
    @Published var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    @Published var endDate: Date = Date()
    @Published var strokeInfos: [StrokeInfo] = []
    @Published var swimmingScore: SwimmingScore?
    @Published var dailyOverallScore: Double? = nil
    @Published var selectedWorkout: SwimmingWorkout?
    
    @Published var dailySummaries: [DailySwimmingInfo] = []
    
    private let repository: SwimmingRepository = SwimmingRepositoryImpl()
    private let scoreUseCase: CalculateSwimmingScoresUseCase = CalculateSwimmingScoresUseCaseImpl()
    
    private let strokeData = SwimmingStrokeDataSource()
    
    func loadStrokeData() async {
        do {
            try await HealthKitManager.shared.requestAuthorization()
            
            let infos = try await strokeData.fetchStrokeSamples(
                start: startDate,
                end: endDate,
                strokeType: selectedStroke
            )
            strokeInfos = infos
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    //    func loadStats(start: Date, end: Date) async {
    func loadStats() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await HealthKitManager.shared.requestAuthorization()
            let workouts = try await repository.fetchSwimmingWorkouts(start: startDate, end: endDate, strokeType: selectedStroke)
            
            self.workouts = workouts
            self.selectedWorkout = workouts.first
            
            await calculateDailySummaries()
        } catch {
            self.errorMessage = error.localizedDescription
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
            self.swimmingScore = score
            
            let overall = (scoreUseCase as? CalculateSwimmingScoresUseCaseImpl)?
                .calculateComprehensiveDailyScore(
                    workout: workout,
                    heartRates: heartRates,
                    strokeInfos: strokeInfos,
                    score: score
                )
            self.dailyOverallScore = overall
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    private func groupWorkoutsByDate(_ workouts: [SwimmingWorkout]) -> [Date: SwimmingWorkout] {
        var grouped: [Date: SwimmingWorkout] = [:]
        let calendar = Calendar.current

        for workout in workouts {
            let date = calendar.startOfDay(for: workout.startDate)
            // 하루에 하나의 workout만 있다고 가정 → 먼저 들어온 것만 저장
            if grouped[date] == nil {
                grouped[date] = workout
            }
        }

        return grouped
    }

    
    func calculateDailySummaries() async {
        do {
            let rawWorkouts = try await repository.fetchSwimmingWorkouts(start: startDate, end: endDate, strokeType: selectedStroke)
            let heartRates = try await repository.fetchHeartRateSamples(start: startDate, end: endDate)
            let allStrokeInfos = try await strokeData.fetchStrokeSamples(start: startDate, end: endDate, strokeType: selectedStroke)
            
            let grouped = groupWorkoutsByDate(rawWorkouts)

            var summaries: [DailySwimmingInfo] = []

            for workout in grouped.values {
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
                    date: Calendar.current.startOfDay(for: workout.startDate),
                    workout: workout,
                    score: score,
                    heartRates: hrSamples,
                    strokeInfos: strokeInfos,
                    overallScore: overall
                )

                summaries.append(summary)
            }

            self.dailySummaries = summaries.sorted { $0.date < $1.date }

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

}


