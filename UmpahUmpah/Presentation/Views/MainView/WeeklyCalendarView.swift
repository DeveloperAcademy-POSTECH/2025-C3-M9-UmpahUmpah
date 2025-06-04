//
//  WeeklyCalendarView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/4/25.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.weekDates, id: \.self) { date in
                VStack(spacing: 10) {
                    Text(viewModel.changeDayOfWeek(date))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color.white)

                    Text("\(date.day)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.white)
                }
                .padding(.horizontal, 17)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(viewModel.isSelectedDate(date) ? Color.accent1 : Color.clear)
                        .frame(width: 36, height: 63)
                )
                .onTapGesture {
                    viewModel.selectedDate(date)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.brand)
    }
}

#Preview {
    WeeklyCalendarView(viewModel: MainViewModel())
}
