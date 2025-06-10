//
//  VSScoreSectionView.swift
//  UmpahUmpah
//
//  Created by eunsoo on 6/4/25.
//

import SwiftUI


struct VSScoreSectionView: View {
    var oldValue: Int
    var newValue: Int
    var noData: String = "--"
    
    init(oldValue: Double, newValue: Double) {
        self.oldValue = Int(oldValue)
        self.newValue = Int(newValue)
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("이전 점수")
                    .fontWeight(.bold)
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                    
                    Text(self.oldValue == 0 ? noData : String(self.oldValue))
                        .foregroundStyle(.subGray)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.vertical)
                }
            }
            
            Text("VS")
                .fontWeight(.bold)
                .padding(.top, 30)
            
            VStack{
                Text("오늘 점수")
                    .fontWeight(.bold)
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                    
                    Text(self.newValue == 0 ? noData : String(self.newValue))
                        .foregroundStyle(.accent2)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.vertical)
                }
            }
        }
        .padding(.top, 80) // Safe Area 고려
        .padding(.bottom, 20)
        .padding(.horizontal, 15)
        .foregroundStyle(.white)
        .background(Color("BrandColor"))
        .frame(maxWidth: .infinity)
        .frame(height: 80)
    }
}

#Preview {
    VSScoreSectionView(oldValue: 0.0, newValue: 0.0)
}
