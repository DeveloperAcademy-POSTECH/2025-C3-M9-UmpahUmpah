//
//  HeartRateDataSource.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import HealthKit

final class HeartRateDataSource {
    
    func fetchHeartRateSamples(start: Date, end: Date) async throws -> [HeartRateSample] {
        let type = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [.strictStartDate, .strictEndDate])

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                let bpmSamples: [HeartRateSample] = (samples as? [HKQuantitySample])?.map {
                    HeartRateSample(
                        bpm: $0.quantity.doubleValue(for: .init(from: "count/min")),
                        date: $0.startDate
                    )
                } ?? []

                continuation.resume(returning: bpmSamples)
            }

            HealthKitManager.shared.healthStore.execute(query)
        }
    }

}
