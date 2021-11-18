//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Connor A Lynch on 18/11/2021.
//

import SwiftUI

@main
struct BudgetAppApp: App {
    
    let viewContext = PersistenceController.shared.viewContext

    var body: some Scene {
        WindowGroup {
            
            ContentView(viewModel: BudgetListViewModel(viewContext: viewContext))
                .environment(\.managedObjectContext, viewContext)
            
        }
    }
}
