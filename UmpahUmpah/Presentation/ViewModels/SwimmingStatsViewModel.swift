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

    private let repository: SwimmingRepository = SwimmingRepositoryImpl()

    func loadStats(start: Date, end: Date) async {
        isLoading = true
        errorMessage = nil

        do {
            try await HealthKitManager.shared.requestAuthorization()
            let workouts = try await repository.fetchSwimmingWorkouts(start: start, end: end)
            let avgHR = try await repository.fetchAverageHeartRate(start: start, end: end)

            self.workouts = workouts
            self.averageHeartRate = avgHR
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

