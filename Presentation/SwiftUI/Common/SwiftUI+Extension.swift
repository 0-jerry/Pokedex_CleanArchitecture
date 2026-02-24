import SwiftUI

public extension Color {
    static func hex(_ hex: HEX) -> Color {
        Color(red: hex.red, green: hex.green, blue: hex.blue, opacity: hex.alpha)
    }
}
