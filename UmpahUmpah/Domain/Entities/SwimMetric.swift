//
//  SwimMetric.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

struct SwimMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let unit: String?
}
