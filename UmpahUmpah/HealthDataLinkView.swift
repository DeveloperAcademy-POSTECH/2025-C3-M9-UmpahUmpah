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
                Text("건강 데이터 연동")
                    .font(.title2).bold()

                // 1. 권한 상태 안내 + 설정 이동 버튼
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

                Button("설정 열기") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .font(.body)
                .foregroundColor(.blue)

                // 2. 권한 여부와 무관하게 토글 노출
                Toggle(isOn: integrationBinding) {
                    Text("Apple 건강 연동")
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding(.trailing)

                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width)
            .navigationTitle("건강 데이터 연동")
            .task { await hk.requestAuthorization() } // 진입 시 권한 요청
            .onChange(of: scenePhase) { phase in // 포그라운드 복귀 시 권한 갱신
                if phase == .active {
                    Task { await hk.refreshAuthorizationStatus() }
                }
            }
            .alert("HealthKit 권한 필요", isPresented: $showPermissionAlert) {
                Button("설정 열기") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("취소", role: .cancel) {}
            } message: {
                Text("""
                iOS 설정에서 HealthKit 접근을 허용해야 ‘음파음파’가 데이터를 연동할 수 있습니다.
                설정 > 건강 > 데이터 접근 및 기기 > 음파음파 를 확인해 주세요.
                """)
            }
        }
    }

    // MARK: - 커스텀 바인딩

    /// 퍼미션이 없을 때 토글을 ON하면 Alert만 띄우고 실제 값은 변경하지 않음
    private var integrationBinding: Binding<Bool> {
        Binding(
            get: { hk.integrationEnabled },
            set: { newValue in
                if newValue { // ON 시도
                    if hk.authorizationState == .authorized {
                        hk.integrationEnabled = true // 정상 활성화
                    } else {
                        showPermissionAlert = true // 퍼미션 없음 → 경고
                    }
                } else { // OFF 시도
                    hk.integrationEnabled = false
                }
            }
        )
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
