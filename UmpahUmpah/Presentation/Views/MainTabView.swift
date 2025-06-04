import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            Text("VSView")
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right.circle")
                    Text("비교")
                }
            Text("MainView")
                .tabItem {
                    Image(systemName: "house")
                    Text("메인")
                }
            Text("SettingView")
                .tabItem {
                    Image(systemName: "gear")
                    Text("설정")
                }
        }
    }
}

#Preview {
    MainTabView()
}
