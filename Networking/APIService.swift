import Foundation

// A small, reusable async networking client.
final class APIService {

    static let shared = APIService()
    private init() {}

    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase   // snake_case → camelCase
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    enum APIError: LocalizedError {
        case invalidResponse
        case status(Int)
        case decoding(Error)

        var errorDescription: String? {
            switch self {
            case .invalidResponse: return "The server response was invalid."
            case .status(let code): return "Request failed with status \(code)."
            case .decoding: return "Could not read the server response."
            }
        }
    }

    // MARK: - Generic request

    private func request<T: Decodable>(_ endpoint: String,
                                       method: String = "GET",
                                       body: Data? = nil) async throws -> T {
        var req = URLRequest(url: baseURL.appendingPathComponent(endpoint))
        req.httpMethod = method
        if let body {
            req.httpBody = body
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else { throw APIError.status(http.statusCode) }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    // MARK: - Endpoints

    func fetchUsers() async throws -> [User] {
        try await request("users")
    }

    func fetchPosts(userId: Int) async throws -> [Post] {
        try await request("posts?userId=\(userId)")
    }

    func create(post: NewPost) async throws -> Post {
        let body = try JSONEncoder().encode(post)
        return try await request("posts", method: "POST", body: body)
    }
}
