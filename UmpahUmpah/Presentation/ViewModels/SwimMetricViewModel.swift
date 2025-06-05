//
//  SwimMetricViewModel.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

final class SwimMetricViewModel: ObservableObject {
    @Published var swimMetrics: [SwimMetric] = []
    @Published var strokeEfficiency: Double = 1.0
    @Published var stability: Double = 0.6
    @Published var immersion: Double = 0.3

    func updateSwimMetrics(from data: [String: Any]) {
        var result: [SwimMetric] = []

        if let duration = data["duration"] as? Int {
            let totalSeconds = duration / 1000
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            let seconds = totalSeconds % 60
            let timeString = String(format: "%01d:%02d:%02d", hours, minutes, seconds)
            result.append(SwimMetric(title: "⏰ 운동 시간", value: timeString, unit: ""))
        }

        if let distance = data["distance"] as? Double {
            result.append(SwimMetric(title: "📏 총 거리", value: "\(Int(distance))", unit: "m"))
        }

        if let calories = data["calories"] as? Int {
            result.append(SwimMetric(title: "🔥 칼로리", value: "\(calories)", unit: "kcal"))
        }

        if let averagePace = data["averagePace"] as? Int {
            let minutes = averagePace / 60
            let seconds = averagePace % 60
            let paceString = String(format: "%d:%02d", minutes, seconds)
            result.append(SwimMetric(title: "⏱️ 평균 페이스", value: paceString, unit: "/100m"))
        }

        if let heartRate = data["heartRate"] as? Int {
            result.append(SwimMetric(title: "💓 심박수", value: "\(heartRate)", unit: "bpm"))
        }

        if let lapCount = data["lapCount"] as? Int {
            result.append(SwimMetric(title: "🏊🏻 랩수", value: "\(lapCount)", unit: nil))
        }
        
        self.swimMetrics = result
        print("swimMetrics 업데이트 됨 : \(swimMetrics)")

        // UI 관련 상태 업데이트는 메인 스레드에서 진행
        DispatchQueue.main.async {
            self.swimMetrics = result
        }
    
    }
}
