//
//  UmpahUmpahApp.swift
//  UmpahUmpah
//
//  Created by kirby on 5/26/25.
//

import SwiftData
import SwiftUI

@main
struct UmpahUmpahApp: App {
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var chartViewModel = ChartViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
        }
    }
}
