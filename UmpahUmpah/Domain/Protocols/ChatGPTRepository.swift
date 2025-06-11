//
//  ChatGPTRepository.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

protocol ChatGPTRepository {
    func requestFeedback(prompt: String) async throws -> String
}
