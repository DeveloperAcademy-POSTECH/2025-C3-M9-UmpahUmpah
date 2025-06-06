//
//  ChatGPTRepositoryImpl.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

final class ChatGPTRepositoryImpl: ChatGPTRepository {
    
    // MARK: - API 키 보안 처리
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let key = config["OPENAI_API_KEY"] as? String else {
            fatalError("⚠️ Config.plist에서 OPENAI_API_KEY를 찾을 수 없습니다!")
        }
        return key
    }
    
    private let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    // MARK: - 사용량 제한, 건드리지 마세요!!
    private let dailyLimit = 10

    func requestFeedback(prompt: String) async throws -> String {
        // 사용량 체크
        try checkUsageLimit()
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "수영 트레이너로서 사용자의 건강 데이터를 기반으로 피드백을 제공해주세요. 응답은 반드시 직설적이되 친절하게 구성해주세요."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 300,
            "temperature": 0.7
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])

        let (data, _) = try await URLSession.shared.data(for: request)

        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let choices = json["choices"] as? [[String: Any]],
            let first = choices.first,
            let message = first["message"] as? [String: Any],
            let content = message["content"] as? String
        else {
            throw URLError(.badServerResponse)
        }
        
        // 성공 시 사용량 기록
        recordSuccessfulCall()
        
        return content
    }
    
    // MARK: - 사용량 제한 로직
    
    /// API 호출 없이 사용량 제한 상태만 체크
    func checkUsageLimitOnly() throws {
        try checkUsageLimit()
    }
    
    private func checkUsageLimit() throws {
        let today = Date().formattedTodayDate().replacingOccurrences(of: ".", with: "-")
        let usageKey = "api_usage_\(today)"
        
        // 하루 제한 체크
        let todayUsage = UserDefaults.standard.integer(forKey: usageKey)
        if todayUsage >= dailyLimit {
            throw APILimitError.dailyLimitExceeded(current: todayUsage, limit: dailyLimit)
        }
    }
    
    private func recordSuccessfulCall() {
        let today = Date().formattedTodayDate().replacingOccurrences(of: ".", with: "-")
        let usageKey = "api_usage_\(today)"
        
        // 오늘 사용량 +1
        let currentUsage = UserDefaults.standard.integer(forKey: usageKey)
        UserDefaults.standard.set(currentUsage + 1, forKey: usageKey)
        
        print("🔍 API 사용 기록: \(currentUsage + 1)/\(dailyLimit)회")
    }
    
    // MARK: - 디버그용 리셋 함수
    func resetUsageForTesting() {
        let today = Date().formattedTodayDate().replacingOccurrences(of: ".", with: "-")
        UserDefaults.standard.removeObject(forKey: "api_usage_\(today)")
        print("🧹 사용량 리셋 완료")
    }
}

// 에러 정의
enum APILimitError: LocalizedError {
    case dailyLimitExceeded(current: Int, limit: Int)
    
    var errorDescription: String? {
        switch self {
        case .dailyLimitExceeded(let current, let limit):
            return "오늘 AI 피드백을 \(current)/\(limit)회 모두 사용했습니다."
        }
    }
}
