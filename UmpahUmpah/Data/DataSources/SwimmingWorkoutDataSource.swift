//
//  SwimmingWorkoutDataSource.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import HealthKit

final class SwimmingWorkoutDataSource {
    func fetchSwimmingWorkouts(start: Date, end: Date) async throws -> [HKWorkout] {
//        let predicate = HKQuery.predicateForWorkoutActivities(workoutActivityType: .swimming)
        let predicate = HKQuery.predicateForWorkouts(with: .swimming)
            .addingStartAndEndDatePredicate(start: start, end: end)

        let sampleType = HKObjectType.workoutType()

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: sampleType,
                                      predicate: predicate,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: nil) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: samples as? [HKWorkout] ?? [])
            }

            HealthKitManager.shared.healthStore.execute(query)
        }
    }
}

extension NSPredicate {
    func addingStartAndEndDatePredicate(start: Date, end: Date) -> NSPredicate {
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, datePredicate])
    }
}

