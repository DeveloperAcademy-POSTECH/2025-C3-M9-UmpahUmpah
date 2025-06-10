//
//  MonthCalendarButtonT.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/9/25.
//

import SwiftUI

struct MonthCalendarButton<Label: View>: View {
    @State private var selectedDate: Date = Date()
    @State private var showPicker: Bool = false
    let onDateSelected: (Date) -> Void
    let label: () -> Label
    
    init(
        initialDate: Date = Date(),
        onDateSelected: @escaping (Date) -> Void,
        @ViewBuilder label: @escaping () -> Label
    ){
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
        .sheet(isPresented: $showPicker) {
            NavigationView {
                VStack(spacing: 20) {
                    // 날짜 피커
                    DatePicker(
                        "날짜 선택",
                        selection: $selectedDate,
                        in: ...Date(), // 오늘까지만 선택 가능
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showPicker = false
                            onDateSelected(selectedDate)
                        }) {
                           Image(systemName: "arrow.right")
                        }.fontWeight(.semibold)
                    }
                }
            }
            .presentationDetents([.height(500), .large]) // 높이 제한
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview ("월간 달력") {
    VStack(spacing: 20) {
        MonthCalendarButton(
            onDateSelected: { date in
                print("선택된 날짜: \(date)")
            }
        ) {
            Image(systemName: "calendar")
                .imageScale(.large)
                .foregroundStyle(.white)
        }
    }.padding(.trailing, 20)
}
