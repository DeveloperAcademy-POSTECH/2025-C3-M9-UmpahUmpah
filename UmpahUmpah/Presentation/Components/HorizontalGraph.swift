import SwiftUI

struct HorizontalGraph: View {
    let comparableItem: [String] = ["안정지수", "몰입도 점수"]
    let relativeItem: [String] = ["칼로리", "스트로크 효율성", "총거리", "랩수", "심박수", "SWOLF"]
    
    //MARK: - 아래 프로퍼티에 HealthKit에서 넘어오는 데이터 연결하면 됨(title마다 어떤 그래프를 이용하는지 분리 되어있음)
    var oldValue: Double = 1000
    var newValue: Double = 1150
    var title: String = "총거리"
    
    init(oldValue: Double, newValue: Double, title: String) {
        self.oldValue = floor(oldValue * 100) / 100
        self.newValue = floor(newValue * 100) / 100
        self.title = title
    }
    
    // 단위 결정 함수
    private func unitForTitle(_ title: String) -> String {
        switch title {
        case "총거리", "스트로크 효율성":
            return "m"
        case "칼로리":
            return "kcal"
        case "심박수":
            return "bpm"
        default:
            return ""
        }
    }
    
    func getValueDiff(_ oldValue: Double,_ newValue: Double) -> String {
        let decimalOld = Decimal(oldValue)
        let decimalNew = Decimal(newValue)
        let diff = decimalNew - decimalOld

        if title == "스트로크 효율성" {
            // 소수점 둘째 자리 반올림
            return NSDecimalNumber(decimal: diff).rounding(accordingToBehavior:
                NSDecimalNumberHandler(roundingMode: .plain,
                                       scale: 2,
                                       raiseOnExactness: false,
                                       raiseOnOverflow: false,
                                       raiseOnUnderflow: false,
                                       raiseOnDivideByZero: false)
            ).stringValue
        } else {
            // 정수 반올림 후 문자열로 반환
            let rounded = NSDecimalNumber(decimal: diff).rounding(accordingToBehavior:
                NSDecimalNumberHandler(roundingMode: .plain,
                                       scale: 0,
                                       raiseOnExactness: false,
                                       raiseOnOverflow: false,
                                       raiseOnUnderflow: false,
                                       raiseOnDivideByZero: false)
            )
            return rounded.stringValue
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .frame(height: 100)
                .shadow(radius: 4)
            
            VStack(spacing: 8) {
                ZStack {
                    HStack {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.heavy)
                            .padding(.top, 12)
                        
                        if title == "운동시간" {
                            Text("\(newValue > oldValue ? "+" : "-")\(String(format: "%02d:%02d:%02d", Int(oldValue - newValue) / 3600, (Int(oldValue - newValue) % 3600) / 60, Int(oldValue - newValue) % 60))")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(newValue > oldValue ? .red : .gray)
                                .padding(.top, 10)
                        } else {
                            // 단위를 추가하여 차이값 표시
//                            let difference = title == "스트로크 효율성" ? String(format: "%.2f", Double(newValue - oldValue)) : String(Int(newValue - oldValue))
                            let difference = getValueDiff(oldValue, newValue)
                            let unit = unitForTitle(title)
                            if title == "심박수" || title == "SWOLF" {
                                Text("\(newValue > oldValue ? "+" : "")\(difference)\(unit)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(newValue < oldValue ? .red : .gray)
                                    .padding(.top, 10)
                            } else {
                                Text("\(newValue > oldValue ? "+" : "")\(difference)\(unit)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(newValue > oldValue ? .red : .gray)
                                    .padding(.top, 10)
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.black)
                        }
                    }
                }
                
                if comparableItem.contains(title) {
                    CompareBar(oldValue: oldValue, newValue: newValue)
                } else if relativeItem.contains(title) {
                    // oldText와 newText에 단위 추가
                    let unit = unitForTitle(title)
                    let oldText = title == "스트로크 효율성" ? String(format:"%.2f", Double(oldValue)) + unit : "\(Int(round(oldValue)))\(unit)"
                    let newText = title == "스트로크 효율성" ? String(format:"%.2f", Double(newValue)) + unit : "\(Int(round(newValue)))\(unit)"
                    RelativeCompareBar(
                        oldValue: oldValue,
                        newValue: newValue,
                        isLowerGood: title == "심박수" || title == "SWOLF",
                        oldText: oldText,
                        newText: newText
                    )
                } else if title == "운동시간" {
                    TimeCompareBar(oldValue: oldValue, newValue: newValue)
                } else {
                    Text("해당 데이터가 존재하지 않습니다.")
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 18)
        }
        .frame(height: 100)
    }
}

// MARK: - 공통 바 렌더링 함수 (중복 제거)
func renderBarHStack(oldValue: Double, newValue: Double, oldText: String, newText: String, oldFill: Color, newFill: Color) -> some View {
    HStack(spacing: 0) {
        HStack {
            Spacer()
            ZStack(alignment: .trailing) {
                Rectangle()
                    .fill(oldFill)
                    .frame(width: CGFloat(oldValue / max(oldValue, newValue)) * 150, height: 32)
                    .cornerRadius(15, corners: [.topLeft, .bottomLeft])
                
                Text(oldText)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                    .padding(.trailing, 8)
            }
        }
        
        Text("VS")
            .fontWeight(.heavy)
            .foregroundStyle(.gray)
            .padding(.horizontal, 10)
        
        HStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(newFill)
                    .frame(width: CGFloat(newValue / max(oldValue, newValue)) * 150, height: 32)
                    .cornerRadius(15, corners: [.topRight, .bottomRight])
                
                Text(newText)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                    .padding(.leading, 8)
            }
            Spacer()
        }
    }
    .frame(height: 36)
    .padding(.top, 4)
    
}

//#Preview {
//    HorizontalGraph()
//}
