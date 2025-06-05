//
//  SwimmingRepository.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import Foundation

protocol SwimmingRepository {
    func fetchSwimmingWorkouts(start: Date, end: Date, strokeType: SwimmingStrokeType?) async throws -> [SwimmingWorkout]
    func fetchHeartRateSamples(start: Date, end: Date) async throws -> [HeartRateSample]

}
