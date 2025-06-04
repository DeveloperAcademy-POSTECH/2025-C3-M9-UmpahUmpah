//
//  SwimmingRepository.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import Foundation

protocol SwimmingRepository {
//    func fetchSwimmingWorkouts(start: Date, end: Date) async throws -> [SwimmingWorkout]
    func fetchSwimmingWorkouts(start: Date, end: Date, strokeType: SwimmingStrokeType?) async throws -> [SwimmingWorkout]
    func fetchAverageHeartRate(start: Date, end: Date) async throws -> Double?
}
