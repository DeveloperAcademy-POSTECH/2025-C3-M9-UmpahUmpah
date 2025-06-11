import SwiftUI

// MARK: 운동시간 비교
struct TimeCompareBar: View {
    let oldValue: Double
    let newValue: Double
    
    var body: some View {
        renderBarHStack(
            oldValue: oldValue,
            newValue: newValue,
            oldText: formattedTime(oldValue),
            newText: formattedTime(newValue),
            oldFill: oldValue < newValue ? Color.subLigtGray : Color.accent2,
            newFill: oldValue > newValue ? Color.subLigtGray : Color.accent2
        )
    }
    
    private func formattedTime(_ seconds: Double) -> String {
        let s = Int(seconds)
        return String(format: "%02d:%02d:%02d", s / 3600, (s % 3600) / 60, s % 60)
    }
}
