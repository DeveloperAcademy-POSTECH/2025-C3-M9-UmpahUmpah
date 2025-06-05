//
//  MainView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/2/25.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var chartViewModel = ChartViewModel()
    @StateObject private var swimmingStatsViewModel = SwimmingStatsViewModel()
    @State private var isDataEmpty = false
    

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                // MARK: Header Section

                HeaderSectionView(
                    dateText: Date().formattedTodayDate(), message: "오늘도 음파음파"
                )
                
                WeeklyCalendarView { selectedDate in
                    print("날짜 선택됨: \(selectedDate)")
                    swimmingStatsViewModel.startDate = selectedDate
                }
                
                if !isDataEmpty {
//                    SwimMetricGridView(viewModel: chartViewModel)
                    SwimMetricGridView(chartViewModel: chartViewModel, swimmingStatsViewModel: swimmingStatsViewModel)
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
