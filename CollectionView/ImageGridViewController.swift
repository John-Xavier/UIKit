import UIKit

// A responsive 3-column photo grid using compositional layout + diffable data source.
final class ImageGridViewController: UICollectionViewController {

    enum Section { case main }

    // Replace with your real image URLs.
    private let imageURLs: [URL] = (1...30).compactMap {
        URL(string: "https://picsum.photos/id/\($0)/300/300")
    }

    private lazy var dataSource = makeDataSource()

    // MARK: - Init with a compositional layout

    init() {
        super.init(collectionViewLayout: Self.makeLayout())
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos"
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        applySnapshot()
    }

    // MARK: - Layout: 3 items per row, square, with spacing

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1/3),
                              heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .fractionalWidth(1/3)), // square rows
            subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - Diffable data source

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, URL> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, url in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
            cell.configure(with: url)
            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, URL>()
        snapshot.appendSections([.main])
        snapshot.appendItems(imageURLs)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Selection

    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        guard let url = dataSource.itemIdentifier(for: indexPath) else { return }
        print("Tapped image: \(url)")
    }
}
