//
//  SwimmingMetric.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

struct SwimmingMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let unit: String?
}
