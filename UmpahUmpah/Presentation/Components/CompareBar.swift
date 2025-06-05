import SwiftUI

// MARK: 안정지수, 몰입도 비교바
struct CompareBar: View {
    var oldValue: Double
    var newValue: Double
    
    var body: some View {
        renderBarHStack(
            oldValue: oldValue,
            newValue: newValue,
            oldText: "\(Int(oldValue))",
            newText: "\(Int(newValue))",
            oldFill: Color.subLigtGray,
            newFill: Color.blue
        )
    }
}
