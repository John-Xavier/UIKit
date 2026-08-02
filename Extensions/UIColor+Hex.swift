import UIKit

extension UIColor {

    // UIColor(hex: "#FF6B35") or UIColor(hex: "FF6B35") — also supports 8-digit RGBA.
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }

        var rgba: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgba)

        let r, g, b, a: CGFloat
        if hexString.count == 8 { // RRGGBBAA
            r = CGFloat((rgba & 0xFF00_0000) >> 24) / 255
            g = CGFloat((rgba & 0x00FF_0000) >> 16) / 255
            b = CGFloat((rgba & 0x0000_FF00) >> 8) / 255
            a = CGFloat(rgba & 0x0000_00FF) / 255
        } else { // RRGGBB
            r = CGFloat((rgba & 0xFF0000) >> 16) / 255
            g = CGFloat((rgba & 0x00FF00) >> 8) / 255
            b = CGFloat(rgba & 0x0000FF) / 255
            a = alpha
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    // UIColor(rgb: 0xFF6B35)
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: alpha
        )
    }
}
