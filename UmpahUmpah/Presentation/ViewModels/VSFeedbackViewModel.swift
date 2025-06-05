//
//  VSFeedbackViewModel.swift
//  UmpahUmpah
//
//  Created by Henry on 6/5/25.
//

import Foundation

final class VSFeedbackViewModel: ObservableObject {
    private let useCase: RequestFeedbackUseCase

    @Published var feedback: String = ""
    @Published var isLoading: Bool = false

    init(useCase: RequestFeedbackUseCase) {
        self.useCase = useCase
    }

    func fetchFeedback(from metric: SwimMetric) {
        isLoading = true
        Task {
            do {
                let result = try await useCase.execute(from: metric)
                await MainActor.run {
                    self.feedback = result
                    self.isLoading = false
                }
            } catch {
                // 에러 핸들링
                await MainActor.run {
                    self.feedback = "피드백 생성에 실패했습니다."
                    self.isLoading = false
                }
            }
        }
    }
}
