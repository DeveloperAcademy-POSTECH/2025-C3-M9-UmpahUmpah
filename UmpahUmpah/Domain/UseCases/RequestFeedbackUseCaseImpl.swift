//
//  RequestFeedbackUseCaseImpl.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

final class RequestFeedbackUseCaseImpl: RequestFeedbackUseCase {
    private let repository: ChatGPTRepository

    init(repository: ChatGPTRepository) {
        self.repository = repository
    }

    func execute(from dailyInfo: DailySwimmingInfo) async throws -> String {
        let prompt = GPTPromptBuilder.build(from: dailyInfo)
        return try await repository.requestFeedback(prompt: prompt)
    }
}
