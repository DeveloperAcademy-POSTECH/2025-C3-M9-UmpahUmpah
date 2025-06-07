//
//  MonthCalendar.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/7/25.
//

import SwiftUI

struct MonthCalendarButton<Label: View>:View {
    @State var selectedDate: Date = Date()
    @State private var showPicker: Bool = false
    let onDateSelected: (Date) -> Void
    let label: () -> Label
    
    // 초기 날짜를 설정할 수 있는 이니셜라이저
    init(
        initialDate: Date = Date(),
        onDateSelected: @escaping (Date) -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self._selectedDate = State(initialValue: initialDate)
        self.onDateSelected = onDateSelected
        self.label = label
    }
    
    var body: some View {
        Button(action: {
            showPicker.toggle()
        }) {
            label()
        }
        .popover(isPresented: $showPicker) {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 16){
                    Button(action: {
                        showPicker = false
                        onDateSelected(selectedDate)
                    }){
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .padding()
                            .foregroundStyle(.black)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    DatePicker(
                        "날짜 선택",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(width: .infinity,
                       height: .infinity)
            }
        }
    }
}
#Preview("기본 스타일") {
    VStack(spacing: 20) {
        MonthCalendarButton(
            onDateSelected: { date in
                print("선택된 날짜: \(date)")
            }
        ) {
            Text("날짜 선택")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    .padding()
}
