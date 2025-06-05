//
//  WeeklyCalendarView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/4/25.
//

import SwiftUI

struct WeeklyCalendarView: View {
    private let calendar = Calendar.current
    private let today = Date()

    let onDateSelected: (Date) -> Void
    @State private var selectedDate: Date? = Date()

    // 오늘 기준으로 왼쪽으로 6일
    private var weekDates: [Date] {
        (0 ..< 7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset - 14, to: today)
        }
    }

    private func weekdaySymbol(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한글 로케일
        formatter.dateFormat = "E" // 요일 (월, 화, 수...)
        return formatter.string(from: date)
    }

    private func dayString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private func isToday(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: today)
    }

    private func isSelected(_ date: Date) -> Bool {
        if let selectedDate = selectedDate {
            return calendar.isDate(date, inSameDayAs: selectedDate)
        }
        return false
    }

    var body: some View {
        HStack(spacing: 12) {
            ForEach(weekDates, id: \.self) { date in
                VStack(spacing: 4) {
                    Text(weekdaySymbol(for: date))
                        .font(.caption)
                        .foregroundColor(.white)

                    Text(dayString(for: date))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected(date) ? Color.accent1 : Color.clear)
                        .frame(width: 36, height: 63)
                )
                .onTapGesture {
                    selectedDate = date
                    onDateSelected(date)
                }
            }
        }
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .center)
        .background(.brand)
    }
}

#Preview {
    WeeklyCalendarView { selectedDate in
        print("날짜 선택됨: \(selectedDate)")
    }
}
