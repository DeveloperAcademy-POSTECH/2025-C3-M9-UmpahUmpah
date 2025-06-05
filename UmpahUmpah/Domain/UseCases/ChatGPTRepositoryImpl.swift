//
//  ChatGPTRepositoryImpl.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import ChatGPTSwift
import Foundation

final class ChatGPTRepositoryImpl: ChatGPTRepository {
    private let api: ChatGPTAPI

    init() {
        let apiKey = "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"
        self.api = ChatGPTAPI(apiKey: apiKey)
    }

    func requestFeedback(prompt: String) async throws -> String {
        // OpenAI API 호출
        do {
            let response = try await api.sendMessage(text: prompt)
            print("OpenAI API 호출 성공!")
            print(response)
            return response
        } catch {
            print("GPT API Error: \(error.localizedDescription)")
            throw error
        }
    }
}
