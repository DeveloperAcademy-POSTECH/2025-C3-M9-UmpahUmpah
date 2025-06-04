//
//  HeartRateDataSource.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import HealthKit

final class HeartRateDataSource {
    func fetchAverageHeartRate(start: Date, end: Date) async throws -> Double? {
        let type = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let samples = samples as? [HKQuantitySample], !samples.isEmpty else {
                    continuation.resume(returning: nil)
                    return
                }

                let bpmValues = samples.map { $0.quantity.doubleValue(for: .init(from: "count/min")) }
                let average = bpmValues.reduce(0, +) / Double(bpmValues.count)
                continuation.resume(returning: average)
            }

            HealthKitManager.shared.healthStore.execute(query)
        }
    }
}
