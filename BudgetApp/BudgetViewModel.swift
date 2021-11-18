//
//  BudgetViewModel.swift
//  BudgetApp
//
//  Created by Connor A Lynch on 18/11/2021.
//

import CoreData
import Foundation

struct BudgetViewModel: Identifiable {
    private let budget: BudgetEntity
    
    init(budget: BudgetEntity){
        self.budget = budget
    }
    
    var id: NSManagedObjectID {
        return budget.objectID
    }
    
    var title: String {
        return budget.title ?? ""
    }
    
    var amount: Double {
        return budget.amount
    }
}
