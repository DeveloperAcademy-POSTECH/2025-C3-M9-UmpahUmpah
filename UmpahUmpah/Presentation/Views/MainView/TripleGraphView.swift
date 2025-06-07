import SwiftUI

struct TripleGraphView: View {
    @ObservedObject var viewModel: SwimmingStatsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            GraphRowView(
                title: "안정지수",
                value: viewModel.dailySummaries.first?.score.stabilityScore ?? 0.0,
                color: .graph2
            )
            GraphRowView(
                title: "몰입도",
                value: viewModel.dailySummaries.first?.score.immersionScore ?? 0.0,
                color: .graph3
            )
        }
 
        .padding(.vertical, 22)
        .padding(.horizontal, 16)
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
        StrokeEfficiencyView(value: viewModel.dailySummaries.first?.score.strokeEfficiency ?? 0.0)
    }
}

private struct GraphRowView: View {
    let title: String
    let value: Double
    let color: Color
    
    private let barHeight: CGFloat = 32
    private let maxWidth: CGFloat = 210
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(color)
                    .frame(width: CGFloat(value / 100) * maxWidth, height: barHeight)
                    .cornerRadius(10, corners: [.topRight, .bottomRight])
                
                Text("\(Int(Double(value) * 100))")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 8)
            }
            Spacer()
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
    }
}

private struct StrokeEfficiencyView: View {
    let value: Double
    
    var body: some View {
        HStack {
            Text("\(value, specifier: "%.1f")")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color.graph1)
                +
                Text("m / stroke")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color.graph1)

            Spacer()
            
            Text("스트로크 효율성")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.graph1)
        }
        
        .padding(.horizontal, 22)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14)
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
    TripleGraphView(viewModel: SwimmingStatsViewModel() )
}
