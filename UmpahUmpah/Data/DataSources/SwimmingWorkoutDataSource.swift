//
//  SwimmingWorkoutDataSource.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import HealthKit

final class SwimmingWorkoutDataSource {
    func fetchSwimmingWorkouts(start: Date, end: Date, strokeType: SwimmingStrokeType?) async throws -> [HKWorkout] {

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
