//
//  VSFeedbackViewModel.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

@MainActor
final class VSFeedbackViewModel: ObservableObject {
    @Published var feedback: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showLimitAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    
    private let useCase: RequestFeedbackUseCase
    
    init(useCase: RequestFeedbackUseCase) {
        self.useCase = useCase
    }
    
    /// 펼치기 전 사용량 제한 체크
    func checkUsageLimit() -> Bool {
        let repository = ChatGPTRepositoryImpl()
        do {
            try repository.checkUsageLimitOnly()
            return true // 사용 가능
        } catch let error as APILimitError {
            print("⚠️ API 제한: \(error.localizedDescription)")
            return false // 사용 불가
        } catch {
            print("알 수 없는 오류가 발생했습니다")
            return false
        }
    }
    
    func fetchFeedback(from dailyInfo: DailySwimmingInfo) {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let result = try await useCase.execute(from: dailyInfo)
                feedback = result
                saveFeedbackForToday(result)
            } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
                errorMessage = "네트워크 연결을 확인해주세요"
                showErrorAlert = true
            } catch let error as APILimitError {
                errorMessage = error.localizedDescription
            } catch {
                errorMessage = "피드백을 가져오는데 실패했습니다: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
    
    private func saveFeedbackForToday(_ feedback: String) {
        let today = Date().formattedTodayDate().replacingOccurrences(of: ".", with: "-")
        let key = "feedback_\(today)"
        UserDefaults.standard.set(feedback, forKey: key)
    }
    
    func loadTodayFeedback() {
        let today = Date().formattedTodayDate().replacingOccurrences(of: ".", with: "-")
        let key = "feedback_\(today)"
        if let savedFeedback = UserDefaults.standard.string(forKey: key) {
            feedback = savedFeedback
        }
    }
}
