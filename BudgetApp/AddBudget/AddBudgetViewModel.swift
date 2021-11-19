//
//  AddBudgetViewModel.swift
//  BudgetApp
//
//  Created by Connor A Lynch on 18/11/2021.
//

import CoreData
import Foundation

extension AddBudget {
    class ViewModel: ObservableObject {
        @Published var title: String = ""
        @Published var amount: String = ""
        
        var viewContext: NSManagedObjectContext
        
        init(viewContext: NSManagedObjectContext){
            self.viewContext = viewContext
        }
        
        func addBudget(){
            let budget = BudgetEntity(context: viewContext)
            budget.title = title
            budget.amount = Double(amount) ?? 0
            do {
                try viewContext.save()
            }catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
}
