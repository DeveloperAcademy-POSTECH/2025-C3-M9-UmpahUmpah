import SwiftUI
import UIKit

struct HealthDataLinkView: View {
    @StateObject private var hk = HealthKitManager.shared
    @Environment(\.scenePhase) private var scenePhase
    // 퍼미션 없음 상태에서 토글 ON 시 경고창 표시용
    @State private var showPermissionAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 24) {
                // 1. 권한 상태 안내 + 설정 이동 버튼
                
                HStack {
                    Text("Apple 건강")
                        .font(.body)
                    Spacer()
                    Group {
                        switch hk.authorizationState {
                        case .authorized:
                            infoRow(text: "권한 요청됨", color: .green)
                        case .denied:
                            infoRow(text: "권한 요청 필요", color: .red)
                        case .unknown:
                            infoRow(text: "권한 확인 중...", color: .secondary)
                        }
                    }
                }
                .padding(.top, 20)
                Spacer()
                HStack {
                    Spacer()
                    emptyRecordView()
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width)
            .navigationTitle("건강 데이터 연동")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
            .task { await hk.requestAuthorization() } // 진입 시 권한 요청
            .onChange(of: scenePhase) { phase in // 포그라운드 복귀 시 권한 갱신
                if phase == .active {
                    Task { await hk.refreshAuthorizationStatus() }
                }
            }
        }
    }
    
    // MARK: - Sub-view
    
    @ViewBuilder
    private func infoRow(text: String, color: Color) -> some View {
        HStack {
            Circle()
                .frame(width: 8, height: 8)
                .foregroundColor(color)
            Text(text)
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.subBlack)
        }
    }
}

struct emptyRecordView: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("최근 수영 기록이 안보이시면")
                .font(.callout)
                .foregroundColor(Color.subGray)
            Text("'Apple 건강 - 프로필 - 앱 - 음파음파 에서'")
                .font(.callout)
                .foregroundColor(Color.subGray)
            Text("권한 설정을 확인해주세요.")
                .font(.callout)
                .foregroundColor(Color.subGray)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}
