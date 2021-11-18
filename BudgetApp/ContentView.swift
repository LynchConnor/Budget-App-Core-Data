//
//  ContentView.swift
//  BudgetApp
//
//  Created by Connor A Lynch on 18/11/2021.
//

import SwiftUI
import CoreData

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
}

extension BudgetListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let budgets = controller.fetchedObjects as? [BudgetEntity] else { return }
        DispatchQueue.main.async {
            self.budgets = budgets.map(BudgetViewModel.init)
        }
    }
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject var viewModel: BudgetListViewModel
    
    init(viewModel: BudgetListViewModel){
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.budgets) { budget in
                        HStack {
                            Text(budget.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(budget.amount)")
                        }
                    }
                }
            }
            .navigationTitle("Budget App")
            .sheet(isPresented: $viewModel.sheetActive) {
                AddBudget(viewModel: AddBudget.ViewModel(viewContext: viewContext))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.sheetActive = true
                    } label: {
                        Text("Add Budget")
                    }

                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: BudgetListViewModel(viewContext: PersistenceController.shared.viewContext))
            .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
    }
}
