//
//  MainView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/2/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var chartViewModel = ChartViewModel()
    @State private var isDataEmpty = false

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                // MARK: Header Section

                HeaderSectionView()
                WeeklyCalendarView(viewModel: viewModel)

                if !isDataEmpty {
                    SwimMetricGridView(viewModel: chartViewModel)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                } else {
                    Spacer()
                    Text("아직 수집된 데이터가 없어요!\n 설정에서 접근 권한을 확인해 주세요.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.subGray)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

#Preview {
    MainView()
}
