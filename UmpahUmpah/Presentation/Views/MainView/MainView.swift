//
//  MainView.swift
//  UmpahUmpah
//
//  Created by Henry on 6/2/25.
//

import SwiftUI

struct StrokeMetric: Identifiable {
    let id = UUID()
    let value: CGFloat
    let label: String
    let color: Color
}

let mockMetrics: [StrokeMetric] = [
    .init(value: 100, label: "스트로크 효율성", color: Color.graph1),
    .init(value: 80, label: "안정 지수", color: Color.graph2),
    .init(value: 60, label: "몰입도", color: Color.graph3)
]

let maxMetricValue = mockMetrics.map { $0.value }.max() ?? 100

struct MainView: View {
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Header Section
            
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
            
            // MARK: Weekly Calender Section
            
            HStack(spacing: 0) {
                ForEach(0 ..< 7) { index in
                    VStack(spacing: 10) {
                        Text(["월", "화", "수", "목", "금", "토", "일"][index])
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color.white)
                        
                        Text("\([9, 10, 11, 12, 13, 14, 15][index])")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.white)
                    }
                    .padding(.horizontal, 17)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 18)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.brand)
            
            // MARK: UmpahGoritihm Chart Section
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(mockMetrics) { metric in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(metric.color)
                            .frame(width: metric.value * 2.1, height: 30)
                        
                        Spacer(minLength: 1)
                        
                        Text(metric.label)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(metric.color)
                    }
                    .padding(.horizontal, 10)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 11)
            .frame(maxWidth: .infinity)
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
            .padding(.top, 22)
            .padding(.horizontal, 16)
            
            // MARK: SwimDataGridView Section
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 13), count: 2),
                spacing: 20
            ) {
                ForEach(0 ..< 6) { index in
                    VStack(spacing: 12) {
                        Text("운동종류 \(index + 1)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.subBlack)
                        
                        Text("1234")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Color.subBlack)
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
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        Spacer()
    }
}

#Preview {
    MainView()
}
