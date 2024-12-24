//
//  ExpenseLogApp.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/04.
//

import SwiftUI
import SwiftData

@main
struct ExpenseLogApp: App {
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

    init() {
        let segmentedAppearance = UISegmentedControl.appearance()
        segmentedAppearance.selectedSegmentTintColor = .fillButton
        segmentedAppearance.setTitleTextAttributes([
            .foregroundColor: UIColor.textButton
        ], for: .normal)
        segmentedAppearance.setTitleTextAttributes([
            .foregroundColor: UIColor.white
        ], for: .selected)

        UIView.appearance().tintColor = .textButton

        UITableView.appearance().backgroundColor = .screenBackground
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                year: String(Calendar(identifier: .gregorian).component(.year, from: Date())),
                month: String(Calendar(identifier: .gregorian).component(.month, from: Date()))
            )
        }
        .modelContainer(sharedModelContainer)
    }
}
