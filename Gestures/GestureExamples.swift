import UIKit

// Every common gesture recognizer wired up on a draggable, zoomable box.
final class GestureExamples: UIViewController, UIGestureRecognizerDelegate {

    private let box: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        v.frame = CGRect(x: 100, y: 200, width: 120, height: 120)
        v.layer.cornerRadius = 12
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Gestures"
        view.addSubview(box)
        addGestures()
    }

    private func addGestures() {
        // Double tap → change color.
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        box.addGestureRecognizer(doubleTap)

        // Long press → pop.
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.4
        box.addGestureRecognizer(longPress)

        // Pan → drag around.
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        box.addGestureRecognizer(pan)

        // Pinch → scale.
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinch.delegate = self
        box.addGestureRecognizer(pinch)

        // Rotate → rotate (simultaneously with pinch).
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        rotate.delegate = self
        box.addGestureRecognizer(rotate)

        // Swipe on the background → print direction.
        for direction: UISwipeGestureRecognizer.Direction in [.left, .right, .up, .down] {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipe.direction = direction
            view.addGestureRecognizer(swipe)
        }
    }

    // MARK: - Handlers

    @objc private func handleDoubleTap() {
        box.backgroundColor = [UIColor.systemBlue, .systemGreen, .systemPink, .systemOrange].randomElement()
    }

    @objc private func handleLongPress(_ g: UILongPressGestureRecognizer) {
        guard g.state == .began else { return }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.6) {
            self.box.transform = self.box.transform.scaledBy(x: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) { self.box.transform = .identity }
        }
    }

    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
        let t = g.translation(in: view)
        box.center = CGPoint(x: box.center.x + t.x, y: box.center.y + t.y)
        g.setTranslation(.zero, in: view)   // make each delta relative
    }

    @objc private func handlePinch(_ g: UIPinchGestureRecognizer) {
        box.transform = box.transform.scaledBy(x: g.scale, y: g.scale)
        g.scale = 1   // reset so scale is incremental
    }

    @objc private func handleRotate(_ g: UIRotationGestureRecognizer) {
        box.transform = box.transform.rotated(by: g.rotation)
        g.rotation = 0
    }

    @objc private func handleSwipe(_ g: UISwipeGestureRecognizer) {
        print("Swiped: \(g.direction)")
    }

    // Allow pinch + rotate together.
    func gestureRecognizer(_ g: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
        true
    }
}
