//
//  TabViewModel.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 6/5/25.
//

import Foundation

final class TabViewModel: ObservableObject {
    @Published var selectedTab: TabSelection = .main
    
    func requestAuthorization() async {
        do {
            try await HealthKitManager.shared.requestAuthorization()
        } catch {
            print("request authorization error: \(error)")
        }
    }
}
