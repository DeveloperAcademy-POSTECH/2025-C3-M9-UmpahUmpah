//
//  RequestFeedbackUseCase.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

protocol RequestFeedbackUseCase {
    func execute(from metric: SwimMetric) async throws -> String
}
