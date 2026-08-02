# Core Data Starter

Local database for larger or relational data. This is the minimal setup: a stack, and create/read/update/delete on a `Task` entity.

## Files

- [`CoreDataStack.swift`](./CoreDataStack.swift) — a shared `NSPersistentContainer` wrapper with save + background context.
- [`TaskRepository.swift`](./TaskRepository.swift) — CRUD example (add/fetch/toggle/delete) with a `NSFetchedResultsController` hook for tables.

## One-time setup in Xcode

Core Data needs a **data model file** (the entities live there, not in code):

1. **File → New → File → Core Data → Data Model.** Name it `Model.xcdatamodeld` (match `CoreDataStack`'s `modelName`).
2. Add an **Entity** named `TaskEntity` with attributes:
   - `id: UUID`
   - `title: String`
   - `isDone: Boolean`
   - `createdAt: Date`
3. In the Data Model inspector, set **Codegen = Class Definition** (Xcode generates the `TaskEntity` `NSManagedObject` subclass for you).

That's it — no `NSManagedObject` subclass to hand-write.

## The mental model

```
NSPersistentContainer
   ├── viewContext      → the main-thread context; read/write here for UI
   └── newBackgroundContext() → heavy imports/deletes off the main thread
```

- A **context** is a scratchpad. You make changes, then **`save()`** to persist them.
- A **fetch request** queries entities (with `NSPredicate` filters and `NSSortDescriptor`s).
- For live-updating tables, an **`NSFetchedResultsController`** tells you exactly which rows changed — pair it with a diffable data source.

## Core Data vs. simpler options

| Need | Use |
|---|---|
| A few settings | UserDefaults (`../Persistence`) |
| A cached list, no queries | Codable → JSON (`../Persistence`) |
| Thousands of rows, filtering, relationships, live table updates | **Core Data** |
| Cross-platform / SQL-first / lighter API | SQLite via GRDB, or SwiftData (iOS 17+) |
