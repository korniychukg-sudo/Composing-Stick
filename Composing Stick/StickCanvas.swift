import SwiftUI

enum Metalwork {
    static let midEm = EmBox.asc + EmBox.dsc

    static func paths(_ key: String, _ face: TypeFace, size: CGFloat,
                      origin: CGPoint, mode: Int) -> (Path, Path, CGFloat) {
        var ink = Path()
        var counters = Path()
        if JobCase.spaceKeys.contains(key) || key == "lead" || key == "slug" {
            return (ink, counters, CGFloat(JobCase.spaceWidth(key, Double(size))))
        }
        let letters = JobCase.isLigature(key) ? Array(key).map { String($0) } : [key]
        var cursor = 0.0
        for letter in letters {
            guard let metal = Forge.metal(letter, face) else { continue }
            let k = Double(size) / EmBox.unit
            let adv = metal.adv
            func place(_ p: CGPoint) -> CGPoint {
                var x = Double(p.x)
                var y = Double(p.y)
                switch mode {
                case 1: x = adv - x; y = midEm - y
                case 2: y = midEm - y
                case 3: x = adv - x
                default: break
                }
                return CGPoint(x: origin.x + CGFloat((cursor + x) * k),
                               y: origin.y - CGFloat(y * k))
            }
            for ring in metal.ink where ring.count > 2 {
                ink.move(to: place(ring[0]))
                for q in ring.dropFirst() { ink.addLine(to: place(q)) }
                ink.closeSubpath()
            }
            for ring in metal.counters where ring.count > 2 {
                counters.move(to: place(ring[0]))
                for q in ring.dropFirst() { counters.addLine(to: place(q)) }
                counters.closeSubpath()
            }
            cursor += adv * (letters.count > 1 ? 0.86 : 1.0)
        }
        return (ink, counters, CGFloat(cursor * Double(size) / EmBox.unit))
    }

    static func width(_ key: String, _ face: TypeFace, size: CGFloat) -> CGFloat {
        CGFloat(Measure.sortWidth(key, face, Double(size)))
    }
}

struct SortFace: View {
    let key: String
    let face: TypeFace
    var mode: Int
    var ink: Color = Press.leadDark
    var paper: Color = Press.leadLight

    var body: some View {
        Canvas { ctx, area in
            let h = area.height
            let size = h * 0.74
            let baseline = h * 0.78
            let (glyph, counters, adv) = Metalwork.paths(key, face, size: size,
                                                         origin: CGPoint(x: 0, y: baseline),
                                                         mode: mode)
            let dx = (area.width - adv) / 2
            ctx.translateBy(x: dx, y: 0)
            ctx.fill(glyph, with: .color(ink))
            ctx.fill(counters, with: .color(paper))
        }
    }
}

struct CaseTray: View {
    var face: TypeFace
    var hint: Int
    var highlight: String?
    var dimmed: Set<String>
    var onPick: (String, CGPoint) -> Void

