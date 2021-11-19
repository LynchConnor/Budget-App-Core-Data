//
//  BudgetListViewModel.swift
//  BudgetApp
//
//  Created by Connor A Lynch on 18/11/2021.
//

import CoreData
import Foundation

class BudgetListViewModel: NSObject, ObservableObject {
    private var viewContext: NSManagedObjectContext
    
    @Published var sheetActive: Bool = false
    
    @Published var budgets = [BudgetViewModel]()
    
    private let fetchedResultsController: NSFetchedResultsController<BudgetEntity>
    
    static var fetchRequest: NSFetchRequest<BudgetEntity> {
        let request = BudgetEntity.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    init(viewContext: NSManagedObjectContext){
        
        self.viewContext = viewContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: BudgetListViewModel.fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        self.fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            
            guard let budgets = fetchedResultsController.fetchedObjects else { return }
            
            DispatchQueue.main.async {
                self.budgets = budgets.map(BudgetViewModel.init)
            }
            
        }catch let error {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func deleteBudget(budgetId id: NSManagedObjectID){
        do {
            guard let budget = try viewContext.existingObject(with: id) as? BudgetEntity else { return }
            
            viewContext.delete(budget)
            
            try viewContext.save()
        }catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
}

extension BudgetListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let budgets = controller.fetchedObjects as? [BudgetEntity] else { return }
        DispatchQueue.main.async {
            self.budgets = budgets.map(BudgetViewModel.init)
        }
    }
}
