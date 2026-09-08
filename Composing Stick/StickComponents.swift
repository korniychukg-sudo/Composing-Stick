import SwiftUI

enum Plates {
    private static var cache: [String: UIImage] = [:]

    static func load(_ name: String) -> UIImage? {
        if let hit = cache[name] { return hit }
        guard let path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "Art"),
              let image = UIImage(contentsOfFile: path) else { return nil }
        if cache.count > 40 { cache.removeAll() }
        cache[name] = image
        return image
    }
}

struct PlateBox: View {
    let name: String
    var height: CGFloat
    var corner: CGFloat = 4
    var mode: ContentMode = .fill

    var body: some View {
        Color.clear
            .overlay(
                Group {
                    if let image = Plates.load(name) {
                        Image(uiImage: image).resizable().aspectRatio(contentMode: mode)
                    } else {
                        Press.paperDeep
                    }
                }
            )
            .frame(height: height)
            .clipped()
            .cornerRadius(corner)
            .overlay(
                RoundedRectangle(cornerRadius: corner)
                    .stroke(Press.ink.opacity(0.16), lineWidth: 0.8)
            )
    }
}

struct SheetCard<Content: View>: View {
    var padding: CGFloat = 15
    var tone: Color = Press.card
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(tone)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Press.ink.opacity(0.13), lineWidth: 0.9)
                    )
                    .shadow(color: Press.ink.opacity(0.07), radius: 5, x: 0, y: 3)
            )
    }
}

struct RuleHead: View {
    let text: String
    var trailing: String? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 9) {
            Text(text.uppercased())
                .font(Press.title(11.5))
                .tracking(1.5)
                .foregroundColor(Press.inkSoft)
                .fixedSize(horizontal: true, vertical: false)
            Rectangle()
                .fill(Press.ink.opacity(0.17))
                .frame(height: 0.8)
            if let trailing = trailing {
                Text(trailing)
                    .font(Press.body(11.5))
                    .foregroundColor(Press.inkFaint)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
}

struct LeverButton: View {
    let title: String
    var tone: Color = Press.ink
    var filled: Bool = true
    var enabled: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: { if enabled { Knock.light(); action() } }) {
            Text(title)
                .font(Press.title(15))
                .foregroundColor(filled ? Press.card : tone)
                .padding(.horizontal, 16)
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(filled ? tone : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(tone.opacity(filled ? 0 : 0.55), lineWidth: 1.1)
                        )
                )
                .opacity(enabled ? 1 : 0.42)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}

struct MeterBar: View {
    var label: String
    var value: Double
    var tone: Color = Press.brass
    var caption: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(Press.body(12.5))
                    .foregroundColor(Press.inkSoft)
                Spacer(minLength: 8)
                Text("\(Int(min(1, max(0, value)) * 100))")
                    .font(Press.title(12.5))
                    .foregroundColor(Press.ink)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Press.ink.opacity(0.10))
                    Capsule().fill(tone)
                        .frame(width: max(2, geo.size.width * CGFloat(min(1, max(0, value)))))
                }
            }
            .frame(height: 6)
            if let caption = caption {
                Text(caption)
                    .font(Press.note(10.5))
                    .foregroundColor(Press.inkFaint)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct NoticeBar: View {
    var text: String
    var tone: Color = Press.brass
    var action: (String, () -> Void)? = nil

    var body: some View {
        HStack(spacing: 10) {
            Rectangle().fill(tone).frame(width: 3)
            Text(text)
                .font(Press.body(12.5))
                .foregroundColor(Press.inkSoft)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 4)
            if let action = action {
                Button(action: { Knock.light(); action.1() }) {
                    Text(action.0)
                        .font(Press.title(11.5))
                        .foregroundColor(tone)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(tone.opacity(0.6), lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 6).fill(tone.opacity(0.09)))
    }
}

struct PanelHead: View {
    var title: String
    var subtitle: String? = nil
    var onClose: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(Press.title(19))
                    .foregroundColor(Press.ink)
                    .fixedSize(horizontal: false, vertical: true)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(Press.note(12.5))
                        .foregroundColor(Press.inkFaint)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 0)
            Button(action: { Knock.light(); onClose() }) {
                CrossMark(size: 16, color: Press.inkSoft)
                    .padding(9)
                    .background(Circle().fill(Press.ink.opacity(0.07)))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Press.gutter)
        .padding(.top, 16)
        .padding(.bottom, 9)
    }
}

struct FigureBox: View {
    var value: String
    var label: String
    var tone: Color = Press.ink

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(Press.title(17))
                .foregroundColor(tone)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label.uppercased())
                .font(Press.body(9))
                .tracking(1.0)
                .foregroundColor(Press.inkFaint)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 9)
        .background(RoundedRectangle(cornerRadius: 5).fill(Press.ink.opacity(0.045)))
    }
}

struct PairRow: View {
    var key: String
    var value: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(key)
                .font(Press.body(12.5))
                .foregroundColor(Press.inkFaint)
            Spacer(minLength: 8)
            Text(value)
                .font(Press.body(12.5))
                .foregroundColor(Press.ink)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct StampTag: View {
    var text: String
    var tone: Color
    var body: some View {
        Text(text.uppercased())
            .font(Press.title(9.5))
            .tracking(1.2)
            .foregroundColor(tone)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(tone.opacity(0.7), lineWidth: 1))
    }
}

struct Column<Content: View>: View {
    var spacing: CGFloat = 15
    @ViewBuilder var content: () -> Content
    var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            VStack(spacing: spacing) { content() }
                .frame(maxWidth: Press.isPad ? 720 : .infinity)
            Spacer(minLength: 0)
        }
    }
}

struct SegmentRow: View {
    var titles: [String]
    @Binding var index: Int
    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(titles.enumerated()), id: \.offset) { i, title in
                Button(action: { Knock.light(); withAnimation(.easeOut(duration: 0.2)) { index = i } }) {
                    Text(title)
                        .font(Press.title(11))
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .foregroundColor(index == i ? Press.card : Press.inkSoft)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(RoundedRectangle(cornerRadius: 4)
                                        .fill(index == i ? Press.ink : Press.ink.opacity(0.06)))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct DimBackdrop: View {
    var onTap: () -> Void
    var body: some View {
        Color.black.opacity(0.34)
            .ignoresSafeArea()
            .onTapGesture { Knock.light(); onTap() }
    }
}
