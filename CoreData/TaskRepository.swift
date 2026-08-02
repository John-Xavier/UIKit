import CoreData

// CRUD for the TaskEntity. Assumes an entity `TaskEntity` with:
//   id: UUID, title: String, isDone: Bool, createdAt: Date  (see README)
//
// With Codegen = "Class Definition", Xcode generates `TaskEntity` for you.
final class TaskRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }

    // CREATE
    @discardableResult
    func add(title: String) -> TaskEntity {
        let task = TaskEntity(context: context)
        task.id = UUID()
        task.title = title
        task.isDone = false
        task.createdAt = Date()
        CoreDataStack.shared.saveContext(context)
        return task
    }

    // READ (newest first)
    func fetchAll() -> [TaskEntity] {
        let request = TaskEntity.fetchRequest() as! NSFetchRequest<TaskEntity>
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }

    // READ with a filter
    func fetchPending() -> [TaskEntity] {
        let request = TaskEntity.fetchRequest() as! NSFetchRequest<TaskEntity>
        request.predicate = NSPredicate(format: "isDone == NO")
        return (try? context.fetch(request)) ?? []
    }

    // UPDATE
    func toggleDone(_ task: TaskEntity) {
        task.isDone.toggle()
        CoreDataStack.shared.saveContext(context)
    }

    // DELETE
    func delete(_ task: TaskEntity) {
        context.delete(task)
        CoreDataStack.shared.saveContext(context)
    }

    // A fetched results controller drives a live-updating table (pair with a
    // diffable data source and implement NSFetchedResultsControllerDelegate).
    func makeFetchedResultsController() -> NSFetchedResultsController<TaskEntity> {
        let request = TaskEntity.fetchRequest() as! NSFetchRequest<TaskEntity>
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
}
