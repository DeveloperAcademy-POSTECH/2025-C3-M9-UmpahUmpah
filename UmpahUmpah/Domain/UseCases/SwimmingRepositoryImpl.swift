//
//  SwimmingRepositoryImpl.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import Foundation

struct SwimmingRepositoryImpl: SwimmingRepository {
    let workoutDataSource = SwimmingWorkoutDataSource()
    let heartRateDataSource = HeartRateDataSource()

    func fetchSwimmingWorkouts(start: Date, end: Date, strokeType: SwimmingStrokeType?) async throws -> [SwimmingWorkout] {
        let rawWorkouts = try await workoutDataSource.fetchSwimmingWorkouts(start: start, end: end, strokeType: strokeType)

        return rawWorkouts.map {
            let lapCount = $0.workoutEvents?.filter { $0.type == .lap }.count ?? 0
            
            return SwimmingWorkout(
                id: UUID(),
                startDate: $0.startDate,
                endDate: $0.endDate,
                duration: $0.duration,
                distance: $0.totalDistance?.doubleValue(for: .meter()) ?? 0,
                energy: $0.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                lapCount: lapCount
            )
        }
    }
    
    func fetchHeartRateSamples(start: Date, end: Date) async throws -> [HeartRateSample] {
        return try await heartRateDataSource.fetchHeartRateSamples(start: start, end: end)
    }
}
