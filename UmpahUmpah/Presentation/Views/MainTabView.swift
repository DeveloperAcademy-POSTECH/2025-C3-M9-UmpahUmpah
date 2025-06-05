import SwiftUI

enum TabSelection {
    case vs
    case main
    case setting
}

struct MainTabView: View {
    @State private var selectedTab: TabSelection = .main
    var body: some View {
        TabView(selection: $selectedTab) {
            VSView()
                .tabItem {
                    Label("비교", systemImage: "arrow.left.arrow.right.circle")
                }
                .tag(TabSelection.vs)
            MainView()
                .tabItem {
                    Label("메인", systemImage: "house")
                }
                .tag(TabSelection.main)
            SettingView()
                .tabItem {
                    Label("설정", systemImage: "gear")
                }
                .tag(TabSelection.setting)
        }
    }
}

#Preview {
    MainTabView()
}
