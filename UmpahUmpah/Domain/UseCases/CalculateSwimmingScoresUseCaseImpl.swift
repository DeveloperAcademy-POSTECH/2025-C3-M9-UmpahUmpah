//
//  CalculateSwimmingScoresUseCaseImpl.swift
//  UmpahUmpah
//
//  Created by yunsly on 6/5/25.
//

import Foundation

struct CalculateSwimmingScoresUseCaseImpl: CalculateSwimmingScoresUseCase {
    private func coefficientOfVariation(of values: [Double]) -> Double {
        guard values.count > 1 else { return 0 }
        let mean = values.reduce(0, +) / Double(values.count)
        if mean == 0 { return 1 }
        let variance = values.map { pow($0 - mean, 2) }.reduce(0, +) / Double(values.count)
        return sqrt(variance) / mean
    }
    
    private func estimateRestTime(from strokeInfos: [StrokeInfo]) -> Double {
        guard strokeInfos.count > 1 else { return 0 }

        let sorted = strokeInfos.sorted { $0.start < $1.start }
        var restTime: Double = 0

        for i in 1..<sorted.count {
            let prevEnd = sorted[i - 1].end
            let nextStart = sorted[i].start
            let gap = nextStart.timeIntervalSince(prevEnd)
            print("🚧 gap: \(gap) sec")

            if gap > 60 { // 60초 이상 비면 쉬었다고 판단
                restTime += gap
            }
        }

        return restTime
    }
    
    func calculateComprehensiveDailyScore(
        workout: SwimmingWorkout,
        heartRates: [HeartRateSample],
        strokeInfos: [StrokeInfo],
        score: SwimmingScore
    ) -> Double {
        // 기본 운동량 정규화 (0~100)
        let distanceScore = min(100, max(0, (workout.distance - 500) / 1000 * 100))
        let durationScore = min(100, max(0, (workout.duration - 900) / 1800 * 100))
        let energyScore = min(100, max(0, (workout.energy - 150) / 300 * 100))
        
        // strokeEfficiency 정규화
        let normalizedEfficiency = min(100, max(0, (score.strokeEfficiency - 1.0) / 2.0 * 100))

        // 최종 종합 점수 (가중치 조정 가능)
        let overall = (
            score.stabilityScore * 0.25 +
            normalizedEfficiency * 0.2 +
            score.immersionScore * 0.2 +
            distanceScore * 0.15 +
            durationScore * 0.1 +
            energyScore * 0.1
        )

        return round(min(100, max(0, overall)))
    }


    func execute(
        workout: SwimmingWorkout,
        heartRates: [HeartRateSample],
        strokeInfos: [StrokeInfo]
    ) -> SwimmingScore {
        // 1. 안정 지수
        let heartRateCV = coefficientOfVariation(of: heartRates.map { $0.bpm })
        let stabilityScore = max(0, 100 - heartRateCV * 100)

        // 2. 스트로크 효율성
        let totalStrokes = strokeInfos.reduce(0) { $0 + $1.count }
        let strokeEfficiency = totalStrokes == 0 ? 0 : workout.distance / Double(totalStrokes)

        // 3. 몰입도 점수
        let restTime = estimateRestTime(from: strokeInfos) // 간단 추정
        let totalDuration = workout.duration
        let restRatio = restTime / totalDuration
        let immersionScore = max(0, 100 - restRatio * 100)


        return SwimmingScore(
            stabilityScore: stabilityScore,
            strokeEfficiency: strokeEfficiency,
            immersionScore: immersionScore
        )
    }
}

