//import SwiftUI
//
//struct HorizontalGraph: View {
//    let comparableItem:[String] = [
//        "안정지수",
//        "몰입도 점수"
//    ]
//    let relativeItem:[String] = [
//        "칼로리",
//        "스트로크 효율성",
//        "총거리",
//        "랩수",
//        "심박수",
//        "SWOLF"
//    ]
//    
//    var oldValue: Double = 1000
//    var newValue: Double = 1150
//    var title: String = "총거리"
//    
//    var body: some View {
//        ZStack(alignment: .top) {
//            RoundedRectangle(cornerRadius: 16)
//                .fill(.white)
//                .frame(height: 100)
//                .shadow(radius: 4)
//            
//            VStack(spacing: 8) {
//                ZStack {
//                    HStack {
//                        Text(title)
//                            .font(.title2)
//                            .fontWeight(.heavy)
//                            .padding(.top, 12)
//                        
//                        if title == "운동시간"{
//                            Text("\(newValue > oldValue ? "+" : "-")\(String(format: "%02d:%02d:%02d", Int(oldValue) / 3600, (Int(oldValue) % 3600) / 60, Int(oldValue) % 60))")
//                                .font(.caption)
//                                .fontWeight(.bold)
//                                .foregroundStyle(Double(newValue) - Double(oldValue) > 0 ? .red : .gray)
//                                .padding(.top, 10)
//
//                        }else{
//                            Text("\(newValue > oldValue ? "+" : "")\(Int((Double(newValue) - Double(oldValue))))")
//                                .font(.caption)
//                                .fontWeight(.bold)
//                                .foregroundStyle(Double(newValue) - Double(oldValue) > 0 ? .red : .gray)
//                                .padding(.top, 10)
//                        }
//                    }
//                    
//                    HStack {
//                        Spacer()
//                        // MARK: 항목 설명. 컴포넌트 출력명령을 여기서 내리면 됩니다.
//                        Button(action: {}) {
//                            Image(systemName: "info.circle")
//                                .foregroundStyle(.black)
//                        }
//                    }
//                }
//                
//                //MARK: 시각화 막대 HStack
//                if comparableItem.contains(title) {
//                    CompareBar(oldValue: self.oldValue, newValue: self.newValue)
//                }else if relativeItem.contains(title){
//                    if title == "심박수" || title == "SWOLF"{
//                        RelativeCompareBar(oldValue: self.oldValue, newValue: self.newValue, isLowerGood: true)
//                    }else{
//                        RelativeCompareBar(oldValue: self.oldValue, newValue: self.newValue)
//                    }
//                }else if title == "운동시간"{
//                    TimeCompareBar(oldValue: self.oldValue, newValue: self.newValue)
//                }else{
//                    Text("해당 데이터가 존재하지 않습니다.")
//                        .fontWeight(.bold)
//                        .foregroundStyle(.gray)
//                }
//                
//                
//                
//            }
//            .padding(.horizontal, 18)
//        }
//        .frame(height: 100)
//    }
//}
//
////안정지수, 몰입도 비교바
//struct CompareBar:View {
//    var oldValue: Double
//    var newValue: Double
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            HStack {
//                Spacer()
//                
//                ZStack(alignment: .trailing) {
//                    Rectangle()
//                        .fill(Color.subLigtGray)
//                        .frame(width: CGFloat(oldValue) * 1.5, height: 32)
//                        .cornerRadius(15, corners: [.topLeft, .bottomLeft])
//                    
//                    Text("\(Int(Double(oldValue)))")
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundStyle(.white)
//                        .padding(.trailing, 8)
//                }
//            }
//            
//            Text("VS")
//                .fontWeight(.heavy)
//                .foregroundStyle(.gray)
//                .padding(.horizontal, 10)
//            
//            HStack {
//                ZStack(alignment: .leading) {
//                    Rectangle()
//                        .fill(Color.blue)
//                        .frame(width: CGFloat(newValue) * 1.5, height: 32)
//                        .cornerRadius(15, corners: [.topRight, .bottomRight])
//                    
//                    Text("\(Int(Double(newValue)))")
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundStyle(.white)
//                        .padding(.leading, 8)
//                }
//                Spacer()
//            }
//        }
//        .frame(height: 36)
//        .padding(.top, 4)
//    }
//}
//
////스트로크 효율성, 총거리, 랩수, 칼로리 | 심박수, SWOLF (미완)
//struct RelativeCompareBar:View {
//    var oldValue: Double
//    var newValue: Double
//    var isLowerGood: Bool
//    
//    init(oldValue: Double, newValue: Double, isLowerGood: Bool = false) {
//        self.oldValue = oldValue
//        self.newValue = newValue
//        self.isLowerGood = isLowerGood
//    }
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            HStack {
//                Spacer()
//                
//                ZStack(alignment: .trailing) {
//                    
//                    if isLowerGood {
//                        Rectangle()
//                            .fill(newValue > oldValue ? Color.accent2 : Color.subLigtGray)
//                            .frame(width: CGFloat(oldValue / max(oldValue, newValue)) * 150, height: 32)
//                            .cornerRadius(15, corners: [.topLeft, .bottomLeft])
//                    }else{
//                        Rectangle()
//                            .fill(newValue < oldValue ? Color.accent2 : Color.subLigtGray)
//                            .frame(width: CGFloat(oldValue / max(oldValue, newValue)) * 150, height: 32)
//                            .cornerRadius(15, corners: [.topLeft, .bottomLeft])
//                    }
//                    
//                    Text("\(Int(Double(oldValue)))")
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundStyle(.white)
//                        .padding(.trailing, 8)
//                }
//            }
//            
//            Text("VS")
//                .fontWeight(.heavy)
//                .foregroundStyle(.gray)
//                .padding(.horizontal, 10)
//            
//            HStack {
//                ZStack(alignment: .leading) {
//                    if isLowerGood{
//                        Rectangle()
//                            .fill(newValue < oldValue ? Color.accent2 : Color.subLigtGray)
//                            .frame(width: CGFloat(newValue / max(oldValue, newValue)) * 150, height: 32)
//                            .cornerRadius(15, corners: [.topRight, .bottomRight])
//                    }else{
//                        Rectangle()
//                            .fill(newValue > oldValue ? Color.accent2 : Color.subLigtGray)
//                            .frame(width: CGFloat(newValue / max(oldValue, newValue)) * 150, height: 32)
//                            .cornerRadius(15, corners: [.topRight, .bottomRight])
//                    }
//                    
//                    Text("\(Int(Double(newValue)))")
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundStyle(.white)
//                        .padding(.leading, 8)
//                }
//                Spacer()
//            }
//        }
//        .frame(height: 36)
//        .padding(.top, 4)
//    }
//}
//
//// 운동시간 비교
//struct TimeCompareBar: View {
//    let oldValue: Double
//    let newValue: Double
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            HStack {
//                Spacer()
//                ZStack(alignment: .trailing) {
//                    Rectangle()
//                        .fill(Color.subLigtGray) // Color.subLigtGray 대신 기본 색상 사용
//                        .frame(width: CGFloat(oldValue / max(oldValue, newValue)) * 150, height: 32)
//                        .cornerRadius(15, corners: [.topLeft, .bottomLeft])
//                    
//                    Text(formattedTime(oldValue)) // 변수 사용
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundStyle(.white)
//                        .padding(.trailing, 8)
//                }
//            }
//            
//            Text("VS")
//                .fontWeight(.heavy)
//                .foregroundStyle(.gray)
//                .padding(.horizontal, 10)
//            
//            HStack {
//                ZStack(alignment: .leading) {
//                    Rectangle()
//                        .fill(Color.blue)
//                        .frame(width: CGFloat(newValue / max(oldValue, newValue)) * 150, height: 32)
//                        .cornerRadius(15, corners: [.topRight, .bottomRight])
//                    
//                    Text(formattedTime(newValue)) // 변수 사용
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundStyle(.white)
//                        .padding(.leading, 8)
//                }
//                Spacer()
//            }
//        }
//        .frame(height: 36)
//        .padding(.top, 4)
//    }
//    
//    private func formattedTime(_ seconds: Double) -> String {
//        let s = Int(seconds)
//        return String(format: "%02d:%02d:%02d", s / 3600, (s % 3600) / 60, s % 60)
//    }
//}
//
//
//#Preview {
//    HorizontalGraph()
//}
