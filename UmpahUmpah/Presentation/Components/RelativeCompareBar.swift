import SwiftUI

// MARK: 스트로크 효율성, 총거리, 랩수, 칼로리, 심박수, SWOLF
struct RelativeCompareBar: View {
    var oldValue: Double
    var newValue: Double
    var isLowerGood: Bool
    let oldText: String
    let newText: String
     
    var body: some View {
        renderBarHStack(
            oldValue: oldValue,
            newValue: newValue,
            oldText: oldText,
            newText: newText,
            oldFill: isLowerGood ? (newValue > oldValue ? .accent2 : Color.subLigtGray) : (newValue < oldValue ? .accent2 : Color.subLigtGray),
            newFill: isLowerGood ? (newValue < oldValue ? .accent2 : Color.subLigtGray) : (newValue > oldValue ? .accent2 : Color.subLigtGray)
        )
    }
}
