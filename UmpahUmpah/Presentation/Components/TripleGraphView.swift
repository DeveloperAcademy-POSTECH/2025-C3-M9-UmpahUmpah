import SwiftUI

struct TripleGraphView: View {
    let firstValueName: String = "스트로크 효율성"
    let secondValueName: String = "안정지수"
    let thirdValueName: String = "몰입도"
    
    var strokeEfficiency: Double = 1.0
    var stability: Double = 0.6
    var immersionLevel: Double = 0.3
    
    var body: some View {
        
        ZStack{
            VStack(alignment: .leading){
                HStack{
                    ZStack(alignment: .leading){
                        Rectangle()
                            .fill(Color.mint)
                            .frame(width: CGFloat(strokeEfficiency) * 200, height: 32)
                            .cornerRadius(10, corners: [.topRight, .bottomRight])
                        
                        Text("\(Int(Double(strokeEfficiency) * 100))")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                    }
                    Spacer()
                    Text(firstValueName)
                        .fontWeight(.heavy)
                        .foregroundStyle(.mint)
                }
                HStack{
                    ZStack(alignment: .leading){
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: CGFloat(stability) * 200, height: 32)
                            .cornerRadius(10, corners: [.topRight, .bottomRight])
                        
                        Text("\(Int(Double(stability) * 100))")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                    }
                    Spacer()
                    Text(secondValueName)
                        .fontWeight(.heavy)
                        .foregroundStyle(.blue)
                }
                
                HStack{
                    ZStack(alignment: .leading){
                        Rectangle()
                            .fill(Color.purple)
                            .frame(width: CGFloat(immersionLevel) * 200, height: 32)
                            .cornerRadius(10, corners: [.topRight, .bottomRight])
                        
                        Text("\(Int(Double(immersionLevel) * 100))")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                    }
                    Spacer()
                    Text(thirdValueName)
                        .fontWeight(.heavy)
                        .foregroundStyle(.purple)
                }
            }
            .padding()

            
        }
        .background(.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        
    }
}

#Preview {
    TripleGraphView()
}
