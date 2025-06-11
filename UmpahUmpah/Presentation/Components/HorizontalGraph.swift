import SwiftUI

struct HorizontalGraph: View {
    @State var showTooltip = false //만약 툴팁을 한번에 하나만 보고 싶다면 이 변수를 VSView에 연결된 Binding으로 하면됩니다.
    
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
                        //MARK: 툴팁 오버레이로 나타내기
                        Button(action: {
                            withAnimation(.easeOut){
                                showTooltip = true
                            }
                            // MARK: 4초 후 툴팁 숨기기
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                withAnimation(.easeOut){
                                    showTooltip = false
                                }
                            }
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.black)
                        }
                        .padding(.trailing, 15)
                        .overlay(content: {
                            if showTooltip {
                                VStack(spacing: 0) {
                                    HStack {
                                        CustomTriangleShape(width: 10, height: 20, radius: 1)
                                            .frame(width: 10, height: 18)
                                            .foregroundColor(.black.opacity(0.9))
                                            .offset(x: 280) // 삼각형을 왼쪽으로 이동
                                        Spacer()
                                    }
                                    
                                    if title == "안정지수" {
                                        TooltipBody(
                                            title: "안정 지수란?",
                                            text: "수영 중 심박수와 속도의 변화가 적을수록 높은 점수를 받아요.\n일정한 페이스로 안정감 있게 수영한 정도를 보여줘요.",
                                            showTooltip: $showTooltip
                                        )
                                    } else if title == "스트로크 효율성" {
                                        TooltipBody(
                                            title: "스트로크 효율성이란?",
                                            text: "한 번 스트로크로 얼마나 멀리 나아갔는지를 나타내요.\n적은 횟수로 더 멀리 간다면 효율적인 수영이에요.",
                                            showTooltip: $showTooltip
                                        )
                                    } else if title == "몰입도 점수" {
                                        TooltipBody(
                                            title: "몰입도 점수란?",
                                            text: "중간에 멈춤 없이 얼마나 꾸준히 수영했는지를 보여줘요.\n몰입해서 계속 운동했다면 점수가 높아져요.",
                                            showTooltip: $showTooltip
                                        )
                                    } else if title == "SWOLF" {
                                        TooltipBody(
                                            title: "SWOLF 지수란?",
                                            text: "스트로크 수와 구간 시간의 합으로 계산되는 수영 효율 지표예요.\n낮을수록 빠르고 적은 동작으로 수영한 거예요.",
                                            showTooltip: $showTooltip
                                        )
                                    }else{}
                                }
                                
                                .offset(x: -140, y: 100)
                            }
                            
                        })
                        
                    }
                    
                }.zIndex(1)
                
                
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
        }
        .onTapGesture {
            withAnimation(.easeInOut){
                showTooltip = false
            }
        }
        .frame(height: 100)
        .padding(.horizontal, 10)
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
//
//#Preview {
//    HorizontalGraph()
//}
