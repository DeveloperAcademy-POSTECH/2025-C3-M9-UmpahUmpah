import SwiftUI

struct ExpandableBox: View {
    @ObservedObject var viewModel: VSFeedbackViewModel
    let swimData: DailySwimmingInfo
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isExpanded {
                if viewModel.isLoading {
                    TypingAnimationView(text: "AI가 수영 데이터를 분석하고 있습니다...")
                        .padding()
                } else if !viewModel.feedback.isEmpty {
                    Text(viewModel.feedback)
                        .padding()
                }
            }
            
            Button(action: {
                if !isExpanded {
                    if !viewModel.feedback.isEmpty {
                        withAnimation(.spring(duration: 0.3)) {
                            isExpanded = true
                        }
                    } else {
                        if !viewModel.checkUsageLimit() {
                            return
                        }
                        
                        withAnimation(.spring(duration: 0.3)) {
                            isExpanded = true
                        }
                        viewModel.fetchFeedback(from: swimData)
                    }
                } else {
                    withAnimation(.spring(duration: 0.3)) {
                        isExpanded = false
                    }
                }
            }) {
                HStack {
                    Text(isExpanded ? "음파 피드백 접기" : "음파 피드백 보기")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Image(systemName: isExpanded ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.accent1))
            }
        }
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.accent1, lineWidth: 2)
        )
        .padding(.horizontal)
        .onChange(of: viewModel.showErrorAlert) { show in
            if show {
                withAnimation(.spring(duration: 0.3)) {
                    isExpanded = false
                }
            }
        }
    }
}
