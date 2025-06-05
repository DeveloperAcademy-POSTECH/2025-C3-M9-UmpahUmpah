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
    @ObservedObject private var swimMetricViewModel = SwimMetricViewModel() //SwimMetricViewModel 추가 됨
    @State private var isDataEmpty = true
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                // MARK: Header Section
                HeaderSectionView()
                WeeklyCalendarView(viewModel: viewModel)

                
                    Text("\(swimMetricViewModel.swimMetrics)")
                
                
                if !swimMetricViewModel.swimMetrics.isEmpty {
                    //swimMetric 수정필요, 지금은 더미데이터 만들어서 보내는중
                    SwimMetricGridView(viewModel: chartViewModel, swimMetric: swimMetricViewModel.swimMetrics)
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
