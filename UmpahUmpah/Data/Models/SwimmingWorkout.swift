//
//  SwimmingWorkout.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/3/25.
//

import Foundation

struct SwimmingWorkout: Identifiable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let distance: Double
    let energy: Double
}
