//
//  SwimmingWorkout.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import Foundation

struct SwimmingWorkout: Identifiable, Equatable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let distance: Double
    let energy: Double
    let lapCount: Int
    var pacePer100m: Double {
        guard distance > 0 else { return 0 }
        return (duration / distance) * 100
    }
}
