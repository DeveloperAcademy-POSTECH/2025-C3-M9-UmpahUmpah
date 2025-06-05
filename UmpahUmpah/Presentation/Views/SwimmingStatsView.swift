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
                    .onTapGesture {
                           viewModel.selectedWorkout = workout
                    }

                }
                
                
//                List(viewModel.strokeInfos) { info in
//                    VStack(alignment: .leading) {
//                        Text("🕒 \(info.start, formatter: dateFormatter) ~ \(info.end, formatter: timeFormatter)")
//                        Text("🏊‍♂️ 영법: \(info.style.displayName)")
//                        Text("💯 횟수: \(Int(info.count))")
//                    }
//                }
                
                List(viewModel.dailySummaries) { summary in
                    VStack(alignment: .leading) {
                        Text("📅 \(summary.date, formatter: dateFormatter)")
                        Text("Daily Score: \(summary.overallScore, specifier: "%.1f")점")
                        Text("안정 지수: \(summary.score.stabilityScore, specifier: "%.1f")점")
                        Text("스트로크 효율성: \(summary.score.strokeEfficiency, specifier: "%.2f") m/stroke")
                        Text("몰입도 점수: \(summary.score.immersionScore, specifier: "%.1f")")
                        Text("거리: \(summary.workout.distance, specifier: "%.1f")m")
                        Text("칼로리: \(summary.workout.energy, specifier: "%.1f")kcal")
                        Text("운동시간: \(summary.workout.duration, specifier: "%.1f")초")
                        Text("랩 수: \(summary.workout.lapCount ?? 0, specifier: "%.1d")laps")
                        Text("평균 페이스: \(summary.workout.pacePer100m, specifier: "%.1f")/100m")
                        Text("심박수: \(summary.averageHeartRate ?? 0.0, specifier: "%.1f")bpm")
                    }
                }
            }
        }
        .onChange(of: viewModel.selectedWorkout) { _ in
            Task {
                await viewModel.updateScoreForSelectedWorkout()
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

