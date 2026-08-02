import CoreData

// A shared Core Data stack. Requires a Model.xcdatamodeld file (see README).
final class CoreDataStack {

    static let shared = CoreDataStack()
    private init() {}

    // Must match the .xcdatamodeld filename (without extension).
    private let modelName = "Model"

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error {
                // In production, handle this gracefully — don't ship a fatalError.
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
        // Merge background-context changes into the view context automatically.
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    // The main-thread context — use for anything driving the UI.
    var viewContext: NSManagedObjectContext { container.viewContext }

    // A private-queue context for heavy work off the main thread.
    func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    // Save only if there are unsaved changes.
    func saveContext(_ context: NSManagedObjectContext? = nil) {
        let context = context ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            print("Core Data save error: \(error)")
        }
    }
}
