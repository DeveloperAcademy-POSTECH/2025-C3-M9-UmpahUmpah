import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = TabViewModel()
    
    var body: some View {
        
        TabView(selection: $viewModel.selectedTab) {
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
        .task {
            await viewModel.requestAuthorization()
        }
    }
}

#Preview {
    MainTabView()
}
