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
    
    private let useCase: RequestFeedbackUseCase
    
    init(useCase: RequestFeedbackUseCase) {
        self.useCase = useCase
    }
    
    /// 펼치기 전 사용량 제한 체크 
    func checkUsageLimit() -> Bool {
        // ChatGPTRepositoryImpl 직접 접근 (임시)
        let repository = ChatGPTRepositoryImpl()
        do {
            try repository.checkUsageLimitOnly()
            return true // 사용 가능
        } catch let error as APILimitError {
            // Toast 메시지 표시
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
            } catch let error as APILimitError {
                // 사용량 제한 에러 처리
                errorMessage = error.localizedDescription
                showLimitAlert = true
                print("⚠️ API 제한: \(error.localizedDescription)")
            } catch {
                errorMessage = "피드백을 가져오는데 실패했습니다: \(error.localizedDescription)"
                print("❌ API 에러: \(error)")
            }
            
            isLoading = false
        }
    }
}
