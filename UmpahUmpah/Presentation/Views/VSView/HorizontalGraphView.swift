import SwiftUI

struct HorizontalGraph: View {
    var oldValue: Double = 0.3
    var newValue: Double = 0.7
    var title: String = "🔥 칼로리"
    
    var isLowerGood: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .frame(height: 100)
                .shadow(radius: 4)
            
            VStack(spacing: 8) {
                ZStack {
                    HStack {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.heavy)
                            .padding(.top, 12)
                        
                        Text("+ \(Int((Double(newValue) - Double(oldValue)) * 100))")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Double(newValue) - Double(oldValue) > 0 ? .red : .gray)
                            .padding(.top, 10)
                    }
                    
                    HStack {
                        Spacer()

                        // MARK: 항목 설명 컴포넌트 출력명령을 여기서 내리면 됩니다.
                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.black)
                        }
                    }
                }
                
                HStack(spacing: 0) {
                    HStack {
                        Spacer()
                        
                        ZStack(alignment: .trailing) {
                            Rectangle()
                                .fill(Color.mint)
                                .frame(width: CGFloat(oldValue) * 150, height: 32)
                                .cornerRadius(15, corners: [.topLeft, .bottomLeft])
                            
                            Text("\(Int(Double(oldValue) * 100))")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                                .padding(.trailing, 8)
                        }
                    }
                    
                    Text("VS")
                        .fontWeight(.heavy)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 10)
                    
                    HStack {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: CGFloat(newValue) * 150, height: 32)
                                .cornerRadius(15, corners: [.topRight, .bottomRight])
                            
                            Text("\(Int(Double(newValue) * 100))")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                                .padding(.leading, 8)
                        }
                        Spacer()
                    }
                }
                .frame(height: 36)
                .padding(.top, 4)
            }
            .padding(.horizontal, 18)
        }
        .frame(height: 100)
    }
}

#Preview {
    HorizontalGraph()
}
