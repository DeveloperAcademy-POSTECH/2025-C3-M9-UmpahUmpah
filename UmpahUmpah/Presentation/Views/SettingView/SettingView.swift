import SwiftUI

struct SettingView: View {
    @StateObject private var hk = HealthKitManager.shared
    @State private var pushLink = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - 상단 헤더
                headerView()
                
                // MARK: - 설정 항목들
                settingRow(title: "건강 데이터 연동", showChevron: true) {
                    Task {
                        switch hk.authorizationState {
                        case .authorized: 
                            pushLink = true
                        case .denied, .unknown:
                            showPermissionAlert()
                        }
                    }
                }
                .background(
                    NavigationLink(destination: HealthDataLinkView(),
                                   isActive: $pushLink) { EmptyView() }
                        .opacity(0)
                )
                
                settingRow(title: "개인정보 처리 방침", showChevron: false) {
                    if let url = URL(string: "https://swift2025.notion.site/20b34b48a8948081bbedf54c9717b94f?source=copy_link") {
                        UIApplication.shared.open(url)
                    }
                }
                
                // MARK: - 버전 정보
                versionView()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Helper Views
    
    private func headerView() -> some View {
        Text("설정")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.top, 5)
            .padding(.bottom, 20)
            .background(Color.brand.ignoresSafeArea(edges: .top))
            .padding(.bottom, 16)
    }
    
    private func settingRow(title: String, showChevron: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color.subBlack)
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .buttonStyle(.plain)
    }
    
    private func versionView() -> some View {
        Text("버전 정보 1.0.0")
            .font(.caption)
            .foregroundColor(Color.subGray)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
    }
    
    // MARK: - Helpers
    
    private var subtitle: String {
        switch hk.authorizationState {
        case .authorized:
            return hk.integrationEnabled ? "Apple 건강 연동됨" : "연동 꺼짐"
        case .denied:
            return "권한 필요"
        case .unknown:
            return "권한 확인 중..."
        }
    }
    
    private func showPermissionAlert() {
        // TODO: Alert 구현
    }
}

#Preview {
    SettingView()
}
