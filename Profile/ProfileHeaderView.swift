import UIKit

// A reusable profile header: circular avatar, name, and a row of stats.
final class ProfileHeaderView: UIView {

    private let avatarView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle.fill")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 44
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .title2)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var statsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        let container = UIStackView(arrangedSubviews: [avatarView, nameLabel, statsStack])
        container.axis = .vertical
        container.alignment = .center
        container.spacing = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 88),
            avatarView.heightAnchor.constraint(equalToConstant: 88),

            container.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),

            statsStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }

    func configure(name: String, posts: Int, followers: Int, following: Int) {
        nameLabel.text = name
        statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        statsStack.addArrangedSubview(makeStat(value: posts, title: "Posts"))
        statsStack.addArrangedSubview(makeStat(value: followers, title: "Followers"))
        statsStack.addArrangedSubview(makeStat(value: following, title: "Following"))
    }

    private func makeStat(value: Int, title: String) -> UIView {
        let valueLabel = UILabel()
        valueLabel.text = "\(value)"
        valueLabel.font = .preferredFont(forTextStyle: .headline)
        valueLabel.textAlignment = .center

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }
}
