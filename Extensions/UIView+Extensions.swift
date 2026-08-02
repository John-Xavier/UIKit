import UIKit

extension UIView {

    // Add several subviews in one call.
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    // Pin this view to fill another (edge to edge), respecting optional insets.
    func pinToEdges(of other: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func roundCorners(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func addShadow(color: UIColor = .black, opacity: Float = 0.15,
                   radius: CGFloat = 6, offset: CGSize = CGSize(width: 0, height: 3)) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false // shadows need this off
    }

    // Walk the responder chain to find the owning view controller.
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let vc = next as? UIViewController { return vc }
            responder = next
        }
        return nil
    }
}
