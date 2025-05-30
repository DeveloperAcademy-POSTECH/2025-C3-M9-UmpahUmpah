//
//  AppDelegate.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 5/29/25.
//

import SwiftUI

struct MyAppApp: App {
    var body: some Scene {
        WindowGroup {
            ExAppCoordinator.makeTodoListView()
        }
    }
}
