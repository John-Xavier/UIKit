import Foundation

// Example models that mirror a JSON API (e.g. jsonplaceholder.typicode.com).
struct User: Codable, Hashable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

// Body you'd POST to create a resource.
struct NewPost: Codable {
    let title: String
    let body: String
    let userId: Int
}

struct Post: Codable, Hashable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
