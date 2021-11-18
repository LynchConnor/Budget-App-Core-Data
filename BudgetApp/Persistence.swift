
import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "BudgetApp")
        container.loadPersistentStores { storeDescriptor, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
        }
    }
}
