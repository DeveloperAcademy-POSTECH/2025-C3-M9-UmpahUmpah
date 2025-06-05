//
//  SwimMetricGridView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import SwiftUI

struct SwimMetricGridView: View {
    @ObservedObject var viewModel: ChartViewModel
    var swimMetric: [SwimMetric]
    
    var body: some View {
        VStack(spacing: 20) {
            TripleGraphView(viewModel: viewModel)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 13), count: 2),
                spacing: 20
            ) {
                SwimDataCell(title: swimMetric[0].title, value: swimMetric[0].value, unit: swimMetric[0].unit)
                SwimDataCell(title: swimMetric[1].title, value: swimMetric[1].value, unit: swimMetric[1].unit)
                SwimDataCell(title: swimMetric[2].title, value: swimMetric[2].value, unit: swimMetric[2].unit)
                SwimDataCell(title: swimMetric[3].title, value: swimMetric[3].value, unit: swimMetric[3].unit)
                SwimDataCell(title: swimMetric[4].title, value: swimMetric[4].value, unit: swimMetric[4].unit)
                SwimDataCell(title: swimMetric[5].title, value: swimMetric[5].value, unit: swimMetric[5].unit)
            }
        }
    }
}

#Preview {
    let dummySwimMetrics: [SwimMetric] = [
        SwimMetric(title: "⏰ 운동 시간", value: "1:30:45", unit: ""),
        SwimMetric(title: "📏 총 거리", value: "900", unit: "m"),
        SwimMetric(title: "🔥 칼로리", value: "350", unit: "kcal"),
        SwimMetric(title: "⏱️ 평균 페이스", value: "1:45", unit: "/100m"),
        SwimMetric(title: "💓 심박수", value: "120", unit: "bpm"),
        SwimMetric(title: "🏊🏻 랩수", value: "30", unit: nil)
    ]
    
    SwimMetricGridView(viewModel: ChartViewModel(), swimMetric: dummySwimMetrics)
}
