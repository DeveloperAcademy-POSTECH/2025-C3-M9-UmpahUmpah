import SwiftUI

struct TypingAnimationView: View {
    let text: String
    @State private var displayedText: String = ""
    @State private var isShowingCursor: Bool = true
    @State private var cursorTimer: Timer?
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // AI 아이콘
            Image(systemName: "brain.head.profile")
                .foregroundColor(.blue)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(displayedText)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    // 깜빡이는 커서 (중복 조건 제거)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 2, height: 16)
                        .opacity(isShowingCursor ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5), value: isShowingCursor)
                    
                    Spacer()
                }
                
                // 진행 상태 표시
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 6, height: 6)
                            .scaleEffect(isShowingCursor ? 1.0 : 0.5)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isShowingCursor
                            )
                    }
                    
                    Text("분석 중...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            startTypingAnimation()
            startCursorAnimation()
        }
        .onDisappear {
            cursorTimer?.invalidate()
            cursorTimer = nil
        }
    }
    
    // 타이핑 애니메이션
    private func startTypingAnimation() {
        displayedText = ""
        
        for (index, character) in text.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.07) {
                displayedText += String(character)
            }
        }
    }
    
    // 커서 애니메이션 (메모리 리크 방지)
    private func startCursorAnimation() {
        cursorTimer?.invalidate()
        cursorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                isShowingCursor.toggle()
            }
        }
    }
}

#Preview {
    TypingAnimationView(text: "AI가 당신의 수영 데이터를 분석하고 있습니다...")
        .padding()
} 