//
//  VSScoreSectionView.swift
//  UmpahUmpah
//
//  Created by eunsoo on 6/4/25.
//

import SwiftUI


struct VSScoreSectionView: View {
    var body: some View {
        HStack(){
            VStack{
                Text("이전 점수")
                    .fontWeight(.bold)
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                    
                    Text("80")
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
                    
                    Text("85")
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
    }
}
