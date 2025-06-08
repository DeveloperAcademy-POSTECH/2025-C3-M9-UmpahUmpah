import SwiftUI

struct TooltipBody: View {
    var title: String
    var text: String
    @Binding var showTooltip: Bool //툴팁 사라지기 버튼용
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(title)
                .font(.callout)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            Text(text)
                .font(.callout)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .frame(minWidth: 300, minHeight: 150)
        .background(
            Rectangle()
                .fill(.subLigtGray)
        )
        .cornerRadius(15)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .opacity(0.9)
        
    }
}


