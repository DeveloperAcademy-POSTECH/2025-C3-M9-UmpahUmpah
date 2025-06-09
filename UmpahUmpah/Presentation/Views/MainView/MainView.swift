//
//  MainView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/2/25.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var chartViewModel = ChartViewModel()
    @EnvironmentObject var swimmingStatsViewModel: SwimmingStatsViewModel
    @State private var isDataEmpty = false
    @State private var selectedDate: Date = Date()
    
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                // MARK: Header Section
                HStack {
                    HeaderSectionView(dateText:Date().formattedTodayDate(),  message: "오늘도 음파음파")
                    MonthCalendarButton( initialDate: selectedDate, onDateSelected: { date in
                        selectedDate = date
                        swimmingStatsViewModel.startDate = date
                        Task {
                            await swimmingStatsViewModel.loadStats()
                        }
                    }, label:{
                        Image(systemName: "calendar")
                            .imageScale(.large)
                            .foregroundStyle(.white)
                    }).padding(.trailing, 20)
                }.background(.brand)
                WeeklyCalendar(baseDate: selectedDate, onDateSelected: { date in
                    swimmingStatsViewModel.startDate = date
                    Task {
                        await swimmingStatsViewModel.loadStats()
                    }
                })
                .onAppear {
                    let today = Calendar.current.startOfDay(for: Date())
                    swimmingStatsViewModel.startDate = today
                    Task {
                        await swimmingStatsViewModel.loadStats()
                    }
                }
                
                switch swimmingStatsViewModel.currentState {
                case .loading:
                    ProgressView("데이터를 불러오는 중이에요…")
                        .frame(maxHeight: .infinity)
                    
                case .noPermission:
                    Spacer()
                    Text("앗! 접근 권한이 없어요\n설정에서 건강 데이터 접근을 허용해 주세요.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.subGray)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                case .noWorkout:
                    
                    Spacer()
                    Text("이 날은 수영 기록이 없어요!\n🏊")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.subGray)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                case .hasData:
                    SwimMetricGridView()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                }
            }
        }
    }
}

#Preview {
    MainView()
}

