import SwiftUI

enum Press {
    static let paper = Color(red: 0.933, green: 0.918, blue: 0.886)
    static let paperDeep = Color(red: 0.878, green: 0.859, blue: 0.820)
    static let card = Color(red: 0.976, green: 0.969, blue: 0.953)
    static let ink = Color(red: 0.129, green: 0.118, blue: 0.110)
    static let inkSoft = Color(red: 0.306, green: 0.286, blue: 0.267)
    static let inkFaint = Color(red: 0.525, green: 0.502, blue: 0.475)
    static let oak = Color(red: 0.443, green: 0.325, blue: 0.204)
    static let oakDark = Color(red: 0.271, green: 0.192, blue: 0.114)
    static let brass = Color(red: 0.694, green: 0.545, blue: 0.243)
    static let brassDeep = Color(red: 0.463, green: 0.349, blue: 0.137)
    static let lead = Color(red: 0.451, green: 0.463, blue: 0.478)
    static let leadDark = Color(red: 0.259, green: 0.271, blue: 0.290)
    static let leadLight = Color(red: 0.690, green: 0.702, blue: 0.714)
    static let stone = Color(red: 0.502, green: 0.494, blue: 0.482)
    static let vermilion = Color(red: 0.694, green: 0.243, blue: 0.157)
    static let good = Color(red: 0.290, green: 0.435, blue: 0.318)
    static let alarm = Color(red: 0.663, green: 0.286, blue: 0.216)

    static func title(_ size: CGFloat) -> Font { .custom("Georgia-Bold", size: size) }
    static func body(_ size: CGFloat) -> Font { .custom("Georgia", size: size) }
    static func note(_ size: CGFloat) -> Font { .custom("Georgia-Italic", size: size) }

    static var screenWidth: CGFloat { UIScreen.main.bounds.width }
    static var isPad: Bool { screenWidth >= 700 }
    static var isNarrow: Bool { screenWidth <= 340 }
    static var gutter: CGFloat { isPad ? 32 : (isNarrow ? 12 : 17) }

    static func inkColour(_ key: String) -> Color {
        switch Inks.find(key).tone {
        case 1: return Color(red: 0.075, green: 0.071, blue: 0.071)
        case 2: return vermilion
        case 3: return Color(red: 0.580, green: 0.157, blue: 0.180)
        case 4: return Color(red: 0.149, green: 0.271, blue: 0.400)
        case 5: return Color(red: 0.176, green: 0.349, blue: 0.282)
        case 6: return Color(red: 0.722, green: 0.537, blue: 0.200)
        case 7: return Color(red: 0.404, green: 0.388, blue: 0.376)
        case 8: return Color(red: 0.945, green: 0.941, blue: 0.925)
        case 9: return Color(red: 0.439, green: 0.361, blue: 0.475)
        default: return Color(red: 0.106, green: 0.098, blue: 0.094)
        }
    }

    static func paperColour(_ key: String) -> Color {
        switch Papers.find(key).tone {
        case 1: return Color(red: 0.953, green: 0.945, blue: 0.929)
        case 2: return Color(red: 0.949, green: 0.937, blue: 0.910)
        case 3: return Color(red: 0.855, green: 0.831, blue: 0.757)
        case 4: return Color(red: 0.878, green: 0.867, blue: 0.839)
        case 5: return Color(red: 0.400, green: 0.435, blue: 0.463)
        case 6: return Color(red: 0.941, green: 0.925, blue: 0.882)
        case 7: return Color(red: 0.745, green: 0.647, blue: 0.502)
        case 8: return Color(red: 0.898, green: 0.898, blue: 0.867)
        default: return Color(red: 0.929, green: 0.910, blue: 0.867)
        }
    }
}

struct RiseIn: ViewModifier {
    let index: Int
    @State private var shown = false
    func body(content: Content) -> some View {
        content
            .opacity(shown ? 1 : 0)
            .offset(y: shown ? 0 : 14)
            .onAppear {
                withAnimation(.easeOut(duration: 0.38).delay(Double(index) * 0.05)) { shown = true }
            }
    }
}

extension View {
    func rising(_ index: Int) -> some View { modifier(RiseIn(index: index)) }
}

enum Knock {
    static func light() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func firm() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    static func hard() { UIImpactFeedbackGenerator(style: .heavy).impactOccurred() }
    static func metal() { UIImpactFeedbackGenerator(style: .rigid).impactOccurred() }
}
