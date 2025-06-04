//
//  SwimmingStrokeStyleDataSource.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/4/25.
//

import HealthKit

final class SwimmingStrokeDataSource {
    private let healthStore = HKHealthStore()

    func fetchStrokeSamples(start: Date, end: Date, strokeType: SwimmingStrokeType?) async throws -> [StrokeInfo] {
        guard let strokeCountType = HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount) else {
            return []
        }

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: strokeCountType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                let strokeSamples = (samples as? [HKQuantitySample]) ?? []
                let results = strokeSamples.compactMap { sample -> StrokeInfo? in
                    let styleRaw = sample.metadata?[HKMetadataKeySwimmingStrokeStyle] as? Int ?? 5
                    let style = SwimmingStrokeType(rawValue: styleRaw) ?? .unknown

                    if let selected = strokeType, selected != style {
                        return nil
                    }

                    return StrokeInfo(
                        start: sample.startDate,
                        end: sample.endDate,
                        count: sample.quantity.doubleValue(for: .count()),
                        style: style
                    )
                }

                continuation.resume(returning: results)
            }

            healthStore.execute(query)
        }
    }
}
