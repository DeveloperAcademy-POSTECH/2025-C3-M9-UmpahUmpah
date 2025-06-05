import SwiftUI

// MARK: 스트로크 효율성, 총거리, 랩수, 칼로리, 심박수, SWOLF
struct RelativeCompareBar: View {
    var oldValue: Double
    var newValue: Double
    var isLowerGood: Bool
    
    init(oldValue: Double, newValue: Double, isLowerGood: Bool = false) {
        self.oldValue = oldValue
        self.newValue = newValue
        self.isLowerGood = isLowerGood
    }
    
    var body: some View {
        let oldFill = isLowerGood ? (newValue > oldValue ? Color.accent2 : Color.subLigtGray) :
                                  (newValue < oldValue ? Color.accent2 : Color.subLigtGray)
        let newFill = isLowerGood ? (newValue < oldValue ? Color.accent2 : Color.subLigtGray) :
                                  (newValue > oldValue ? Color.accent2 : Color.subLigtGray)
        
        renderBarHStack(
            oldValue: oldValue,
            newValue: newValue,
            oldText: "\(Int(oldValue))",
            newText: "\(Int(newValue))",
            oldFill: oldFill,
            newFill: newFill
        )
    }
}
