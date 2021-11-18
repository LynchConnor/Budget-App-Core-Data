//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Connor A Lynch on 18/11/2021.
//

import SwiftUI

@main
struct BudgetAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
