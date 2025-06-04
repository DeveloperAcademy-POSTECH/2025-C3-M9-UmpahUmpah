//
//  MainViewModel.swift
//  UmpahUmpah
//
//  Created by Henry on 6/4/25.
//

import Foundation

final class MainViewModel: ObservableObject {
    // 선택된 날짜
    @Published var selectedDate: Date = .init()

    // 요일 배열(월요일 시작)
    let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]

    // 주간 날짜 배열
    var weekDates: [Date] {
        calculateCurrentWeek()
    }

    // 주간 날짜 배열 계산
    private func calculateCurrentWeek() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        // 오늘부터 7일 뒤까지 날짜 배열 생성
        return (0 ..< 7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset - 6, to: today)
        }
    }

    // 선택된 날짜 확인
    func isSelectedDate(_ date: Date) -> Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: date)
    }

    // 선택된 날짜 설정
    func selectedDate(_ date: Date) -> Date {
        selectedDate = date
        return selectedDate
    }

    // 날짜 요일 변경
    func changeDayOfWeek(_ date: Date) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        let index = (weekday + 5) % 7
        return daysOfWeek[index]
    }
}

extension Date {
    var day: Int { Calendar.current.component(.day, from: self) }
}
