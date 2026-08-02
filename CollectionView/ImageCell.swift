import UIKit

// A grid cell that displays a single image loaded asynchronously from a URL.
final class ImageCell: UICollectionViewCell {

    static let reuseID = "ImageCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // Track the in-flight task so we can cancel it on reuse.
    private var loadTask: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // Uses the shared ImageLoader from ../ImageLoading.
    func configure(with url: URL) {
        loadTask = Task { [weak self] in
            let image = try? await ImageLoader.shared.image(for: url)
            guard !Task.isCancelled else { return }
            self?.imageView.image = image
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        loadTask?.cancel()      // stop the old download…
        loadTask = nil
        imageView.image = nil   // …and clear the stale image.
    }
}
