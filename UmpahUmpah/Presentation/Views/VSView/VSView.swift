import SwiftUI

struct VSView: View {
    @StateObject private var viewModel = VSFeedbackViewModel(
        useCase: RequestFeedbackUseCaseImpl(repository: ChatGPTRepositoryImpl())
    )
  
    @EnvironmentObject var swimmingStatsViewModel: SwimmingStatsViewModel
    @StateObject var oldSwimmingStatsViewModel: SwimmingStatsViewModel = SwimmingStatsViewModel()
    @StateObject var newSwimmingStatsViewModel: SwimmingStatsViewModel = SwimmingStatsViewModel()
    

    
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
                
                VSScoreSectionView(oldValue: oldSwimmingStatsViewModel.dailySummaries.first?.overallScore ?? 0.0,
                                   newValue: newSwimmingStatsViewModel.dailySummaries.first?.overallScore ?? 0.0)
                
                // MARK: 펼치는 박스
                
                // 실제 데이터가 있으면 사용, 없으면 목업 데이터 사용
                let dailyInfo = newSwimmingStatsViewModel.currentDailyInfo ?? mockDailyInfo
                
                ExpandableBox(
                    viewModel: viewModel,
                    swimData: dailyInfo
                )
                .padding(.vertical, 20)
                
                // MARK: 그래프들

                VStack(){
                    HorizontalGraph(
                        oldValue: oldSwimmingStatsViewModel.dailySummaries.first?.score.stabilityScore ?? 1.0,
                        newValue: newSwimmingStatsViewModel.dailySummaries.first?.score.stabilityScore ?? 1.0,
                        title: "안정지수"
                    )
                    .padding(5)
                    .zIndex(9)

                    HorizontalGraph(
                        oldValue: oldSwimmingStatsViewModel.dailySummaries.first?.score.strokeEfficiency ?? 1.0,
                        newValue: newSwimmingStatsViewModel.dailySummaries.first?.score.strokeEfficiency ?? 1.0,
                        title: "스트로크 효율성"
                    )
                    .padding(5)
                    .zIndex(8)

                    HorizontalGraph(
                        oldValue: oldSwimmingStatsViewModel.dailySummaries.first?.score.immersionScore ?? 1.0,
                        newValue: newSwimmingStatsViewModel.dailySummaries.first?.score.immersionScore ?? 1.0,
                        title: "몰입도 점수"
                    )
                    .padding(5)
                    .zIndex(7)
                    
                    HorizontalGraph(
                        oldValue: Double(oldSwimmingStatsViewModel.dailySummaries.first?.workout.pacePer100m ?? 1),
                        newValue: Double(newSwimmingStatsViewModel.dailySummaries.first?.workout.pacePer100m ?? 1),
                        title: "SWOLF"
                    )
                    .padding(5)
                    .zIndex(6)
                    
                    HorizontalGraph(
                        oldValue: oldSwimmingStatsViewModel.dailySummaries.first?.workout.duration ?? 3600.0,
                        newValue: newSwimmingStatsViewModel.dailySummaries.first?.workout.duration ?? 3200.0,
                        title: "운동시간"
                    )
                    .padding(5)
                    .zIndex(5)

                    HorizontalGraph(
                        oldValue: oldSwimmingStatsViewModel.dailySummaries.first?.workout.distance ?? 100.0,
                        newValue: newSwimmingStatsViewModel.dailySummaries.first?.workout.distance ?? 90.0,
                        title: "총거리"
                    )
                    .padding(5)
                    .zIndex(4)

                    HorizontalGraph(
                        oldValue: oldSwimmingStatsViewModel.dailySummaries.first?.overallScore ?? 1.0,
                        newValue: newSwimmingStatsViewModel.dailySummaries.first?.overallScore ?? 1.0,
                        title: "칼로리"
                    )
                    .padding(5)
                    .zIndex(3)

                    HorizontalGraph(
                        oldValue: Double(oldSwimmingStatsViewModel.dailySummaries.first?.workout.lapCount ?? 1),
                        newValue: Double(newSwimmingStatsViewModel.dailySummaries.first?.workout.lapCount ?? 1),
                        title: "랩수"
                    )
                    .padding(5)
                    .zIndex(2)

                    HorizontalGraph(
                        oldValue: Double(oldSwimmingStatsViewModel.dailySummaries.first?.averageHeartRate ?? 1.0),
                        newValue: Double(newSwimmingStatsViewModel.dailySummaries.first?.averageHeartRate ?? 1.0),
                        title: "심박수"
                    )
                    .padding(5)
                    .zIndex(1)

                    
                }
            }
            .padding(.bottom, 100)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            viewModel.loadTodayFeedback()
            Task {
                // oldSwimmingStatsViewModel은 두 번째로 최근 데이터 로드
                await oldSwimmingStatsViewModel.loadSecondLatestSwimmingData()
                // newSwimmingStatsViewModel은 가장 최근 데이터 로드
                await newSwimmingStatsViewModel.loadLatestSwimmingData()
            }
        }
        .alert("네트워크 오류", isPresented: $viewModel.showErrorAlert) {
            Button("확인") {
                viewModel.showErrorAlert = false
            }
            Button("재시도") {
                let dailyInfo = swimmingStatsViewModel.currentDailyInfo ?? mockDailyInfo
                viewModel.fetchFeedback(from: dailyInfo)
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .ignoresSafeArea()
    }
}


#Preview {
    VSView()
}
