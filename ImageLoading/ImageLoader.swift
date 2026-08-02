import UIKit

// A tiny, thread-safe async image loader with an in-memory cache.
// Usage:  let image = try await ImageLoader.shared.image(for: url)
actor ImageLoader {

    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()

    // De-duplicate concurrent requests for the same URL.
    private var inFlight: [URL: Task<UIImage, Error>] = [:]

    enum LoaderError: Error { case decodingFailed }

    func image(for url: URL) async throws -> UIImage {
        // 1. Cache hit?
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }

        // 2. Already downloading this URL? Await the same task.
        if let existing = inFlight[url] {
            return try await existing.value
        }

        // 3. Start a new download.
        let task = Task<UIImage, Error> {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { throw LoaderError.decodingFailed }
            return image
        }
        inFlight[url] = task

        do {
            let image = try await task.value
            cache.setObject(image, forKey: url as NSURL)
            inFlight[url] = nil
            return image
        } catch {
            inFlight[url] = nil
            throw error
        }
    }
}
