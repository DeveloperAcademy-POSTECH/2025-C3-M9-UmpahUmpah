import SwiftUI

struct VSView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: VS 점수 헤더

                VSScoreSectionView()

                // MARK: 펼치는 박스

                ExpandableBox {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🏊‍♂️ 스트로크 분석")
                            .font(.headline)
                        Text("오늘 스트로크 효율성이 5% 향상되었습니다!")

                        Text("📊 안정성 지수")
                            .font(.headline)
                        Text("물 위에서의 균형감이 좋아졌어요.")
                    }
                }
                .padding(.vertical, 20)

                // MARK: 그래프들

                ForEach(1 ... 10, id: \.self) { _ in
                    HorizontalGraph()
                }

                .padding(.vertical, 10)
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    VSView()
}
