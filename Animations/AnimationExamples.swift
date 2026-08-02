import UIKit

// Reusable animation helpers. Call them on any UIView.
extension UIView {

    // Fade in / out.
    func fadeIn(duration: TimeInterval = 0.3) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration) { self.alpha = 1 }
    }

    func fadeOut(duration: TimeInterval = 0.3, then completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 0 }) { _ in
            self.isHidden = true
            completion?()
        }
    }

    // Springy "pop" — nice for buttons and confirmations.
    func popIn() {
        transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.55, initialSpringVelocity: 0.8,
                       options: [.curveEaseOut]) {
            self.transform = .identity
            self.alpha = 1
        }
    }

    // Shake — classic "wrong password" feedback.
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }

    // Continuous rotation (e.g. a loading indicator you built yourself).
    func startSpinning() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 1
        rotation.repeatCount = .infinity
        layer.add(rotation, forKey: "spin")
    }

    func stopSpinning() { layer.removeAnimation(forKey: "spin") }
}

// A scrubbable animator you can pause/reverse (e.g. tied to a pan gesture).
enum PropertyAnimatorExample {
    static func makeSlideIn(_ view: UIView, to point: CGPoint) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7) {
            view.center = point
        }
        // animator.startAnimation()
        // animator.pauseAnimation(); animator.fractionComplete = 0.5
        // animator.isReversed = true
        return animator
    }
}
