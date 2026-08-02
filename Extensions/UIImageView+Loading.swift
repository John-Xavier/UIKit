import UIKit

extension UIImageView {

    // One-liner async image loading with an optional placeholder.
    // Reuses the shared ImageLoader from ../ImageLoading.
    func setImage(from url: URL, placeholder: UIImage? = nil) {
        image = placeholder
        Task { [weak self] in
            let loaded = try? await ImageLoader.shared.image(for: url)
            guard !Task.isCancelled, let loaded else { return }
            self?.image = loaded
        }
    }

    func setImage(from urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else { image = placeholder; return }
        setImage(from: url, placeholder: placeholder)
    }
}
