import UIKit

// A dependency-free bar chart drawn with CoreGraphics. Works on any iOS version.
// Usage:
//   let chart = NativeBarChartView()
//   chart.data = [("Mon", 12), ("Tue", 30), ("Wed", 18), ("Thu", 25), ("Fri", 9)]
final class NativeBarChartView: UIView {

    // (label, value) pairs. Setting this redraws.
    var data: [(label: String, value: CGFloat)] = [] {
        didSet { setNeedsDisplay() }
    }

    var barColor: UIColor = .systemBlue
    var barSpacing: CGFloat = 12
    private let labelHeight: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw   // redraw on bounds changes (rotation, layout)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func draw(_ rect: CGRect) {
        guard !data.isEmpty, let ctx = UIGraphicsGetCurrentContext() else { return }

        let maxValue = data.map(\.value).max() ?? 1
        let chartHeight = rect.height - labelHeight
        let totalSpacing = barSpacing * CGFloat(data.count + 1)
        let barWidth = (rect.width - totalSpacing) / CGFloat(data.count)

        for (index, item) in data.enumerated() {
            let x = barSpacing + CGFloat(index) * (barWidth + barSpacing)
            let barHeight = maxValue > 0 ? (item.value / maxValue) * chartHeight : 0
            let y = chartHeight - barHeight

            // Bar (rounded top).
            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)
            let path = UIBezierPath(roundedRect: barRect,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 4, height: 4))
            ctx.setFillColor(barColor.cgColor)
            path.fill()

            // X-axis label, centered under the bar.
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.preferredFont(forTextStyle: .caption2),
                .foregroundColor: UIColor.secondaryLabel
            ]
            let text = item.label as NSString
            let size = text.size(withAttributes: attributes)
            let labelX = x + (barWidth - size.width) / 2
            text.draw(at: CGPoint(x: labelX, y: chartHeight + 2), withAttributes: attributes)
        }
    }
}
