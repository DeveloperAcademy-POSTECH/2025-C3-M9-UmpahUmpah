//
//  HorizontalGraph.swift
//  UmpahUmpah
//
//  Created by eunsoo on 6/2/25.
//

import SwiftUI

struct HorizontalGraph: View {
    var leftValue: Double = 0.3
    var rightValue: Double = 0.7
    var leftValueText: String = "30"
    var rightValueText: String = "70"
    var blockTitle: String = "🔥 칼로리"
    
    var body: some View {
        
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .frame(height: 100)
                .shadow(radius: 4)
            
            VStack(spacing: 8) {
                
                ZStack(){
                    HStack{
                        Text(blockTitle)
                            .font(.title2)
                            .fontWeight(.heavy)
                        .padding(.top, 12)
                        
                        Text("+50")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .padding(.top, 10)
                    }
                    
                    HStack{
                        Spacer()
                        Button(action:{
                            
                        }){
                            Image(systemName: "info.circle")
                                .foregroundStyle(.black)
                        }
                    }
                }
                
                HStack(spacing: 0) {
                    HStack{
                        Spacer()
                        
                        ZStack(alignment: .trailing){
                            Rectangle()
                                .fill(Color.mint)
                                .frame(width: CGFloat(leftValue) * 160, height: 32)
                                .cornerRadius(15, corners: [.topLeft, .bottomLeft])
                            
                            Text(leftValueText)
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
                    
                    HStack{
                        ZStack(alignment: .leading){
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: CGFloat(rightValue) * 160, height: 32)
                                .cornerRadius(15, corners: [.topRight, .bottomRight])
                            
                            Text(rightValueText)
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


// 커스텀 Shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// View Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


#Preview {
    HorizontalGraph()
}
