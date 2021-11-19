//
//  ContentView.swift
//  BudgetApp
//
//  Created by Connor A Lynch on 18/11/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject var viewModel: BudgetListViewModel
    
    init(viewModel: BudgetListViewModel){
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    func deleteBudget(at offsets: IndexSet){
        offsets.forEach { index in
            let budget = viewModel.budgets[index]
            viewModel.deleteBudget(budgetId: budget.id)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.budgets) { budget in
                        HStack {
                            Text(budget.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(budget.amount, specifier: "%.2f")")
                        }
                    }.onDelete(perform: deleteBudget)
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
