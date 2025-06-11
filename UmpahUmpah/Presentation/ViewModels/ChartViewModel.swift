//
//  ChartViewModel.swift
//  UmpahUmpah
//
//  Created by Henry on 6/4/25.
//

import Foundation

final class ChartViewModel: ObservableObject {
    @Published var strokeEfficiency: Double = 1.0
    @Published var stability: Double = 0.6
    @Published var immersion: Double = 0.3

    // TODO: HealthKit 관련 데이터 받아올 로직 작성
}
