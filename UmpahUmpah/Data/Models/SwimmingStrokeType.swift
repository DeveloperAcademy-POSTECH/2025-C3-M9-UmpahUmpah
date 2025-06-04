//
//  SwimmingStrokeType.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/4/25.
//
import Foundation

struct StrokeInfo: Identifiable {
    let id = UUID()
    let start: Date
    let end: Date
    let count: Double
    let style: SwimmingStrokeType
}

enum SwimmingStrokeType: Int, CaseIterable, Identifiable {
    case freestyle = 0
    case backstroke = 1
    case breaststroke = 2
    case butterfly = 3
    case mixed = 4
    case unknown = 5

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .freestyle: return "자유형"
        case .backstroke: return "배영"
        case .breaststroke: return "평영"
        case .butterfly: return "접영"
        case .mixed: return "혼합"
        case .unknown: return "알 수 없음"
        }
    }

    var hkValue: Int {
        return rawValue
    }
}
