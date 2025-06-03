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
    }
}
