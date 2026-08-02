import Foundation

// Save and load any Codable value as JSON in the Documents directory.
struct FileStorage {

    static let shared = FileStorage()

    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func url(for filename: String) -> URL {
        documentsURL.appendingPathComponent(filename)
    }

    // Encode `value` to JSON and write it atomically.
    func save<T: Encodable>(_ value: T, to filename: String) throws {
        let data = try JSONEncoder().encode(value)
        try data.write(to: url(for: filename), options: [.atomic])
    }

    // Load and decode. Returns nil if the file doesn't exist yet.
    func load<T: Decodable>(_ type: T.Type, from filename: String) throws -> T? {
        let fileURL = url(for: filename)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func delete(_ filename: String) throws {
        let fileURL = url(for: filename)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
}

// Usage:
//   struct TodoItem: Codable { let title: String; var done: Bool }
//   try FileStorage.shared.save(items, to: "todos.json")
//   let items = try FileStorage.shared.load([TodoItem].self, from: "todos.json") ?? []
