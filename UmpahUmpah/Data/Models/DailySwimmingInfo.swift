//
//  DailySwimmingInfo.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/5/25.
//

import Foundation

struct DailySwimmingInfo: Identifiable {
    let id = UUID()
    let date: Date // 해당 날짜
    
    let workout: SwimmingWorkout
    let score: SwimmingScore
    let heartRates: [HeartRateSample]
    let strokeInfos: [StrokeInfo]
    let overallScore: Double
    
    var averageHeartRate: Double? {
        guard !heartRates.isEmpty else { return nil }
        let total = heartRates.reduce(0) { $0 + $1.bpm }
        return total / Double(heartRates.count)
    }
}
