import SwiftUI

struct ExpandableBox<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isExpanded {
                content()
                    .padding()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            Button(action: {
                withAnimation(.spring(duration: 0.3)) {
                    isExpanded.toggle()
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
    }
}
