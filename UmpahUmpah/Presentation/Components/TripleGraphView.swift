//
//  MainGraph.swift
//  UmpahUmpah
//
//  Created by eunsoo on 6/2/25.
//

import SwiftUI

struct TripleGraphView: View {
    var firstValue: Double = 1.0
    var secondValue: Double = 0.6
    var thirdValue: Double = 0.3
    
    var firstValueText: String = "100"
    var secondValueText: String = "60"
    var thirdValueText: String = "30"
    
    var firstValueName: String = "스트로크 효율성"
    var secondValueName: String = "안정지수"
    var thirdValueName: String = "몰입도"
    
    var body: some View {
        
        ZStack{
            VStack(alignment: .leading){
                HStack{
                    ZStack(alignment: .leading){
                        Rectangle()
                            .fill(Color.mint)
                            .frame(width: CGFloat(firstValue) * 200, height: 32)
                            .cornerRadius(10, corners: [.topRight, .bottomRight])
                        
                        Text(firstValueText)
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
                            .frame(width: CGFloat(secondValue) * 200, height: 32)
                            .cornerRadius(10, corners: [.topRight, .bottomRight])
                        
                        Text(secondValueText)
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
                            .frame(width: CGFloat(thirdValue) * 200, height: 32)
                            .cornerRadius(10, corners: [.topRight, .bottomRight])
                        
                        Text(thirdValueText)
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
