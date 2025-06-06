import SwiftUI

struct VSView: View {
    @StateObject private var viewModel = VSFeedbackViewModel(
        useCase: RequestFeedbackUseCaseImpl(repository: ChatGPTRepositoryImpl())
    )
    @EnvironmentObject var swimmingStatsViewModel: SwimmingStatsViewModel

    // API 테스트용 목업 데이터
    private var mockDailyInfo: DailySwimmingInfo {
        let mockWorkout = SwimmingWorkout(
            id: UUID(),
            startDate: Date().addingTimeInterval(-3600), // 1시간 전
            endDate: Date(),
            duration: 3600, // 1시간
            distance: 1500, // 1.5km
            energy: 450, // 450kcal
            lapCount: 30
        )

        let mockScore = SwimmingScore(
            stabilityScore: 85.5,
            strokeEfficiency: 2.1,
            immersionScore: 78.3
        )

        let mockHeartRates = [
            HeartRateSample(bpm: 140, date: Date().addingTimeInterval(-1800)),
            HeartRateSample(bpm: 150, date: Date().addingTimeInterval(-900)),
            HeartRateSample(bpm: 145, date: Date())
        ]

        let mockStrokeInfos = [
            StrokeInfo(
                start: Date().addingTimeInterval(-3600),
                end: Date().addingTimeInterval(-1800),
                count: 450,
                style: .freestyle
            )
        ]

        return DailySwimmingInfo(
            date: Calendar.current.startOfDay(for: Date()),
            workout: mockWorkout,
            score: mockScore,
            heartRates: mockHeartRates,
            strokeInfos: mockStrokeInfos,
            overallScore: 82.5
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: VS 점수 헤더

                VSScoreSectionView()

                // MARK: 펼치는 박스

                // 실제 데이터가 있으면 사용, 없으면 목업 데이터 사용
                let dailyInfo = swimmingStatsViewModel.currentDailyInfo ?? mockDailyInfo

                ExpandableBox(
                    viewModel: viewModel,
                    swimData: dailyInfo
                )
                .padding(.vertical, 20)

                // MARK: 그래프들

                ForEach(1 ... 10, id: \.self) { _ in
                    HorizontalGraph()
                }

                .padding(.vertical, 10)
                .padding(.horizontal)
            }
            .onAppear {
                viewModel.loadTodayFeedback()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    VSView()
}
