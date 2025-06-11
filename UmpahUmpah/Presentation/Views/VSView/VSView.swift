import SwiftUI

struct VSView: View {
    @EnvironmentObject var swimmingStatsViewModel: SwimmingStatsViewModel
    @StateObject private var feedbackViewModel = VSFeedbackViewModel(
        useCase: RequestFeedbackUseCaseImpl(repository: ChatGPTRepositoryImpl())
    )
    
    private var safeOldScore: Double {
        switch swimmingStatsViewModel.comparisonState {
        case .onlyPastExists, .compareReady:
            return swimmingStatsViewModel.pastInfo?.overallScore ?? 0.0
        default:
            return 0.0
        }
    }
    
    private var safeNewScore: Double {
        switch swimmingStatsViewModel.comparisonState {
        case .todayOnly, .compareReady:
            return swimmingStatsViewModel.todayInfo?.overallScore ?? 0.0
        default:
            return 0.0
        }
    }
    
    var body: some View {
        VStack {
            VSScoreSectionView(
                oldValue: safeOldScore,
                newValue: safeNewScore
                
            )
            // MARK: View 분기 처리
            Group {
                switch swimmingStatsViewModel.comparisonState {
                case .noDataAtAll:
                    VStack {
                        Spacer()
                        Text("오늘도 과거도 수영 기록이 없어요\n🏊")
                            .font(.system(size: 16))
                            .foregroundColor(.subGray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                        Spacer()
                    }
                    
                case .onlyPastExists:
                    VStack {
                        Spacer()
                        Text("오늘 기록은 없지만,\n예전에 수영한 기록이 있어요! 📘")
                            .font(.system(size: 16))
                            .foregroundColor(.subGray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                        Spacer()
                    }
                    
                case .todayOnly:
                    VStack {
                        Spacer()
                        Text("과거 기록이 없어 비교할 수는 없지만,\n오늘의 기록만으로도 멋져요! 💪")
                            .font(.system(size: 16))
                            .foregroundColor(.subGray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                        Spacer()
                    }
                    
                case .compareReady:
                    if let today = swimmingStatsViewModel.todayInfo,
                       let past = swimmingStatsViewModel.pastInfo {
                        
                        ScrollView {
                            VStack {
                                // MARK: VS 점수 헤더, 데이터 없는 경우 -- 표시
                                
                                // MARK: 펼치는 박스
                                ExpandableBox(
                                    viewModel: feedbackViewModel,
                                    swimData: today
                                )
                                .padding(.vertical, 20)
                                
                                // MARK: 그래프들
                                
                                VStack {
                                    HorizontalGraph(
                                        oldValue: past.score.stabilityScore,
                                        newValue: today.score.stabilityScore,
                                        title: "안정지수"
                                    )
                                    .padding(5)
                                    .zIndex(9)
                                    
                                    HorizontalGraph(
                                        oldValue: past.score.strokeEfficiency,
                                        newValue: today.score.strokeEfficiency,
                                        title: "스트로크 효율성"
                                    )
                                    .padding(5)
                                    .zIndex(8)
                                    
                                    HorizontalGraph(
                                        oldValue: past.score.immersionScore,
                                        newValue: today.score.immersionScore,
                                        title: "몰입도 점수"
                                    )
                                    .padding(5)
                                    .zIndex(7)
                                    
                                    HorizontalGraph(
                                        oldValue: Double(past.workout.pacePer100m),
                                        newValue: Double(today.workout.pacePer100m),
                                        title: "SWOLF"
                                    )
                                    .padding(5)
                                    .zIndex(6)
                                    
                                    HorizontalGraph(
                                        oldValue: past.workout.duration,
                                        newValue: today.workout.duration,
                                        title: "운동시간"
                                    )
                                    .padding(5)
                                    .zIndex(5)
                                    
                                    HorizontalGraph(
                                        oldValue: past.workout.distance,
                                        newValue: today.workout.distance,
                                        title: "총거리"
                                    )
                                    .padding(5)
                                    .zIndex(4)
                                    
                                    HorizontalGraph(
                                        oldValue: past.overallScore,
                                        newValue: today.overallScore,
                                        title: "칼로리"
                                    )
                                    .padding(5)
                                    .zIndex(3)
                                    
                                    HorizontalGraph(
                                        oldValue: Double(past.workout.lapCount),
                                        newValue: Double(today.workout.lapCount),
                                        title: "랩수"
                                    )
                                    .padding(5)
                                    .zIndex(2)
                                    
                                    HorizontalGraph(
                                        oldValue: Double(past.averageHeartRate ?? 1.0),
                                        newValue: Double(today.averageHeartRate ?? 1.0),
                                        title: "심박수"
                                    )
                                    .padding(5)
                                    .zIndex(1)
                                }
                                
                            }
                            .padding(.bottom, 20)
                        }
                        .alert("네트워크 오류", isPresented: $feedbackViewModel.showErrorAlert) {
                            Button("확인") {
                                feedbackViewModel.showErrorAlert = false
                            }
                            Button("재시도") {
                                if let todayInfo = swimmingStatsViewModel.todayInfo {
                                    feedbackViewModel.fetchFeedback(from: todayInfo)
                                }
                            }
                        } message: {
                            Text(feedbackViewModel.errorMessage ?? "")
                        }
                        
                    }
                    
                    
                }
            }
            .onAppear {
                Task {
                    await swimmingStatsViewModel.loadLatestTwoSummaries()
                    feedbackViewModel.loadTodayFeedback()
                }
            }
        }
    }
}

#Preview {
    
    VSView()
        .environmentObject(SwimmingStatsViewModel())
}