    var body: some View {
        GeometryReader { geo in
            let wide = CGFloat(Frame.unitsWide)
            let tall = CGFloat(Frame.unitsTall)
            let scale: CGFloat = min(geo.size.width / wide, geo.size.height / tall)
            let ox: CGFloat = (geo.size.width - wide * scale) / 2
            let oy: CGFloat = (geo.size.height - tall * scale) / 2
            ZStack(alignment: .topLeading) {
                Canvas { ctx, _ in
                    ctx.fill(Path(CGRect(x: ox - 5, y: oy - 5,
                                         width: wide * scale + 10,
                                         height: tall * scale + 10)),
                             with: .color(Press.oak))
                    for box in JobCase.boxes {
                        let r = CGRect(x: ox + CGFloat(box.x) * scale + 1,
                                       y: oy + CGFloat(box.y) * scale + 1,
                                       width: CGFloat(box.w) * scale - 2,
                                       height: CGFloat(box.h) * scale - 2)
                        var tone = Press.paper
                        switch box.kind {
                        case 1: tone = Press.paperDeep
                        case 2: tone = Press.paperDeep.opacity(0.86)
                        case 3: tone = Press.leadLight.opacity(0.42)
                        case 4: tone = Press.brass.opacity(0.20)
                        case 5: tone = Press.lead.opacity(0.40)
                        default: tone = Press.paper
                        }
                        if dimmed.contains(box.key) { tone = Press.stone.opacity(0.30) }
                        if box.key == highlight { tone = Press.brass.opacity(0.55) }
                        ctx.fill(Path(roundedRect: r, cornerRadius: 1.5), with: .color(tone))
                        ctx.stroke(Path(roundedRect: r, cornerRadius: 1.5),
                                   with: .color(Press.oakDark.opacity(0.85)), lineWidth: 1)
                        if dimmed.contains(box.key) { continue }
                        drawContents(ctx, box: box, rect: r)
                    }
                }
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let ux = (value.startLocation.x - ox) / scale
                                let uy = (value.startLocation.y - oy) / scale
                                if let box = JobCase.boxes.first(where: {
                                    ux >= $0.x && ux <= $0.x + $0.w && uy >= $0.y && uy <= $0.y + $0.h
                                }) {
                                    onPick(box.key, value.location)
                                }
                            }
                    )
            }
        }
    }

    private func drawContents(_ ctx: GraphicsContext, box: CaseBox, rect: CGRect) {
        if box.kind == 3 || box.kind == 5 {
            let count = box.kind == 5 ? 3 : 4
            for k in 0..<count {
                let w = rect.width * (box.kind == 5 ? 0.74 : 0.16)
                let x = rect.minX + rect.width * 0.13 + CGFloat(k) * rect.width * 0.19
                let bar = CGRect(x: box.kind == 5 ? rect.minX + rect.width * 0.13 : x,
                                 y: rect.minY + rect.height * (box.kind == 5 ? 0.22 + CGFloat(k) * 0.22 : 0.24),
                                 width: box.kind == 5 ? w : rect.width * 0.11,
                                 height: box.kind == 5 ? rect.height * 0.13 : rect.height * 0.52)
                ctx.fill(Path(bar), with: .color(Press.lead.opacity(0.8)))
            }
        } else {
            let size = min(rect.height * 0.66, rect.width * 0.80)
            let (glyph, counters, adv) = Metalwork.paths(box.key, face, size: size,
                                                          origin: CGPoint(x: rect.midX,
                                                                          y: rect.midY + size * 0.30),
                                                          mode: 2)
            var moved = ctx
            moved.translateBy(x: -adv / 2, y: 0)
            moved.fill(glyph, with: .color(Press.leadDark))
            moved.fill(counters, with: .color(Press.leadLight.opacity(0.9)))
        }
        if hint >= 2 {
            let label = Text(verbatim: box.label)
                .font(Press.body(min(9, rect.height * 0.24)))
                .foregroundColor(Press.inkFaint)
            ctx.draw(label, at: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.13))
        }
    }
}

struct StickBed: View {
    var lines: [[SetSort]]
    var face: TypeFace
    var size: Double
    var measurePicas: Double
    var activeLine: Int
    var showNicks: Bool

    var body: some View {
        GeometryReader { geo in
            let measurePoints = Measure.picasToPoints(measurePicas)
            let usable = geo.size.width - 34
            let scale = usable / CGFloat(measurePoints)
            let rowH = min(geo.size.height / CGFloat(max(1, lines.count)) - 5,
                           CGFloat(size) * scale * 1.75)
            Canvas { ctx, area in
                ctx.fill(Path(CGRect(origin: .zero, size: area)), with: .color(Press.brass))
                ctx.fill(Path(CGRect(x: 0, y: 0, width: 15, height: area.height)),
                         with: .color(Press.brassDeep))
                ctx.fill(Path(CGRect(x: area.width - 13, y: 0, width: 13, height: area.height)),
                         with: .color(Press.brassDeep))
                var ticks = Path()
                let picas = Int(measurePicas)
                for k in 0...max(1, picas) {
                    let x = 15 + CGFloat(k) * CGFloat(Measure.pointsPerPica) * scale
                    ticks.move(to: CGPoint(x: x, y: area.height))
                    ticks.addLine(to: CGPoint(x: x, y: area.height - (k % 6 == 0 ? 13 : 7)))
                }
                ctx.stroke(ticks, with: .color(Press.brassDeep.opacity(0.9)), lineWidth: 1.4)

                for (i, line) in lines.enumerated() {
                    let top = CGFloat(i) * (rowH + 4) + 4
                    if i == activeLine {
                        ctx.fill(Path(CGRect(x: 15, y: top, width: usable, height: rowH)),
                                 with: .color(Press.brass.opacity(0.35)))
                    }
                    var cursor: CGFloat = 15
                    for sort in line {
                        let w = Metalwork.width(sort.key, face, size: CGFloat(size)) * scale
                        let body = CGRect(x: cursor, y: top, width: max(1.2, w), height: rowH)
                        if JobCase.spaceKeys.contains(sort.key) {
                            ctx.fill(Path(body.insetBy(dx: 0.4, dy: rowH * 0.22)),
                                     with: .color(Press.leadLight.opacity(0.72)))
                        } else {
                            ctx.fill(Path(body.insetBy(dx: 0.3, dy: 0)),
                                     with: .color(sort.turned ? Press.lead.opacity(0.9) : Press.lead))
                            let glyphSize = rowH * 0.60
                            let (glyph, counters, adv) = Metalwork.paths(
                                sort.key, face, size: glyphSize,
                                origin: CGPoint(x: body.midX, y: top + rowH * 0.72),
                                mode: sort.turned ? 3 : 2)
                            var moved = ctx
                            moved.translateBy(x: -adv / 2, y: 0)
                            moved.fill(glyph, with: .color(Press.leadDark))
                            moved.fill(counters, with: .color(Press.leadLight))
                            if showNicks {
                                let nickY = sort.turned ? top + rowH * 0.90 : top + rowH * 0.10
                                ctx.fill(Path(CGRect(x: body.minX + 0.8, y: nickY,
                                                     width: max(0.8, body.width - 1.6),
                                                     height: max(1.5, rowH * 0.055))),
                                         with: .color(sort.turned ? Press.alarm : Press.leadDark.opacity(0.95)))
                            }
                        }
                        cursor += w
                    }
                    var edge = Path()
                    edge.move(to: CGPoint(x: cursor, y: top))
                    edge.addLine(to: CGPoint(x: cursor, y: top + rowH))
                    ctx.stroke(edge, with: .color(Press.vermilion.opacity(0.8)), lineWidth: 1.4)
                }
                var limit = Path()
                limit.move(to: CGPoint(x: 15 + usable, y: 0))
                limit.addLine(to: CGPoint(x: 15 + usable, y: area.height))
                ctx.stroke(limit, with: .color(Press.oakDark),
                           style: StrokeStyle(lineWidth: 2.2, dash: [4, 3]))
            }
        }
    }
}

struct PrintedSheet: View {
    var forme: Forme
    var face: TypeFace
    var size: Double
    var measurePicas: Double
    var paperKey: String
    var inkKey: String
    var secondInk: String?
    var pull: Pull
    var ornamentKey: String?

    var body: some View {
        GeometryReader { geo in
            let paper = Papers.find(paperKey)
            let paperTone = Press.paperColour(paperKey)
            let inkTone = Press.inkColour(inkKey)
            let secondTone = secondInk.map { Press.inkColour($0) }
            let measurePoints = Measure.picasToPoints(measurePicas)
            let margin = geo.size.width * 0.10
            let usable = geo.size.width - margin * 2
            let scale = usable / CGFloat(measurePoints)
            let lineHeight = CGFloat(size) * scale * 1.52
            let inkOff = pull.inking - (0.44 + paper.absorbency * 0.24)
            let coverage = max(0.15, min(1.0, 0.82 + inkOff * 1.6))
            let fillCounters = inkOff > 0.16
            let depth = pull.depth - paper.bestDepth
            let emboss = CGFloat(max(0, min(1.6, (pull.depth - 0.2) * 2.2)))
            let loose = max(0.0, min(1.0, (0.5 - pull.quoin) * 2.4))

            Canvas { ctx, area in
                ctx.fill(Path(CGRect(origin: .zero, size: area)), with: .color(paperTone))
                if paper.key == "laid" {
                    var lines = Path()
                    var y: CGFloat = 0
                    while y < area.height {
                        lines.move(to: CGPoint(x: 0, y: y))
                        lines.addLine(to: CGPoint(x: area.width, y: y))
                        y += 3.4
                    }
                    ctx.stroke(lines, with: .color(Press.ink.opacity(0.045)), lineWidth: 0.6)
                }
                if paper.smoothness < 0.5 {
                    var speck = Path()
                    var seed: UInt64 = 99
                    for _ in 0..<220 {
                        seed = seed &* 6364136223846793005 &+ 1442695040888963407
                        let x = CGFloat(seed >> 33 % 10000) / 10000 * area.width
                        seed = seed &* 6364136223846793005 &+ 1442695040888963407
                        let y = CGFloat(seed >> 33 % 10000) / 10000 * area.height
                        speck.addEllipse(in: CGRect(x: x, y: y, width: 1.6, height: 1.1))
                    }
                    ctx.fill(speck, with: .color(Press.ink.opacity(0.05)))
                }

                let blockHeight = lineHeight * CGFloat(max(1, forme.lines.count))
                var top = (area.height - blockHeight) / 2 + lineHeight * 0.20
                if ornamentKey != nil { top = max(top, area.height * 0.26) }

                for (i, line) in forme.lines.enumerated() {
                    let baseline = top + CGFloat(i) * lineHeight + lineHeight * 0.72
                    var cursor = margin
                    let drift = loose * CGFloat((i % 2 == 0 ? 1 : -1)) * 3.2
                    let tone = (i == 1 && secondTone != nil) ? secondTone! : inkTone
                    for sort in line {
                        let w = Metalwork.width(sort.key, face, size: CGFloat(size)) * scale
                        if !JobCase.spaceKeys.contains(sort.key) && sort.key != "lead" && sort.key != "slug" {
                            let wobble = drift * CGFloat((Int(cursor) % 3) - 1) * 0.4
                            let origin = CGPoint(x: cursor + CGFloat(pull.registerOffset) * (tone == secondTone ? scale : 0),
                                                 y: baseline + wobble)
                            let (glyph, counters, _) = Metalwork.paths(
                                sort.key, face, size: CGFloat(size) * scale,
                                origin: origin, mode: sort.turned ? 1 : 0)
                            if emboss > 0.25 {
                                var shadow = glyph
                                shadow = shadow.offsetBy(dx: emboss * 0.7, dy: emboss * 0.7)
                                ctx.fill(shadow, with: .color(Press.ink.opacity(0.10 * Double(emboss))))
                            }
                            ctx.fill(glyph, with: .color(tone.opacity(coverage)))
                            if !fillCounters {
                                ctx.fill(counters, with: .color(paperTone))
                            } else {
                                ctx.fill(counters, with: .color(tone.opacity(max(0, (inkOff - 0.16) * 3.4))))
                            }
                            if coverage < 0.7 {
                                var broken = Path()
                                var seed = UInt64(bitPattern: Int64(Int(cursor * 7) + i * 31 + 5))
                                for _ in 0..<10 {
                                    seed = seed &* 6364136223846793005 &+ 1442695040888963407
                                    let fx = cursor + CGFloat(seed >> 33 % 1000) / 1000 * max(2, w)
                                    seed = seed &* 6364136223846793005 &+ 1442695040888963407
                                    let fy = baseline - CGFloat(seed >> 33 % 1000) / 1000 * CGFloat(size) * scale * 0.7
                                    broken.addEllipse(in: CGRect(x: fx, y: fy,
                                                                 width: CGFloat(size) * scale * 0.10,
                                                                 height: CGFloat(size) * scale * 0.08))
                                }
                                ctx.fill(broken, with: .color(paperTone.opacity(0.9 - coverage)))
                            }
                        }
                        cursor += w
                    }
                }

                if depth > paper.depthWindow {
                    var tear = Path()
                    let y = top + lineHeight * 0.5
                    tear.addEllipse(in: CGRect(x: margin + usable * 0.3, y: y,
                                               width: usable * 0.16, height: lineHeight * 0.4))
                    ctx.fill(tear, with: .color(Press.stone.opacity(0.5)))
                }
                var frame = Path()
                frame.addRect(CGRect(x: margin * 0.5, y: margin * 0.5,
                                     width: area.width - margin, height: area.height - margin))
                ctx.stroke(frame, with: .color(inkTone.opacity(0.28)), lineWidth: 1)
            }
            .overlay(
                Group {
                    if let key = ornamentKey {
                        OrnamentGlyph(key: key, tone: secondTone ?? inkTone)
                            .frame(width: geo.size.width * 0.20, height: geo.size.width * 0.20)
                            .position(x: geo.size.width / 2, y: geo.size.height * 0.14)
                    }
                }
            )
        }
    }
}

struct OrnamentGlyph: View {
    var key: String
    var tone: Color

    var body: some View {
        Canvas { ctx, area in
            let w = area.width, h = area.height
            let cx = w / 2, cy = h / 2
            let r = min(w, h) * 0.42
            let kind = Ornaments.find(key).kind
            var path = Path()
            switch kind {
            case 3:
                for k in 0..<3 {
                    let y = cy + CGFloat(k - 1) * r * 0.5
                    path.addRect(CGRect(x: cx - r, y: y - r * 0.06 - CGFloat(k) * 0.6,
                                        width: r * 2, height: r * (0.06 + CGFloat(k) * 0.05)))
                }
            case 2:
                path.addRect(CGRect(x: cx - r * 0.10, y: cy - r, width: r * 0.20, height: r * 2))
                path.addRect(CGRect(x: cx - r * 0.62, y: cy - r * 0.44, width: r * 1.24, height: r * 0.18))
            case 1:
                for k in 0..<12 {
                    let a = Double(k) / 12 * 2 * .pi
                    path.move(to: CGPoint(x: cx + CGFloat(cos(a)) * r * 0.28,
                                          y: cy + CGFloat(sin(a)) * r * 0.28))
                    path.addLine(to: CGPoint(x: cx + CGFloat(cos(a)) * r,
                                             y: cy + CGFloat(sin(a)) * r))
                }
                path.addEllipse(in: CGRect(x: cx - r * 0.26, y: cy - r * 0.26,
                                           width: r * 0.52, height: r * 0.52))
            default:
                for k in 0..<6 {
                    let a = Double(k) / 6 * 2 * .pi
                    var leaf = Path()
                    leaf.move(to: CGPoint(x: cx, y: cy))
                    leaf.addQuadCurve(to: CGPoint(x: cx + CGFloat(cos(a)) * r,
                                                  y: cy + CGFloat(sin(a)) * r),
                                      control: CGPoint(x: cx + CGFloat(cos(a + 0.6)) * r * 0.7,
                                                       y: cy + CGFloat(sin(a + 0.6)) * r * 0.7))
                    leaf.addQuadCurve(to: CGPoint(x: cx, y: cy),
                                      control: CGPoint(x: cx + CGFloat(cos(a - 0.6)) * r * 0.7,
                                                       y: cy + CGFloat(sin(a - 0.6)) * r * 0.7))
                    path.addPath(leaf)
                }
                path.addEllipse(in: CGRect(x: cx - r * 0.16, y: cy - r * 0.16,
                                           width: r * 0.32, height: r * 0.32))
            }
            if kind == 1 {
                ctx.stroke(path, with: .color(tone), lineWidth: max(1.2, r * 0.10))
            } else {
                ctx.fill(path, with: .color(tone))
            }
        }
    }
}

struct HourPalette {
    var sky: Color
    var wall: Color
    var floor: Color
    var beam: Double
    var lamp: Double
    var metal: Color

    static let stops: [HourPalette] = [
        HourPalette(sky: Color(red: 0.098, green: 0.114, blue: 0.176),
                    wall: Color(red: 0.161, green: 0.153, blue: 0.153),
                    floor: Color(red: 0.129, green: 0.114, blue: 0.106),
                    beam: 0.04, lamp: 0.10, metal: Color(red: 0.267, green: 0.278, blue: 0.298)),
        HourPalette(sky: Color(red: 0.694, green: 0.529, blue: 0.443),
                    wall: Color(red: 0.400, green: 0.365, blue: 0.341),
                    floor: Color(red: 0.243, green: 0.208, blue: 0.180),
                    beam: 0.34, lamp: 0.30, metal: Color(red: 0.396, green: 0.380, blue: 0.376)),
        HourPalette(sky: Color(red: 0.792, green: 0.827, blue: 0.847),
                    wall: Color(red: 0.647, green: 0.612, blue: 0.561),
                    floor: Color(red: 0.373, green: 0.310, blue: 0.251),
                    beam: 0.84, lamp: 0.0, metal: Color(red: 0.596, green: 0.608, blue: 0.620)),
        HourPalette(sky: Color(red: 0.859, green: 0.882, blue: 0.890),
                    wall: Color(red: 0.706, green: 0.678, blue: 0.627),
                    floor: Color(red: 0.416, green: 0.349, blue: 0.286),
                    beam: 1.0, lamp: 0.0, metal: Color(red: 0.667, green: 0.678, blue: 0.690)),
        HourPalette(sky: Color(red: 0.847, green: 0.812, blue: 0.741),
                    wall: Color(red: 0.667, green: 0.612, blue: 0.529),
                    floor: Color(red: 0.396, green: 0.322, blue: 0.251),
                    beam: 0.70, lamp: 0.0, metal: Color(red: 0.612, green: 0.600, blue: 0.573)),
        HourPalette(sky: Color(red: 0.616, green: 0.416, blue: 0.353),
                    wall: Color(red: 0.404, green: 0.345, blue: 0.310),
                    floor: Color(red: 0.259, green: 0.216, blue: 0.184),
                    beam: 0.26, lamp: 0.58, metal: Color(red: 0.435, green: 0.412, blue: 0.396)),
        HourPalette(sky: Color(red: 0.176, green: 0.192, blue: 0.259),
                    wall: Color(red: 0.212, green: 0.196, blue: 0.192),
                    floor: Color(red: 0.149, green: 0.129, blue: 0.118),
                    beam: 0.05, lamp: 0.88, metal: Color(red: 0.298, green: 0.302, blue: 0.318))
    ]

    static func mix(_ a: Color, _ b: Color, _ t: Double) -> Color {
        let ua = UIColor(a), ub = UIColor(b)
        var ar: CGFloat = 0, ag: CGFloat = 0, ab: CGFloat = 0, aa: CGFloat = 0
        var br: CGFloat = 0, bg: CGFloat = 0, bb: CGFloat = 0, ba: CGFloat = 0
        ua.getRed(&ar, green: &ag, blue: &ab, alpha: &aa)
        ub.getRed(&br, green: &bg, blue: &bb, alpha: &ba)
        let k = CGFloat(max(0, min(1, t)))
        return Color(red: Double(ar + (br - ar) * k),
                     green: Double(ag + (bg - ag) * k),
                     blue: Double(ab + (bb - ab) * k))
    }

    static func at(_ hour: Double) -> HourPalette {
        let span = 24.0 / Double(stops.count - 1)
        let raw = max(0, min(23.999, hour)) / span
        let i = min(stops.count - 2, Int(raw))
        let t = raw - Double(i)
        let a = stops[i], b = stops[i + 1]
        return HourPalette(sky: mix(a.sky, b.sky, t),
                           wall: mix(a.wall, b.wall, t),
                           floor: mix(a.floor, b.floor, t),
                           beam: a.beam + (b.beam - a.beam) * t,
                           lamp: a.lamp + (b.lamp - a.lamp) * t,
                           metal: mix(a.metal, b.metal, t))
    }
}

struct ShopScene: View {
    var hour: Double

    var body: some View {
        Canvas { ctx, area in
            let w = area.width, h = area.height
            let p = HourPalette.at(hour)
            ctx.fill(Path(CGRect(x: 0, y: 0, width: w, height: h * 0.66)), with: .color(p.wall))
            ctx.fill(Path(CGRect(x: 0, y: h * 0.63, width: w, height: h * 0.37)), with: .color(p.floor))

            let win = CGRect(x: w * 0.58, y: h * 0.08, width: w * 0.34, height: h * 0.42)
            ctx.fill(Path(win), with: .color(p.sky))
            var bars = Path()
            for k in 1..<3 {
                let x = win.minX + win.width * CGFloat(k) / 3
                bars.move(to: CGPoint(x: x, y: win.minY))
                bars.addLine(to: CGPoint(x: x, y: win.maxY))
            }
            bars.move(to: CGPoint(x: win.minX, y: win.midY))
            bars.addLine(to: CGPoint(x: win.maxX, y: win.midY))
            ctx.stroke(bars, with: .color(p.wall.opacity(0.9)), lineWidth: max(1.5, w * 0.008))
            ctx.stroke(Path(win.insetBy(dx: -w * 0.012, dy: -h * 0.016)),
                       with: .color(Press.oakDark.opacity(0.8)), lineWidth: max(2, w * 0.01))

            if p.beam > 0.10 {
                var beam = Path()
                beam.move(to: CGPoint(x: win.minX, y: win.maxY))
                beam.addLine(to: CGPoint(x: win.maxX, y: win.maxY))
                beam.addLine(to: CGPoint(x: win.maxX - w * 0.30, y: h))
                beam.addLine(to: CGPoint(x: win.minX - w * 0.52, y: h))
                beam.closeSubpath()
                ctx.fill(beam, with: .color(Color(red: 1, green: 0.949, blue: 0.808)
                                                .opacity(0.06 + p.beam * 0.20)))
                var motes = Path()
                var seed: UInt64 = 4242
                for _ in 0..<Int(p.beam * 90) {
                    seed = seed &* 6364136223846793005 &+ 1442695040888963407
                    let t = CGFloat(seed >> 33 % 1000) / 1000
                    seed = seed &* 6364136223846793005 &+ 1442695040888963407
                    let u = CGFloat(seed >> 33 % 1000) / 1000
                    let x = win.minX - w * 0.52 * t + u * win.width
                    let y = win.maxY + t * (h - win.maxY)
                    motes.addEllipse(in: CGRect(x: x, y: y, width: 1.6, height: 1.6))
                }
                ctx.fill(motes, with: .color(Color(red: 1, green: 0.976, blue: 0.886)
                                                 .opacity(0.10 + p.beam * 0.24)))
            }

            var frame = Path()
            frame.move(to: CGPoint(x: w * 0.03, y: h * 0.52))
            frame.addLine(to: CGPoint(x: w * 0.50, y: h * 0.44))
            frame.addLine(to: CGPoint(x: w * 0.55, y: h * 0.62))
            frame.addLine(to: CGPoint(x: w * 0.01, y: h * 0.72))
            frame.closeSubpath()
            ctx.fill(frame, with: .color(Press.oak))
            for row in 0..<4 {
                for col in 0..<9 {
                    let u = CGFloat(col) / 9, v = CGFloat(row) / 4
                    let bx = w * 0.05 + u * w * 0.44 - v * w * 0.02
                    let by = h * 0.46 + v * h * 0.16 - u * h * 0.075
                    let bw = w * 0.044, bh = h * 0.034
                    ctx.fill(Path(CGRect(x: bx, y: by, width: bw, height: bh)),
                             with: .color(p.metal.opacity(0.55)))
                }
            }
            ctx.stroke(frame, with: .color(Press.oakDark), lineWidth: max(1.4, w * 0.006))

            var stone = Path()
            stone.move(to: CGPoint(x: w * 0.05, y: h * 0.80))
            stone.addLine(to: CGPoint(x: w * 0.56, y: h * 0.74))
            stone.addLine(to: CGPoint(x: w * 0.60, y: h * 0.92))
            stone.addLine(to: CGPoint(x: w * 0.02, y: h * 0.99))
            stone.closeSubpath()
            ctx.fill(stone, with: .color(Press.stone.opacity(0.55 + p.beam * 0.35)))
            var chase = Path()
            chase.addRect(CGRect(x: w * 0.16, y: h * 0.79, width: w * 0.28, height: h * 0.10))
            ctx.fill(chase, with: .color(Color(red: 0.176, green: 0.176, blue: 0.188)))
            ctx.fill(Path(CGRect(x: w * 0.185, y: h * 0.805, width: w * 0.23, height: h * 0.07)),
                     with: .color(p.metal))

            var press = Path()
            press.move(to: CGPoint(x: w * 0.70, y: h))
            press.addLine(to: CGPoint(x: w * 0.96, y: h * 0.98))
            press.addLine(to: CGPoint(x: w * 0.93, y: h * 0.48))
            press.addLine(to: CGPoint(x: w * 0.74, y: h * 0.50))
            press.closeSubpath()
            ctx.fill(press, with: .color(Color(red: 0.145, green: 0.145, blue: 0.157)
                                             .opacity(0.92)))
            var lever = Path()
            lever.move(to: CGPoint(x: w * 0.92, y: h * 0.66))
            lever.addQuadCurve(to: CGPoint(x: w * 0.99, y: h * 0.40),
                               control: CGPoint(x: w * 1.02, y: h * 0.56))
            ctx.stroke(lever, with: .color(Color(red: 0.176, green: 0.176, blue: 0.188)),
                       style: StrokeStyle(lineWidth: max(2.5, w * 0.014), lineCap: .round))

            if p.lamp > 0.06 {
                let lx = w * 0.34, ly = h * 0.20
                var stem = Path()
                stem.move(to: CGPoint(x: lx, y: 0))
                stem.addLine(to: CGPoint(x: lx, y: ly - h * 0.03))
                ctx.stroke(stem, with: .color(Color(red: 0.145, green: 0.145, blue: 0.157)),
                           lineWidth: max(1.4, w * 0.006))
                var shade = Path()
                shade.move(to: CGPoint(x: lx - w * 0.045, y: ly - h * 0.03))
                shade.addLine(to: CGPoint(x: lx + w * 0.045, y: ly - h * 0.03))
                shade.addLine(to: CGPoint(x: lx + w * 0.028, y: ly + h * 0.012))
                shade.addLine(to: CGPoint(x: lx - w * 0.028, y: ly + h * 0.012))
                shade.closeSubpath()
                ctx.fill(shade, with: .color(Color(red: 0.145, green: 0.145, blue: 0.157)))
                var glow = Path()
                glow.addEllipse(in: CGRect(x: lx - w * 0.22, y: ly - h * 0.10,
                                           width: w * 0.44, height: h * 0.56))
                ctx.fill(glow, with: .color(Color(red: 0.976, green: 0.855, blue: 0.573)
                                                .opacity(0.13 * p.lamp)))
                ctx.fill(Path(ellipseIn: CGRect(x: lx - w * 0.018, y: ly + h * 0.004,
                                                width: w * 0.036, height: w * 0.036)),
                         with: .color(Color(red: 1.0, green: 0.918, blue: 0.706).opacity(0.95)))
            }

            var stick = Path()
            stick.move(to: CGPoint(x: -w * 0.02, y: h * 0.955))
            stick.addLine(to: CGPoint(x: w * 0.40, y: h * 0.905))
            stick.addLine(to: CGPoint(x: w * 0.41, y: h * 1.02))
            stick.addLine(to: CGPoint(x: -w * 0.02, y: h * 1.02))
            stick.closeSubpath()
            ctx.fill(stick, with: .color(Press.brass.opacity(0.85 + p.beam * 0.15)))
            for k in 0..<11 {
                let x = w * 0.01 + CGFloat(k) * w * 0.035
                ctx.fill(Path(CGRect(x: x, y: h * 0.915 - CGFloat(k) * h * 0.004,
                                     width: w * 0.024, height: h * 0.055)),
                         with: .color(p.metal))
            }
            ctx.stroke(stick, with: .color(Press.brassDeep), lineWidth: max(1.6, w * 0.007))

            let dark = 1.0 - p.beam * 0.68 - p.lamp * 0.24
            if dark > 0.14 {
                ctx.fill(Path(CGRect(origin: .zero, size: area)),
                         with: .color(Color(red: 0.129, green: 0.114, blue: 0.106)
                                          .opacity(min(0.48, dark * 0.46))))
            }
        }
    }
}
