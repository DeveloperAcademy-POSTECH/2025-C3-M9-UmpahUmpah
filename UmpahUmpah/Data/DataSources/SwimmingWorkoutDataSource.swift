//
//  SwimmingWorkoutDataSource.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import HealthKit

final class SwimmingWorkoutDataSource {
    func fetchSwimmingWorkouts(start: Date, end: Date, strokeType: SwimmingStrokeType?) async throws -> [HKWorkout] {
//        let predicate = HKQuery.predicateForWorkoutActivities(workoutActivityType: .swimming)
//        let predicate = HKQuery.predicateForWorkouts(with: .swimming)
//            .addingStartAndEndDatePredicate(start: start, end: end)

        // 변경
        var predicates: [NSPredicate] = [
            HKQuery.predicateForWorkouts(with: .swimming),
            HKQuery.predicateForSamples(withStart: start, end: end, options: [.strictStartDate, .strictEndDate])
        ]

        // stroke 추가
        if let stroke = strokeType {
            let metadataPredicate = HKQuery.predicateForObjects(withMetadataKey: HKMetadataKeySwimmingStrokeStyle, allowedValues: [stroke.hkValue as NSNumber])
            predicates.append(metadataPredicate)
        }

        // 추가
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let sampleType = HKObjectType.workoutType()

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: sampleType,
                                      predicate: predicate,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: nil)
            { _, samples, error in
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

// 제거 예정
// extension NSPredicate {
//    func addingStartAndEndDatePredicate(start: Date, end: Date) -> NSPredicate {
//        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])
//        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, datePredicate])
//    }
// }
