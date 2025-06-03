import HealthKit

public final class HealthStore {
    private let healthStore = HKHealthStore()

    // MARK: - 권한 요청

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }
        let readTypes: Set<HKObjectType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .distanceSwimming)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
        ]
        healthStore.requestAuthorization(toShare: nil, read: readTypes, completion: completion)
    }

    // MARK: - 수영 운동 데이터 조회

    func fetchSwimmingWorkouts(completion: @escaping ([HKWorkout]) -> Void) {
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .swimming)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: workoutPredicate,
            limit: 10,
            sortDescriptors: [sortDescriptor]
        ) { _, samples, error in
            guard error == nil, let workouts = samples as? [HKWorkout] else {
                completion([])
                return
            }
            completion(workouts)
        }
        healthStore.execute(query)
    }

    // MARK: - 통계형 데이터 조회 (ex. 칼로리, 거리, 심박수)

    func fetchQuantityStats(
        typeIdentifier: HKQuantityTypeIdentifier,
        startDate: Date,
        endDate: Date,
        unit: HKUnit,
        completion: @escaping (Double?) -> Void
    ) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: typeIdentifier) else {
            completion(nil)
            return
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { _, statistics, _ in
            let value = statistics?.sumQuantity()?.doubleValue(for: unit)
            completion(value)
        }
        healthStore.execute(query)
    }

    // MARK: - 심박수 샘플 조회

    func fetchHeartRateSamples(startDate: Date, endDate: Date, completion: @escaping ([HKQuantitySample]) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion([])
            return
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            let heartRates = samples as? [HKQuantitySample] ?? []
            completion(heartRates)
        }
        healthStore.execute(query)
    }

    // MARK: - 평균 페이스, 랩수, SWOLF 계산 (향후 구현 예정)

    func calculateAveragePace(distance _: Double, duration _: Double) -> Double? {
        // TODO: 평균 페이스 계산 로직 구현 예정
        return nil
    }

    func calculateLapCount( /* 필요한 파라미터 */ ) -> Int? {
        // TODO: 랩수 계산 로직 구현 예정
        return nil
    }

    func calculateSwolf( /* 필요한 파라미터 */ ) -> Double? {
        // TODO: SWOLF 지수 계산 로직 구현 예정
        return nil
    }
}
