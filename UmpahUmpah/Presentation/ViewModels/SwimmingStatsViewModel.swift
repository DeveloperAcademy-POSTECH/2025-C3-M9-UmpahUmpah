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
    @Published var averageHeartRate: Double?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // 추가
    @Published var selectedStroke: SwimmingStrokeType? = nil
    @Published var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    @Published var endDate: Date = Date()
    @Published var strokeInfos: [StrokeInfo] = []
    @Published var swimmingScore: SwimmingScore?
    @Published var selectedWorkout: SwimmingWorkout?
    
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
//            let workouts = try await repository.fetchSwimmingWorkouts(start: start, end: end)
            let workouts = try await repository.fetchSwimmingWorkouts(start: startDate, end: endDate, strokeType: selectedStroke)
//            let avgHR = try await repository.fetchAverageHeartRate(start: start, end: end)
            let avgHR = try await repository.fetchAverageHeartRate(start: startDate, end: endDate)


            self.workouts = workouts
            self.averageHeartRate = avgHR
            self.selectedWorkout = workouts.first
            
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
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }


}


