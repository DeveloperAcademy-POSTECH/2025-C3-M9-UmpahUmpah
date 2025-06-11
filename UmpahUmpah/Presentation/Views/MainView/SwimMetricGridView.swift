//
//  SwimMetricGridView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import SwiftUI

struct SwimMetricGridView: View {
    @EnvironmentObject var swimmingStatsViewModel: SwimmingStatsViewModel

    var body: some View {
        VStack() {
            TripleGraphView(viewModel: swimmingStatsViewModel)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 13), count: 2),
                spacing: 20
            ) {
                SwimDataCell(
                    title: "⏰ 운동 시간",
                    value: swimmingStatsViewModel.dailySummaries.first?.workout.duration.hhmmssString ?? "00:00:00",
                    unit: nil
                )
                SwimDataCell(title: "📏 총 거리", value: String(format: "%.1f", swimmingStatsViewModel.dailySummaries.first?.workout.distance ?? 0.0), unit: "m")
                SwimDataCell(title: "🔥 칼로리", value: String(format: "%.1f", swimmingStatsViewModel.dailySummaries.first?.workout.energy ?? 0.0), unit: "kcal")
                SwimDataCell(title: "⏱️ 평균 페이스", value: swimmingStatsViewModel.dailySummaries.first?.workout.pacePer100m.readableMinuteSecond ?? "0′ 00″",
                    unit: "/100m"
                )
                SwimDataCell(title: "💓 심박수", value: String(format: "%.1f", swimmingStatsViewModel.dailySummaries.first?.averageHeartRate ?? 0.0), unit: "bpm")
                SwimDataCell(title: "🏊🏻 랩수", value: String(format: "%.1d", swimmingStatsViewModel.dailySummaries.first?.workout.lapCount ?? 0.0), unit: "laps")
            }.onChange(of: swimmingStatsViewModel.startDate) { _ in
                    Task {await swimmingStatsViewModel.loadStats()}
            }
        }
    }
}

