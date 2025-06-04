//
//  SwimMetricGridView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import SwiftUI

struct SwimMetricGridView: View {
    @ObservedObject var viewModel: ChartViewModel

    var body: some View {
        VStack(spacing: 20) {
            TripleGraphView(viewModel: viewModel)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 13), count: 2),
                spacing: 20
            ) {
                SwimDataCell(title: "⏰ 운동 시간", value: "0:28:53", unit: nil)
                SwimDataCell(title: "📏 총 거리", value: "40", unit: "m")
                SwimDataCell(title: "🔥 칼로리", value: "1342", unit: "kcal")
                SwimDataCell(title: "⏱️ 평균 페이스", value: "2’09’’", unit: "/100m")
                SwimDataCell(title: "💓 심박수", value: "69", unit: "bpm")
                SwimDataCell(title: "🏊🏻 랩수", value: "10", unit: nil)
            }
        }
    }
}

#Preview {
    SwimMetricGridView(viewModel: ChartViewModel())
}
