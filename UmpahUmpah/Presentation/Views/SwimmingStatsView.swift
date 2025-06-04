//
//  SwimmingStatsView.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import SwiftUI

struct SwimmingStatsView: View {
    @StateObject private var viewModel = SwimmingStatsViewModel()
    
    var body: some View {
        /*
         VStack {
         if viewModel.isLoading {
         ProgressView("Loading...")
         } else if let error = viewModel.errorMessage {
         Text("Error: \(error)")
         } else {
         List(viewModel.workouts) { workout in
         VStack(alignment: .leading) {
         Text("🏊 Distance: \(workout.distance, specifier: "%.1f") m")
         Text("🔥 Energy: \(workout.energy, specifier: "%.1f") kcal")
         Text("⏱️ Duration: \(workout.duration, specifier: "%.1f") s")
         }
         }
         if let hr = viewModel.averageHeartRate {
         Text("❤️ Avg HR: \(Int(hr)) bpm")
         }
         }
         }
         .task {
         let start = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
         await viewModel.loadStats(start: start, end: Date())
         }
         */
        VStack {
            Form {
                Section(header: Text("수영 영법")) {
                    Picker("영법", selection: $viewModel.selectedStroke) {
                        Text("전체").tag(SwimmingStrokeType?.none)
                        ForEach(SwimmingStrokeType.allCases) { stroke in
                            Text(stroke.displayName).tag(Optional(stroke))
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("날짜 선택")) {
                    DatePicker("시작일", selection: $viewModel.startDate, displayedComponents: .date)
                    DatePicker("종료일", selection: $viewModel.endDate, displayedComponents: .date)
                }
            }
            
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let error = viewModel.errorMessage {
                Text("❗️Error: \(error)")
            } else {
                List(viewModel.workouts) { workout in
                    VStack(alignment: .leading) {
                        Text("🏊 \(workout.distance, specifier: "%.1f")m")
                        Text("🔥 \(workout.energy, specifier: "%.1f")kcal")
                        Text("⏱️ \(workout.duration, specifier: "%.1f")s")
                    }
                }
                List(viewModel.strokeInfos) { info in
                    VStack(alignment: .leading) {
                        Text("🕒 \(info.start, formatter: dateFormatter) ~ \(info.end, formatter: timeFormatter)")
                        Text("🏊‍♂️ 영법: \(info.style.displayName)")
                        Text("💯 횟수: \(Int(info.count))")
                    }
                }
                if let hr = viewModel.averageHeartRate {
                    Text("❤️ 평균 심박수: \(Int(hr)) bpm")
                }
            }
        }
        .onChange(of: viewModel.selectedStroke) {_ in
            Task {await viewModel.loadStats()}
            Task{await viewModel.loadStrokeData()}
        }
        .onChange(of: viewModel.startDate) {_ in
            Task {await viewModel.loadStats()}
            Task{await viewModel.loadStrokeData()}
        }
        .onChange(of: viewModel.endDate) {_ in
            Task {await viewModel.loadStats()}
            Task{await viewModel.loadStrokeData()}
        }
        .onAppear{
            Task { await viewModel.loadStats()}
            Task { await viewModel.loadStrokeData()}
        }
    }
}


private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }

