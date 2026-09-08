import SwiftUI

struct CaseRoomView: View {
    @EnvironmentObject var shop: ShopFloor
    @State private var section = 0
    @State private var face: TypeFace? = nil
    @State private var flower: Flower? = nil
    @State private var stock: Stock? = nil
    @State private var colour: Colour? = nil
    @State private var search = ""

    var body: some View {
        VStack(spacing: 0) {
            SegmentRow(titles: ["Faces", "Ornaments", "Papers", "Inks"], index: $section)
                .padding(.horizontal, Press.gutter)
                .padding(.top, 10)
                .padding(.bottom, 8)
            ScrollView {
                Column(spacing: 12) {
                    switch section {
                    case 1: ornamentList
                    case 2: paperList
                    case 3: inkList
                    default: faceList
                    }
                }
                .padding(.horizontal, Press.gutter)
                .padding(.bottom, 26)
            }
        }
        .background(Press.paper.ignoresSafeArea())
        .sheet(item: $face) { f in FacePanel(face: f) { face = nil }.environmentObject(shop) }
        .sheet(item: $flower) { o in FlowerPanel(flower: o) { flower = nil }.environmentObject(shop) }
        .sheet(item: $stock) { s in StockPanel(stock: s) { stock = nil } }
        .sheet(item: $colour) { c in ColourPanel(colour: c) { colour = nil } }
    }

    private var faceList: some View {
        Group {
            SheetCard {
                VStack(alignment: .leading, spacing: 8) {
                    RuleHead(text: "The founts in this shop", trailing: "\(Foundry.faces.count)")
                    Text("Twelve faces, each in three or four sizes, because the case only holds so much. Every letter of every one of them is drawn from outlines the app carries, so what you set is what prints.")
                        .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            ForEach(Foundry.faces, id: \.key) { f in
                Button(action: { Knock.light(); face = f }) {
                    SheetCard(padding: 0) {
                        VStack(spacing: 0) {
                            SpecimenLine(face: f, text: "Hamburgefonstiv 1874")
                                .frame(height: 74)
                                .padding(.horizontal, 12)
                                .padding(.top, 12)
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(f.name).font(Press.title(14)).foregroundColor(Press.ink)
                                    Text(f.cut).font(Press.note(11)).foregroundColor(Press.inkFaint)
                                        .lineLimit(1).minimumScaleFactor(0.7)
                                }
                                Spacer(minLength: 6)
                                Text(f.sizes.map { "\($0)" }.joined(separator: "  "))
                                    .font(Press.body(11)).foregroundColor(Press.inkSoft)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var ornamentList: some View {
        Group {
            SheetCard {
                VStack(alignment: .leading, spacing: 8) {
                    RuleHead(text: "Flowers, devices, marks and rules",
                             trailing: "\(Ornaments.all.count)")
                    Text("A printer's flower is cast on a type body like any other sort, so it sets in the line and locks up with the letters. Whole borders were built out of one repeated flower.")
                        .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            let columns = Press.isPad ? 4 : (Press.isNarrow ? 2 : 3)
            let rows = stride(from: 0, to: Ornaments.all.count, by: columns).map { Array(Ornaments.all[$0..<min($0 + columns, Ornaments.all.count)]) }
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 9) {
                    ForEach(row, id: \.key) { o in
                        Button(action: { Knock.light(); flower = o }) {
                            VStack(spacing: 5) {
                                PlateBox(name: "or_" + o.key, height: Press.isPad ? 150 : 106)
                                Text(o.name).font(Press.body(10.5)).foregroundColor(Press.inkSoft)
                                    .lineLimit(1).minimumScaleFactor(0.6)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    if row.count < columns {
                        ForEach(0..<(columns - row.count), id: \.self) { _ in
                            Color.clear.frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }

    private var paperList: some View {
        Group {
            SheetCard {
                VStack(alignment: .leading, spacing: 8) {
                    RuleHead(text: "The paper store", trailing: "\(Papers.all.count)")
                    Text("Every sheet takes ink and impression differently. A hard smooth stock holds a hairline and splits under a bite; a soft rag takes a bite and drinks the ink.")
                        .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            ForEach(Papers.all, id: \.key) { s in
                Button(action: { Knock.light(); stock = s }) {
                    SheetCard(padding: 0) {
                        HStack(spacing: 0) {
                            PlateBox(name: "pa_" + s.key, height: 92, corner: 0).frame(width: 92)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(s.name).font(Press.title(14)).foregroundColor(Press.ink)
                                HStack(spacing: 8) {
                                    tinyMeter("take", s.absorbency)
                                    tinyMeter("smooth", s.smoothness)
                                    tinyMeter("give", s.softness)
                                }
                            }
                            .padding(.horizontal, 11)
                            Spacer(minLength: 0)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func tinyMeter(_ label: String, _ value: Double) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(Press.body(9)).foregroundColor(Press.inkFaint)
            ZStack(alignment: .leading) {
                Capsule().fill(Press.ink.opacity(0.10)).frame(width: 42, height: 4)
                Capsule().fill(Press.brass).frame(width: max(2, 42 * CGFloat(value)), height: 4)
            }
        }
    }

    private var inkList: some View {
        Group {
            SheetCard {
                VStack(alignment: .leading, spacing: 8) {
                    RuleHead(text: "The ink cans", trailing: "\(Inks.all.count)")
                    Text("Two of these are transparent and made to print over another colour. The rest cover. Tack is how stiff the ink is and how hard it pulls at the sheet.")
                        .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            ForEach(Inks.all, id: \.key) { c in
                Button(action: { Knock.light(); colour = c }) {
                    SheetCard(padding: 0) {
                        HStack(spacing: 0) {
                            PlateBox(name: "in_" + c.key, height: 88, corner: 0).frame(width: 88)
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(c.name).font(Press.title(14)).foregroundColor(Press.ink)
                                        .lineLimit(1).minimumScaleFactor(0.7)
                                    if c.overprints {
                                        StampTag(text: "overprints", tone: Press.brass)
                                    }
                                }
                                HStack(spacing: 8) {
                                    tinyMeter("tack", c.tack)
                                    tinyMeter("opacity", c.opacity)
                                }
                            }
                            .padding(.horizontal, 11)
                            Spacer(minLength: 0)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

extension TypeFace: Identifiable { public var id: String { key } }
extension Flower: Identifiable { public var id: String { key } }
extension Stock: Identifiable { public var id: String { key } }
extension Colour: Identifiable { public var id: String { key } }

struct SpecimenLine: View {
    var face: TypeFace
    var text: String
    var tone: Color = Press.ink

    var body: some View {
        Canvas { ctx, area in
            let size = min(area.height * 0.78,
                           area.width / max(1, CGFloat(Composer.lineWidth(text, face, 1.0))))
            let baseline = area.height * 0.76
            var cursor: CGFloat = 0
            var glyphs = Path()
            var holes = Path()
            for ch in text {
                let key = String(ch)
                if key == " " { cursor += size / 3; continue }
                let (g, c, adv) = Metalwork.paths(key, face, size: size,
                                                  origin: CGPoint(x: cursor, y: baseline), mode: 0)
                glyphs.addPath(g)
                holes.addPath(c)
                cursor += adv
            }
            var moved = ctx
            moved.translateBy(x: max(0, (area.width - cursor) / 2), y: 0)
            moved.fill(glyphs, with: .color(tone))
            moved.fill(holes, with: .color(Press.card))
        }
    }
}

struct FacePanel: View {
    let face: TypeFace
    var onClose: () -> Void
    @EnvironmentObject var shop: ShopFloor

    var body: some View {
        ZStack {
            Press.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                PanelHead(title: face.name, subtitle: face.cut, onClose: onClose)
                ScrollView {
                    VStack(spacing: 13) {
                        PlateBox(name: "fa_" + face.key, height: Press.isPad ? 520 : 380, mode: .fit)
                        SheetCard {
                            VStack(alignment: .leading, spacing: 9) {
                                RuleHead(text: "Where it comes from")
                                Text(face.story).font(Press.body(13.5)).foregroundColor(Press.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        SheetCard {
                            VStack(alignment: .leading, spacing: 9) {
                                RuleHead(text: "On the stone")
                                Text(face.colourNote).font(Press.body(13.5))
                                    .foregroundColor(Press.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                                PairRow(key: "Cast in", value: face.sizes.map { "\($0) pt" }.joined(separator: ", "))
                                PairRow(key: "Serifs", value: serifWord)
                                PairRow(key: "Contrast", value: contrastWord)
                            }
                        }
                        PlateBox(name: "fd_" + face.key, height: Press.isPad ? 420 : 300, mode: .fit)
                        SheetCard {
                            VStack(alignment: .leading, spacing: 9) {
                                RuleHead(text: "Set in the stick")
                                Text("This is what the metal looks like in the stick: the face is cut in mirror image so it prints the right way round, and the compositor sees it upside down as well.")
                                    .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                                StickBed(lines: [demoLine], face: face, size: Double(face.sizes.first ?? 18),
                                         measurePicas: demoMeasure, activeLine: -1, showNicks: true)
                                    .frame(height: 62)
                                Text("and off the press")
                                    .font(Press.note(11)).foregroundColor(Press.inkFaint)
                                SpecimenLine(face: face, text: "THE STICK", tone: Press.ink)
                                    .frame(height: 60)
                            }
                        }
                    }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 26)
                }
            }
        }
        .onAppear { shop.markRead(2, face.key) }
    }

    private var demoLine: [SetSort] {
        Array("THE STICK").map { SetSort(key: $0 == " " ? "3em" : String($0)) }
    }

    private var demoMeasure: Double {
        max(8, Composer.lineWidth("THE STICK", face, Double(face.sizes.first ?? 18)) / 12 + 2)
    }

    private var serifWord: String {
        switch face.serif {
        case 1: return "Slab"
        case 2: return "Unbracketed hairline"
        case 3: return "Bracketed old style"
        case 4: return "Diamond"
        case 5: return "Bifurcated"
        default: return "None"
        }
    }

    private var contrastWord: String {
        if face.hair > 0.8 { return "Monoline" }
        if face.hair > 0.5 { return "Low" }
        if face.hair > 0.25 { return "Moderate" }
        return "Extreme"
    }
}

struct FlowerPanel: View {
    let flower: Flower
    var onClose: () -> Void
    @EnvironmentObject var shop: ShopFloor

    var body: some View {
        ZStack {
            Press.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                PanelHead(title: flower.name, subtitle: flower.family, onClose: onClose)
                ScrollView {
                    VStack(spacing: 13) {
                        PlateBox(name: "or_" + flower.key, height: Press.isPad ? 420 : 300, mode: .fit)
                        SheetCard {
                            Text(flower.note).font(Press.body(13.5)).foregroundColor(Press.inkSoft)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        SheetCard {
                            VStack(alignment: .leading, spacing: 9) {
                                RuleHead(text: "Set as a run")
                                HStack(spacing: 3) {
                                    ForEach(0..<6, id: \.self) { _ in
                                        OrnamentGlyph(key: flower.key, tone: Press.ink)
                                            .frame(height: 40)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 26)
                }
            }
        }
        .onAppear { shop.markRead(3, flower.key) }
    }
}

struct StockPanel: View {
    let stock: Stock
    var onClose: () -> Void

    var body: some View {
        ZStack {
            Press.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                PanelHead(title: stock.name, subtitle: "Paper", onClose: onClose)
                ScrollView {
                    VStack(spacing: 13) {
                        PlateBox(name: "pa_" + stock.key, height: Press.isPad ? 400 : 290, mode: .fit)
                        SheetCard {
                            Text(stock.note).font(Press.body(13.5)).foregroundColor(Press.inkSoft)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        SheetCard {
                            VStack(alignment: .leading, spacing: 10) {
                                RuleHead(text: "How it behaves")
                                MeterBar(label: "Takes ink", value: stock.absorbency, tone: Press.ink,
                                         caption: stock.absorbency > 0.7
                                         ? "Drinks it, so the counters close early."
                                         : "Holds the ink on the surface.")
                                MeterBar(label: "Smoothness", value: stock.smoothness, tone: Press.brass)
                                MeterBar(label: "Gives under the platen", value: stock.softness,
                                         tone: Press.oak)
                                PairRow(key: "Best impression", value: "\(Int(stock.bestDepth * 100)) of 100")
                                PairRow(key: "Window", value: "plus or minus \(Int(stock.depthWindow * 100))")
                            }
                        }
                    }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 26)
                }
            }
        }
    }
}

struct ColourPanel: View {
    let colour: Colour
    var onClose: () -> Void

    var body: some View {
        ZStack {
            Press.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                PanelHead(title: colour.name, subtitle: colour.overprints ? "Transparent, for overprinting" : "Opaque",
                          onClose: onClose)
                ScrollView {
                    VStack(spacing: 13) {
                        PlateBox(name: "in_" + colour.key, height: Press.isPad ? 400 : 290, mode: .fit)
                        SheetCard {
                            Text(colour.note).font(Press.body(13.5)).foregroundColor(Press.inkSoft)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        SheetCard {
                            VStack(alignment: .leading, spacing: 10) {
                                RuleHead(text: "In the can")
                                MeterBar(label: "Tack", value: colour.tack, tone: Press.ink,
                                         caption: colour.tack > 0.7
                                         ? "Stiff. It will pick the surface off a soft sheet."
                                         : "Loose enough to roll out quickly.")
                                MeterBar(label: "Opacity", value: colour.opacity,
                                         tone: Press.inkColour(colour.key))
                            }
                        }
                    }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 26)
                }
            }
        }
    }
}
