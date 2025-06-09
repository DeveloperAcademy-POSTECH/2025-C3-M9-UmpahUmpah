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
                .foregroundStyle(.white)
            Text(text)
                .font(.callout)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .frame(minWidth: 300, minHeight: 150)
        .background(
            Rectangle()
                .fill(.black.opacity(0.9))
        )
        .cornerRadius(15)
        .shadow(radius: 2)
        
    }
}


