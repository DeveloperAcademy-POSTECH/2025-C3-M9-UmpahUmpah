import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = TabViewModel()
    @StateObject var swimmingStatsViewModel = SwimmingStatsViewModel()
    
    var body: some View {
        
        TabView(selection: $viewModel.selectedTab) {
            VSView()
                .tabItem {
                    Label("비교", systemImage: "arrow.left.arrow.right.circle")
                        .environment(\.symbolVariants, .none)
                }
                .tag(TabSelection.vs)
            MainView()
                .tabItem {
                    Label("메인", systemImage: "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(TabSelection.main)
            SettingView()
                .tabItem {
                    Label("설정", systemImage: "gearshape")
                        .environment(\.symbolVariants, .none)
                }
                .tag(TabSelection.setting)
        }
        .environmentObject(swimmingStatsViewModel)
        .task {
            await viewModel.requestAuthorization()
        }
    }
}

#Preview {
    MainTabView()
}
