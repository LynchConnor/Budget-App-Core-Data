//
//  AddBudget.swift
//  BudgetApp
//
//  Created by Connor A Lynch on 18/11/2021.
//

import SwiftUI
import CoreData

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

struct AddBudget: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel){
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Form {
                TextField("Title", text: $viewModel.title)
                TextField("Amount", text: $viewModel.amount)
                Button {
                    viewModel.addBudget()
                    dismiss()
                } label: {
                    Text("Add Budget")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                }
                .cornerRadius(5)

            }
        }
    }
}

struct AddBudget_Previews: PreviewProvider {
    static var previews: some View {
        AddBudget(viewModel: AddBudget.ViewModel(viewContext: PersistenceController.shared.viewContext))
    }
}
