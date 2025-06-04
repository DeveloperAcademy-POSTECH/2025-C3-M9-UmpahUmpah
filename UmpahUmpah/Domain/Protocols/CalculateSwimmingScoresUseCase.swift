//
//  CalculateSwimmingScoresUseCase.swift
//  UmpahUmpah
//
//  Created by yunsly on 6/4/25.
//

import Foundation

protocol CalculateSwimmingScoresUseCase {
    func execute(
        workout: SwimmingWorkout,
        heartRates: [HeartRateSample],
        strokeInfos: [StrokeInfo]
    ) -> SwimmingScore
}
