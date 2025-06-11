//
//  weekDayCellT.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/9/25.
//

import SwiftUI

struct weekDayCell: View {
    
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let isDisabled: Bool
    let onTap: () -> Void
    
    // 일자
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    // 요일 한글로
    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    var body: some View {
        Button(action: onTap){
            VStack(spacing: 4) {
                // 요일
                Text(weekdayFormatter.string(from: date))
                    .font(.caption2)
                    .foregroundColor(.white)
                Spacer()
                // 날짜
                Text(dayFormatter.string(from: date))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .padding(5)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: isToday ? 2 : 0)
            )
        }
        .disabled(isDisabled) // 미래 날짜는 비활성화
    }
    
    // 배경 색깔
    private var backgroundColor: Color {
        if isDisabled {
            return .clear
        }
        
        if isSelected {
            return .accent1
        }
        return .brand
    }
    
    // 배경 선색
    private var borderColor: Color {
        isToday ? .accent1 : .clear
    }
    
}

