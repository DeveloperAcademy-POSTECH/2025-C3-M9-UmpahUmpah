import SwiftUI

struct SettingView: View {
    @StateObject private var hk = HealthKitManager.shared
    @State private var pushLink = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        Task {
                            switch hk.authorizationState {
                            case .authorized: pushLink = true
                            case .denied, .unknown:
                                showPermissionAlert()
                            }
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("건강 데이터 연동")
                                    .font(.headline)
                                Text(subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .background(
                        NavigationLink(destination: HealthDataLinkView(),
                                       isActive: $pushLink) { EmptyView() }
                            .opacity(0)
                    )
                }

                Section("앱 정보") {
                    Text("버전 1.0.0")
                        .foregroundColor(.gray)
                }
                Section("개발자") {
                    Text("음파음파 개발팀")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("설정")
    }

    // MARK: - Helpers

    private var subtitle: String {
        switch hk.authorizationState {
        case .authorized:
            return hk.integrationEnabled ? "Apple 건강 연동됨"
                : "연동 꺼짐"
        case .denied:
            return "권한 필요"
        case .unknown:
            return "권한 확인 중..."
        }
    }

    private func showPermissionAlert() {
        // HealthDataLinkView 와 동일 Alert 로직 재사용하거나
        // 별도 @State 플래그로 local alert 구현
    }
}
