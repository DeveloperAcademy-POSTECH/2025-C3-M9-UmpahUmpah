//
//  HeaderSectionView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/4/25.
//

import SwiftUI

struct HeaderSectionView: View {
    let dateText: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
                            Text(dateText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
            
            Text(message)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 10)
                .padding(.horizontal, 16)
            
        }
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brand)
    }
}



#Preview {
    HeaderSectionView(dateText: "2025.06.15.", message: "오늘도 음파음파")
}
