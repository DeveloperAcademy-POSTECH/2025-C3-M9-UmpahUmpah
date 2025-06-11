//
//  WeeklyCalendarT.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/8/25.
//

import SwiftUI

// MARK: - 주간 달력 뷰
struct WeeklyCalendar: View {
        let baseDate: Date
        @State private var selectedDate: Date?
        let onDateSelected: (Date) -> Void
    
        init(baseDate: Date, onDateSelected: @escaping (Date) -> Void) {
            self.baseDate = baseDate
            self.onDateSelected = onDateSelected
            
            // 오늘 날짜가 주간 달력 범위에 포함되어 있으면 기본 선택
            let today = Date()
            let calendar = Calendar.current
    
            // 주간 달력 범위 계산 (-6일부터 선택일까지)
            let startDate = calendar.date(byAdding: .day, value: -6, to: baseDate) ?? baseDate
            let endDate = baseDate
    
            // 오늘이 주간 범위에 포함되는지 확인
            let isTodayInRange = today >= calendar.startOfDay(for: startDate) &&
            today <= calendar.startOfDay(for: endDate).addingTimeInterval(24*60*60-1)
    
            self._selectedDate = State(initialValue: isTodayInRange ? today : nil)
        }
    
        private var weekDates: [Date] {
            let calendar = Calendar.current
            var dates: [Date] = []
    
            // 선택한 날짜가 맨 오른쪽에 오도록 -6부터 시작
            for i in -6...0 {
                if let date = calendar.date(byAdding: .day, value: i, to: baseDate){
                    dates.append(date)
                }
            }
            return dates
        }
        
    var body: some View {
        VStack(spacing: 12) {
            // 주간 달력 그리드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(weekDates, id: \.self) { date in
                    weekDayCell(
                        date: date,
                        isSelected: selectedDate != nil && Calendar.current.isDate(selectedDate!, inSameDayAs: date),
                        isToday: Calendar.current.isDateInToday(date),
                        isDisabled: date > Date() // 오늘 이후 날짜는 비활성화
                    ) {
                        onDateSelected(date)
                        // 오늘 이후 날짜는 선택 불가
                        if date <= Date() {
                            selectedDate = date
                        }
                    
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(.brand)
    }
    
    private var weekRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        
        guard let firstDate = weekDates.first,
              let lastDate = weekDates.last else {
            return ""
        }
        
        let startText = formatter.string(from: firstDate)
        let endText = formatter.string(from: lastDate)
        
        return "\(startText) - \(endText)"
        
    }
}
