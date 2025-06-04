//
//  HeaderSectionView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/4/25.
//

import SwiftUI

struct HeaderSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("2025.06.15.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.white)
                .padding(.top, 10)
                .padding(.horizontal, 16)

            Text("오늘도, 음파음파")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color.white)
                .padding(.top, 10)
                .padding(.horizontal, 16)
        }
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brand)
    }
}

#Preview {
    HeaderSectionView()
}
