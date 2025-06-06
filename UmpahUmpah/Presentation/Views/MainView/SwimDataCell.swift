//
//  SwimDataCell.swift
//  UmpahUmpah
//
//  Created by Henry on 6/4/25.
//

import SwiftUI

struct SwimDataCell: View {
    let title: String
    let value: String
    let unit: String?

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.subBlack)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color.subBlack)

                if let unit = unit {
                    Text(unit)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.subGray)
                }
            }
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.11), radius: 6, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 3.5)
                        .stroke(Color.white.opacity(0.12), lineWidth: 7)
                )
        )
    }
}

#Preview {
    SwimDataCell(title: "타이틀", value: "1234", unit: "m")
}
