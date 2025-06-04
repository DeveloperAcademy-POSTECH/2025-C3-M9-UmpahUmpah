import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("비교")
                .tabItem {
                    Label("비교", systemImage: "arrow.left.arrow.right.circle")
                }
            MainView()
                .tabItem {
                    Label("메인", systemImage: "house")
                }
            SettingView()
                .tabItem {
                    Label("설정", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainTabView()
}
