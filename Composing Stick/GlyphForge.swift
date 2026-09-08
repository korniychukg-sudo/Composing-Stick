import Foundation
import CoreGraphics

public struct EmBox {
    public static let cap = 700.0
    public static let xh = 480.0
    public static let asc = 730.0
    public static let dsc = -200.0
    public static let unit = 1000.0
}

public struct Stroke {
    public var pts: [CGPoint]
    public var w: Double = 1.0
    public var wEnd: Double = -1
    public var closed: Bool = false
    public var hole: Bool = false
    public var solid: Bool = false
    public var counter: Bool = false
    public var thin: Bool = false
    public var stress: Bool = true
    public var startSerif: Int = 0
    public var endSerif: Int = 0
    public var startCap: Int = 0
    public var endCap: Int = 0
    public var flatStart: Bool = false
    public var flatEnd: Bool = false
    public var splitY: Double = -9999
    public var splitGap: Double = 0
}

public struct GlyphShape {
    public var adv: Double
    public var strokes: [Stroke]
}

public struct Metal {
    public var ink: [[CGPoint]]
    public var counters: [[CGPoint]]
    public var adv: Double
}

public struct TypeFace {
    public let key: String
    public let name: String
    public let stem: Double
    public let hair: Double
    public let pen: Double
    public let wide: Double
    public let slant: Double
    public let xhScale: Double
    public let capScale: Double
    public let serif: Int
    public let serifLen: Double
    public let serifThick: Double
    public let bracket: Double
    public let cup: Double
    public let terminal: Int
    public let ball: Double
    public let entasis: Double
    public let inlineRatio: Double
    public let mono: Double
    public let jitter: Double
    public let sizes: [Int]
    public let cut: String
    public let story: String
    public let colourNote: String
}

public enum Foundry {
    private static let textFounts: [TypeFace] = [
        TypeFace(key: "caslon", name: "Caslon Old Face", stem: 112, hair: 0.42, pen: -0.30,
                 wide: 1.00, slant: 0, xhScale: 0.95, capScale: 1.00, serif: 3,
                 serifLen: 78, serifThick: 34, bracket: 0.66, cup: 0.12, terminal: 2,
                 ball: 0.46, entasis: 0.055, inlineRatio: 0, mono: 0,
                 jitter: 4.0, sizes: [12, 18, 24, 36],
                 cut: "William Caslon, London, about 1725",
                 story: "Cut by a gunlock engraver who taught himself punchcutting, and for a century the default in every English-speaking shop. The individual letters are not beautiful and no two are quite in agreement, which is exactly why a page of it holds together: the irregularity keeps the eye moving.",
                 colourNote: "Uneven colour on the page, a warm grey mass, letters that lean very slightly against one another."),
        TypeFace(key: "bodoni", name: "Bodoni", stem: 122, hair: 0.13, pen: 0.0,
                 wide: 0.97, slant: 0, xhScale: 1.00, capScale: 1.00, serif: 2,
                 serifLen: 86, serifThick: 20, bracket: 0.05, cup: 0, terminal: 1,
                 ball: 0.62, entasis: 0.028, inlineRatio: 0, mono: 0,
                 jitter: 0.6, sizes: [18, 24, 36, 48],
                 cut: "Giambattista Bodoni, Parma, 1790s",
                 story: "The modern face taken to its limit: stress dead vertical, serifs reduced to unbracketed hairlines, the fat of the letter set hard against the thin. Made for smooth paper and a light impression, and punished by anything else.",
                 colourNote: "Brilliant on a kiss impression. Drive it deep and the hairlines break up or vanish entirely."),
        TypeFace(key: "clarendon", name: "Clarendon", stem: 134, hair: 0.66, pen: 0.0,
                 wide: 1.02, slant: 0, xhScale: 1.03, capScale: 1.00, serif: 1,
                 serifLen: 78, serifThick: 56, bracket: 0.45, cup: 0, terminal: 0,
                 ball: 0.50, entasis: 0.018, inlineRatio: 0, mono: 0,
                 jitter: 1.0, sizes: [18, 24, 36, 60],
                 cut: "Robert Besley for Fann Street Foundry, London, 1845",
                 story: "The first typeface registered under the Ornamental Designs Act, and copied within the three years its protection lasted. A slab serif with brackets, cut to sit beside a roman as a bold rather than to shout on its own.",
                 colourNote: "Solid and even. Takes a heavy impression without complaint and fills in last of all the text faces."),
        TypeFace(key: "gothic", name: "Franklin Gothic", stem: 108, hair: 0.94, pen: 0.0,
                 wide: 0.98, slant: 0, xhScale: 1.04, capScale: 1.00, serif: 0,
                 serifLen: 0, serifThick: 0, bracket: 0, cup: 0, terminal: 0,
                 ball: 0, entasis: 0.014, inlineRatio: 0, mono: 0,
                 jitter: 0.8, sizes: [12, 18, 24, 36],
                 cut: "Morris Fuller Benton, American Type Founders, 1902",
                 story: "In the trade a sans serif is a gothic, and had been since the first one appeared in a Caslon specimen in 1816 under the name Two Lines English Egyptian. Monoline, no serifs, nothing to break: the jobbing face for anything that has to be read across a room.",
                 colourNote: "Flat, dark and unvarying. No hairlines means no weak places, so it survives bad makeready.")
    ]

    private static let displayFounts: [TypeFace] = [
        TypeFace(key: "textura", name: "Old English Text", stem: 158, hair: 0.10, pen: 0.74,
                 wide: 0.70, slant: 0, xhScale: 0.92, capScale: 1.00, serif: 4,
                 serifLen: 40, serifThick: 74, bracket: 0, cup: 0, terminal: 0,
                 ball: 0, entasis: 0, inlineRatio: 0, mono: 0,
                 jitter: 1.2, sizes: [18, 24, 36],
                 cut: "After the northern textura hands, recut through the nineteenth century",
                 story: "Gutenberg's type imitated the formal book hand of the Rhineland, and the shape stayed in the cases long after anyone read it easily. Everything is made with one broad nib held at a fixed angle, which is why the thin strokes all run the same way.",
                 colourNote: "Very dark, very close. Counters are small and it is the first face to fill in when the brayer is loaded."),
        TypeFace(key: "poster", name: "Poster Wood Letter", stem: 178, hair: 0.52, pen: 0.0,
                 wide: 1.18, slant: 0, xhScale: 1.02, capScale: 1.00, serif: 1,
                 serifLen: 92, serifThick: 76, bracket: 0.30, cup: 0, terminal: 0,
                 ball: 0, entasis: 0.016, inlineRatio: 0, mono: 0,
                 jitter: 2.4, sizes: [60, 72, 96],
                 cut: "Cut on end grain maple, American, 1850s onward",
                 story: "Above about seventy two point, metal is too heavy to lift and too expensive to cast, so poster letters were cut from end grain wood on a pantograph. Lighter, cheaper, and it dents rather than breaks.",
                 colourNote: "Wood takes ink unevenly and shows its grain in the solids, which is the look, not a fault."),
        TypeFace(key: "italic", name: "Old Style Italic", stem: 94, hair: 0.40, pen: -0.36,
                 wide: 0.87, slant: 0.21, xhScale: 0.94, capScale: 0.98, serif: 3,
                 serifLen: 62, serifThick: 26, bracket: 0.60, cup: 0.10, terminal: 2,
                 ball: 0.42, entasis: 0.05, inlineRatio: 0, mono: 0,
                 jitter: 3.4, sizes: [12, 18, 24, 36],
                 cut: "After the chancery hands, by way of Aldus Manutius, Venice, 1501",
                 story: "The first italic was not a companion to a roman at all but a face in its own right, cut to squeeze a pocket classic into fewer pages. Only later did shops start keeping it in the same case as an accompaniment.",
                 colourNote: "Narrower, so a line of it sets shorter than the same words in roman. Watch the measure."),
        TypeFace(key: "script", name: "Engraver's Script", stem: 98, hair: 0.10, pen: -0.46,
                 wide: 0.94, slant: 0.34, xhScale: 0.86, capScale: 1.06, serif: 0,
                 serifLen: 0, serifThick: 0, bracket: 0, cup: 0, terminal: 1,
                 ball: 0.44, entasis: 0.07, inlineRatio: 0, mono: 0,
                 jitter: 1.6, sizes: [18, 24, 36],
                 cut: "After the copperplate engravers, English, eighteenth century",
                 story: "Imitates a pointed steel nib on copper, where pressure alone makes the thick stroke. In metal the hairlines are cast as delicate spurs that overhang the body, so the sorts nest into one another and chip if handled roughly.",
                 colourNote: "The most fragile thing in the case. A deep impression crushes the hairlines flat.")
    ]

    private static let jobbingFounts: [TypeFace] = [
        TypeFace(key: "typewriter", name: "Typewriter Face", stem: 92, hair: 0.84, pen: 0.0,
                 wide: 1.00, slant: 0, xhScale: 1.00, capScale: 0.98, serif: 1,
                 serifLen: 70, serifThick: 30, bracket: 0.24, cup: 0, terminal: 0,
                 ball: 0, entasis: 0.016, inlineRatio: 0, mono: 600,
                 jitter: 2.6, sizes: [12, 18, 24],
                 cut: "After the pica typebar faces, 1890s onward",
                 story: "Every sort is the same width, because a typewriter carriage steps the same distance whatever key is struck. In a case that means an i sits on a body as wide as an m, with the letter marooned in the middle of it.",
                 colourNote: "Even and slightly weak. Designed for a ribbon, so it looks thin under proper ink."),
        TypeFace(key: "tuscan", name: "Ornamented Tuscan", stem: 128, hair: 0.46, pen: 0.0,
                 wide: 1.05, slant: 0, xhScale: 1.00, capScale: 1.00, serif: 5,
                 serifLen: 96, serifThick: 54, bracket: 0.24, cup: 0, terminal: 3,
                 ball: 0.40, entasis: 0.02, inlineRatio: 0, mono: 0,
                 jitter: 1.8, sizes: [36, 48, 72],
                 cut: "Vincent Figgins and successors, London, from 1817",
                 story: "The serifs split into two prongs and curl, and often a spur grows out of the middle of the stem. Made for playbills and auction notices, where nobody was going to read a paragraph of it.",
                 colourNote: "The prongs are the weak point. They snap off in the chase and the loss shows on every sheet after."),
        TypeFace(key: "doric", name: "Condensed Doric", stem: 142, hair: 0.90, pen: 0.0,
                 wide: 0.72, slant: 0, xhScale: 1.06, capScale: 1.00, serif: 0,
                 serifLen: 0, serifThick: 0, bracket: 0, cup: 0, terminal: 0,
                 ball: 0, entasis: 0.014, inlineRatio: 0, mono: 0,
                 jitter: 1.0, sizes: [24, 36, 48, 60],
                 cut: "English jobbing foundries, from the 1840s",
                 story: "Squeezed sideways so a long word fits a narrow bill without dropping to a smaller size. Handbill printers lived on it, and it is still the reason old notices read as urgent.",
                 colourNote: "Very dark in the mass. The counters are slots and close up before anything else."),
        TypeFace(key: "shaded", name: "Antique Shaded", stem: 158, hair: 0.70, pen: 0.0,
                 wide: 1.06, slant: 0, xhScale: 1.00, capScale: 1.00, serif: 1,
                 serifLen: 86, serifThick: 66, bracket: 0.34, cup: 0, terminal: 0,
                 ball: 0, entasis: 0.016, inlineRatio: 0.40, mono: 0,
                 jitter: 1.4, sizes: [36, 48, 72],
                 cut: "Inline display letter, French and English, 1830s",
                 story: "A fat slab letter with a white line cut down the middle of every stroke, so it prints as an outline within a solid. The inline is shallower than the face, so it takes no ink at all unless the impression is far too deep.",
                 colourNote: "The inline closing up is the surest sign the forme is over inked or driven too hard.")
    ]

    public static let faces: [TypeFace] = textFounts + displayFounts + jobbingFounts

    public static func face(_ key: String) -> TypeFace {
        faces.first { $0.key == key } ?? faces[0]
    }
}

private func gp(_ x: Double, _ y: Double) -> CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }

private func arcPts(_ cx: Double, _ cy: Double, _ rx: Double, _ ry: Double,
                    _ a0: Double, _ a1: Double, _ n: Int = 26) -> [CGPoint] {
    var out: [CGPoint] = []
    for i in 0...n {
        let a = a0 + (a1 - a0) * Double(i) / Double(n)
        out.append(gp(cx + cos(a) * rx, cy + sin(a) * ry))
    }
    return out
}

private func ringPts(_ cx: Double, _ cy: Double, _ rx: Double, _ ry: Double, _ n: Int = 44) -> [CGPoint] {
    var out: [CGPoint] = []
    for i in 0..<n {
        let a = Double(i) / Double(n) * 2 * Double.pi
        out.append(gp(cx + cos(a) * rx, cy + sin(a) * ry))
    }
    return out
}

private func dLoop(_ x0: Double, _ yb: Double, _ yt: Double, _ xr: Double) -> [CGPoint] {
    let cy = (yb + yt) / 2, ry = (yt - yb) / 2, rx = xr - x0
    var out: [CGPoint] = []
    let back = 7
    for k in 0..<back { out.append(gp(x0, yb + (yt - yb) * Double(k) / Double(back))) }
    for i in 0...24 {
        let a = Double.pi / 2 - Double(i) / 24 * Double.pi
        out.append(gp(x0 + rx * cos(a), cy + ry * sin(a)))
    }
    return out
}

private func dLoopL(_ x0: Double, _ yb: Double, _ yt: Double, _ xl: Double) -> [CGPoint] {
    let cy = (yb + yt) / 2, ry = (yt - yb) / 2, rx = x0 - xl
    var out: [CGPoint] = []
    let back = 7
    for k in 0..<back { out.append(gp(x0, yt - (yt - yb) * Double(k) / Double(back))) }
    for i in 0...24 {
        let a = -Double.pi / 2 - Double(i) / 24 * Double.pi
        out.append(gp(x0 + rx * cos(a), cy + ry * sin(a)))
    }
    return out
}

private func soften(_ pts: [CGPoint], _ rounds: Int = 2) -> [CGPoint] {
    var cur = pts
    for _ in 0..<rounds {
        guard cur.count > 2 else { break }
        var next: [CGPoint] = [cur[0]]
        for i in 0..<(cur.count - 1) {
            let a = cur[i], b = cur[i + 1]
            next.append(CGPoint(x: a.x * 0.75 + b.x * 0.25, y: a.y * 0.75 + b.y * 0.25))
            next.append(CGPoint(x: a.x * 0.25 + b.x * 0.75, y: a.y * 0.25 + b.y * 0.75))
        }
        next.append(cur[cur.count - 1])
        cur = next
    }
    return cur
}

private func softenRing(_ pts: [CGPoint], _ rounds: Int = 2) -> [CGPoint] {
    var cur = pts
    for _ in 0..<rounds {
        guard cur.count > 3 else { break }
        var next: [CGPoint] = []
        for i in 0..<cur.count {
            let a = cur[i], b = cur[(i + 1) % cur.count]
            next.append(CGPoint(x: a.x * 0.72 + b.x * 0.28, y: a.y * 0.72 + b.y * 0.28))
            next.append(CGPoint(x: a.x * 0.28 + b.x * 0.72, y: a.y * 0.28 + b.y * 0.72))
        }
        cur = next
    }
    return cur
}

private func spanOf(_ pts: [CGPoint], closed: Bool) -> [Double] {
    var lens: [Double] = [0]
    var total = 0.0
    let last = closed ? pts.count : pts.count - 1
    for i in 1...max(1, last) {
        let a = pts[i - 1], b = pts[i % pts.count]
        let dx = Double(b.x - a.x), dy = Double(b.y - a.y)
        total += (dx * dx + dy * dy).squareRoot()
        lens.append(total)
    }
    return lens
}

private func resample(_ pts: [CGPoint], _ n: Int, closed: Bool) -> [CGPoint] {
    guard pts.count > 1, n > 2 else { return pts }
    let lens = spanOf(pts, closed: closed)
    let total = lens[lens.count - 1]
    guard total > 0 else { return pts }
    var out: [CGPoint] = []
    var seg = 1
    let steps = closed ? n : n - 1
    for k in 0..<(closed ? n : n) {
        let target = total * Double(k) / Double(steps)
        while seg < lens.count - 1 && lens[seg] < target { seg += 1 }
        let l0 = lens[seg - 1], l1 = lens[seg]
        let t = l1 > l0 ? (target - l0) / (l1 - l0) : 0
        let a = pts[(seg - 1) % pts.count], b = pts[seg % pts.count]
        out.append(CGPoint(x: a.x + (b.x - a.x) * CGFloat(t), y: a.y + (b.y - a.y) * CGFloat(t)))
    }
    return out
}

private func signedArea(_ pts: [CGPoint]) -> Double {
    guard pts.count > 2 else { return 0 }
    var s = 0.0
    for i in 0..<pts.count {
        let a = pts[i], b = pts[(i + 1) % pts.count]
        s += Double(a.x * b.y - b.x * a.y)
    }
    return s / 2
}

private func facing(_ pts: [CGPoint]) -> [CGPoint] {
    signedArea(pts) < 0 ? Array(pts.reversed()) : pts
}

private func shrink(_ pts: [CGPoint], _ by: Double) -> [CGPoint] {
    guard pts.count > 2, by > 0 else { return pts }
    var cx = 0.0, cy = 0.0
    for p in pts { cx += Double(p.x); cy += Double(p.y) }
    cx /= Double(pts.count); cy /= Double(pts.count)
    return pts.map { p in
        let dx = cx - Double(p.x), dy = cy - Double(p.y)
        let d = (dx * dx + dy * dy).squareRoot()
        guard d > by * 1.6 else { return p }
        return CGPoint(x: p.x + CGFloat(dx / d * by), y: p.y + CGFloat(dy / d * by))
    }
}

private func clipHalf(_ pts: [CGPoint], y: Double, above: Bool) -> [CGPoint] {
    guard pts.count > 2 else { return [] }
    func inside(_ p: CGPoint) -> Bool { above ? Double(p.y) >= y : Double(p.y) <= y }
    var out: [CGPoint] = []
    for i in 0..<pts.count {
        let a = pts[i], b = pts[(i + 1) % pts.count]
        let ai = inside(a), bi = inside(b)
        if ai { out.append(a) }
        if ai != bi {
            let dy = Double(b.y - a.y)
            let t = abs(dy) < 0.0001 ? 0 : (y - Double(a.y)) / dy
            out.append(CGPoint(x: a.x + (b.x - a.x) * CGFloat(t), y: CGFloat(y)))
        }
    }
    return out.count > 2 ? out : []
}

public enum Sorts {
    public static let roster: [String] = {
        var out: [String] = []
        for u in 65...90 { out.append(String(UnicodeScalar(UInt8(u)))) }
        for u in 97...122 { out.append(String(UnicodeScalar(UInt8(u)))) }
        for u in 48...57 { out.append(String(UnicodeScalar(UInt8(u)))) }
        out.append(contentsOf: [".", ",", ":", ";", "!", "?", "'", "\"", "-", "\u{2013}",
                                "\u{2014}", "(", ")", "&", "*", "/"])
        return out
    }()

    private static var built: [String: GlyphShape] = [:]

    public static func shape(_ ch: String) -> GlyphShape? {
        if let hit = built[ch] { return hit }
        guard let made = compose(ch) else { return nil }
        built[ch] = made
        return made
    }

    private static func stem(_ x: Double, _ y0: Double, _ y1: Double, w: Double = 1.0,
                             foot: Int = 1, head: Int = 1) -> Stroke {
        Stroke(pts: [gp(x, y0), gp(x, y1)], w: w, startSerif: foot, endSerif: head)
    }

    private static func bar(_ x0: Double, _ x1: Double, _ y: Double, w: Double = 1.0,
                            left: Int = 0, right: Int = 0) -> Stroke {
        Stroke(pts: [gp(x0, y), gp(x1, y)], w: w, thin: true, startSerif: left, endSerif: right)
    }

    private static func slope(_ x0: Double, _ y0: Double, _ x1: Double, _ y1: Double,
                              w: Double = 1.0, thin: Bool = false,
                              start: Int = 0, end: Int = 0,
                              cutStart: Bool = false, cutEnd: Bool = false) -> Stroke {
        Stroke(pts: [gp(x0, y0), gp(x1, y1)], w: w, thin: thin,
               stress: false, startSerif: start, endSerif: end,
               flatStart: start != 0 || cutStart, flatEnd: end != 0 || cutEnd)
    }

    private static func ring(_ cx: Double, _ cy: Double, _ rx: Double, _ ry: Double,
                             w: Double = 1.0, splitY: Double = -9999,
                             splitGap: Double = 0) -> Stroke {
        Stroke(pts: ringPts(cx, cy, rx, ry), w: w, closed: true, hole: true,
               splitY: splitY, splitGap: splitGap)
    }

    private static func loopR(_ x0: Double, _ yb: Double, _ yt: Double, _ xr: Double,
                              w: Double = 1.0) -> Stroke {
        Stroke(pts: dLoop(x0, yb, yt, xr), w: w, closed: true, hole: true)
    }

    private static func loopL(_ x0: Double, _ yb: Double, _ yt: Double, _ xl: Double,
                              w: Double = 1.0) -> Stroke {
        Stroke(pts: dLoopL(x0, yb, yt, xl), w: w, closed: true, hole: true)
    }

    private static func compose(_ ch: String) -> GlyphShape? {
        switch ch {
        case "A": return upperA()
        case "B": return upperB()
        case "C": return upperC()
        case "D": return upperD()
        case "E": return upperE()
        case "F": return upperF()
        case "G": return upperG()
        case "H": return upperH()
        case "I": return upperI()
        case "J": return upperJ()
        case "K": return upperK()
        case "L": return upperL()
        case "M": return upperM()
        case "N": return upperN()
        case "O": return upperO()
        case "P": return upperP()
        case "Q": return upperQ()
        case "R": return upperR()
        case "S": return upperS()
        case "T": return upperT()
        case "U": return upperU()
        case "V": return upperV()
        case "W": return upperW()
        case "X": return upperX()
        case "Y": return upperY()
        case "Z": return upperZ()
        default: return lowerOrFigure(ch)
        }
    }

    private static func lowerOrFigure(_ ch: String) -> GlyphShape? {
        switch ch {
        case "a": return lowerA()
        case "b": return lowerB()
        case "c": return lowerC()
        case "d": return lowerD()
        case "e": return lowerE()
        case "f": return lowerF()
        case "g": return lowerG()
        case "h": return lowerH()
        case "i": return lowerI()
        case "j": return lowerJ()
        case "k": return lowerK()
        case "l": return lowerL()
        case "m": return lowerM()
        case "n": return lowerN()
        case "o": return lowerO()
        case "p": return lowerP()
        case "q": return lowerQ()
        case "r": return lowerR()
        case "s": return lowerS()
        case "t": return lowerT()
        case "u": return lowerU()
        case "v": return lowerV()
        case "w": return lowerW()
        case "x": return lowerX()
        case "y": return lowerY()
        case "z": return lowerZ()
        default: return figureOrPoint(ch)
        }
    }

    private static func figureOrPoint(_ ch: String) -> GlyphShape? {
        switch ch {
        case "0": return fig0()
        case "1": return fig1()
        case "2": return fig2()
        case "3": return fig3()
        case "4": return fig4()
        case "5": return fig5()
        case "6": return fig6()
        case "7": return fig7()
        case "8": return fig8()
        case "9": return fig9()
        case ".": return GlyphShape(adv: 250, strokes: [
            Stroke(pts: ringPts(125, 62, 66, 66, 20), solid: true)])
        case ",": return pointComma(false)
        case ":": return GlyphShape(adv: 250, strokes: [
            Stroke(pts: ringPts(125, 62, 64, 64, 20), solid: true),
            Stroke(pts: ringPts(125, 404, 64, 64, 20), solid: true)])
        case ";": return pointComma(true)
        case "!": return GlyphShape(adv: 280, strokes: [
            Stroke(pts: [gp(146, 190), gp(158, 700)], w: 0.46, wEnd: 1.0, endSerif: 1),
            Stroke(pts: ringPts(146, 62, 64, 64, 20), solid: true)])
        case "?": return pointQuery()
        case "'": return GlyphShape(adv: 200, strokes: [
            Stroke(pts: soften([gp(108, 700), gp(98, 618), gp(72, 522)]), w: 0.98, wEnd: 0.26,
                   stress: false, startCap: 1)])
        case "\"": return GlyphShape(adv: 330, strokes: [
            Stroke(pts: soften([gp(108, 700), gp(98, 618), gp(72, 522)]), w: 0.98, wEnd: 0.26,
                   stress: false, startCap: 1),
            Stroke(pts: soften([gp(246, 700), gp(236, 618), gp(210, 522)]), w: 0.98, wEnd: 0.26,
                   stress: false, startCap: 1)])
        case "-": return GlyphShape(adv: 340, strokes: [bar(64, 276, 300, w: 1.16)])
        case "\u{2013}": return GlyphShape(adv: 500, strokes: [bar(52, 448, 300, w: 1.10)])
        case "\u{2014}": return GlyphShape(adv: 1000, strokes: [bar(34, 966, 300, w: 1.10)])
        case "(": return GlyphShape(adv: 310, strokes: [
            Stroke(pts: arcPts(348, 258, 252, 486, 2.12, 4.16, 22), w: 0.94, stress: false,
                   startCap: 2, endCap: 2)])
        case ")": return GlyphShape(adv: 310, strokes: [
            Stroke(pts: arcPts(-38, 258, 252, 486, 1.02, -1.02, 22), w: 0.94, stress: false,
                   startCap: 2, endCap: 2)])
        case "&": return pointAmp()
        case "*": return pointStar()
        case "/": return GlyphShape(adv: 380, strokes: [
            Stroke(pts: [gp(34, -60), gp(346, 720)], w: 0.62, thin: true, stress: false)])
        default: return nil
        }
    }

    private static func pointComma(_ semi: Bool) -> GlyphShape {
        var s: [Stroke] = [
            Stroke(pts: soften([gp(150, 96), gp(138, -14), gp(96, -100), gp(40, -150)]),
                   w: 0.86, wEnd: 0.18, stress: false, startCap: 1)]
        if semi { s.append(Stroke(pts: ringPts(140, 404, 64, 64, 20), solid: true)) }
        return GlyphShape(adv: 250, strokes: s)
    }

    private static func pointQuery() -> GlyphShape {
        let spine = soften([gp(72, 520), gp(112, 636), gp(232, 704), gp(366, 664),
                            gp(404, 552), gp(336, 464), gp(256, 404), gp(234, 320), gp(232, 236)])
        return GlyphShape(adv: 460, strokes: [
            Stroke(pts: spine, w: 0.52, wEnd: 1.0, stress: false, startCap: 1),
            Stroke(pts: ringPts(232, 62, 64, 64, 20), solid: true)])
    }

    private static func pointAmp() -> GlyphShape {
        let spine = soften([gp(650, 214), gp(560, 62), gp(400, 10), gp(232, 46), gp(152, 160),
                            gp(198, 290), gp(342, 388), gp(440, 480), gp(446, 598),
                            gp(364, 670), gp(258, 656), gp(212, 562), gp(278, 454),
                            gp(432, 302), gp(562, 130), gp(652, 98)])
        return GlyphShape(adv: 700, strokes: [
            Stroke(pts: spine, w: 1.0, wEnd: 0.44, startCap: 1, endCap: 1)])
    }

    private static func pointStar() -> GlyphShape {
        var s: [Stroke] = []
        for k in 0..<5 {
            let a = Double.pi / 2 + Double(k) / 5 * 2 * Double.pi
            s.append(Stroke(pts: [gp(200, 540), gp(200 + cos(a) * 142, 540 + sin(a) * 152)],
                            w: 0.72, thin: true, stress: false))
        }
        return GlyphShape(adv: 400, strokes: s)
    }

    private static func upperA() -> GlyphShape {
        GlyphShape(adv: 660, strokes: [
            slope(84, 0, 336, 710, w: 0.56, thin: true, start: 1),
            slope(324, 710, 586, 0, w: 1.0, end: 1),
            bar(176, 508, 214, w: 0.92)])
    }

    private static func upperB() -> GlyphShape {
        GlyphShape(adv: 620, strokes: [
            stem(112, 0, 700),
            loopR(112, 368, 700, 404, w: 0.92),
            loopR(112, 0, 368, 458)])
    }

    private static func upperC() -> GlyphShape {
        GlyphShape(adv: 640, strokes: [
            Stroke(pts: arcPts(350, 350, 250, 352, 1.02, 5.26, 32), startCap: 1, endCap: 1)])
    }

    private static func upperD() -> GlyphShape {
        GlyphShape(adv: 670, strokes: [
            stem(112, 0, 700),
            loopR(112, 0, 700, 560)])
    }

    private static func upperE() -> GlyphShape {
        GlyphShape(adv: 580, strokes: [
            stem(112, 0, 700),
            bar(112, 494, 700, w: 1.06, right: 5),
            bar(112, 424, 372, w: 0.88, right: 4),
            bar(112, 516, 0, w: 1.14, right: 6)])
    }

    private static func upperF() -> GlyphShape {
        GlyphShape(adv: 560, strokes: [
            stem(112, 0, 700),
            bar(112, 494, 700, w: 1.06, right: 5),
            bar(112, 418, 384, w: 0.88, right: 4)])
    }

    private static func upperG() -> GlyphShape {
        GlyphShape(adv: 690, strokes: [
            Stroke(pts: arcPts(350, 350, 250, 352, 1.02, 5.86, 34), startCap: 1),
            stem(576, 208, 342, w: 0.94, foot: 3, head: 0),
            bar(408, 588, 340, w: 1.0)])
    }

    private static func upperH() -> GlyphShape {
        GlyphShape(adv: 670, strokes: [
            stem(112, 0, 700),
            stem(558, 0, 700),
            bar(112, 558, 362, w: 0.94)])
    }

    private static func upperI() -> GlyphShape {
        GlyphShape(adv: 300, strokes: [stem(150, 0, 700)])
    }

    private static func upperJ() -> GlyphShape {
        let path = [gp(300, 700), gp(300, 176)] + arcPts(178, 176, 122, 178, 0, -Double.pi, 16)
        return GlyphShape(adv: 420, strokes: [
            Stroke(pts: soften(path, 1), w: 1.0, wEnd: 0.52, startSerif: 1, endCap: 1)])
    }

    private static func upperK() -> GlyphShape {
        GlyphShape(adv: 650, strokes: [
            stem(112, 0, 700),
            slope(120, 330, 574, 700, w: 0.60, thin: true, end: 1),
            slope(186, 384, 604, 0, w: 1.0, end: 1)])
    }

    private static func upperL() -> GlyphShape {
        GlyphShape(adv: 546, strokes: [
            stem(112, 0, 700),
            bar(112, 498, 0, w: 1.14, right: 6)])
    }

    private static func upperM() -> GlyphShape {
        GlyphShape(adv: 810, strokes: [
            stem(108, 0, 700, w: 0.80, foot: 1, head: 2),
            slope(104, 700, 412, 108, w: 1.0, cutEnd: true),
            slope(400, 108, 706, 700, w: 0.58, thin: true, cutStart: true),
            stem(702, 0, 700, w: 0.80, foot: 1, head: 3)])
    }

    private static func upperN() -> GlyphShape {
        GlyphShape(adv: 690, strokes: [
            stem(112, 0, 700, w: 0.76, foot: 1, head: 2),
            slope(108, 700, 580, 22, w: 1.0),
            stem(578, 0, 700, w: 0.76, foot: 3, head: 1)])
    }

    private static func upperO() -> GlyphShape {
        GlyphShape(adv: 730, strokes: [ring(366, 350, 272, 352)])
    }

    private static func upperP() -> GlyphShape {
        GlyphShape(adv: 596, strokes: [
            stem(112, 0, 700),
            loopR(112, 322, 700, 480)])
    }

    private static func upperQ() -> GlyphShape {
        GlyphShape(adv: 730, strokes: [
            ring(366, 350, 272, 352),
            Stroke(pts: soften([gp(378, 132), gp(516, 20), gp(638, -136)], 1),
                   w: 0.82, wEnd: 0.36, stress: false, endCap: 1)])
    }

    private static func upperR() -> GlyphShape {
        GlyphShape(adv: 640, strokes: [
            stem(112, 0, 700),
            loopR(112, 330, 700, 462),
            slope(292, 348, 598, 0, w: 1.0, end: 1)])
    }

    private static func upperS() -> GlyphShape {
        let spine = soften([gp(486, 588), gp(424, 668), gp(298, 702), gp(168, 664),
                            gp(120, 566), gp(164, 470), gp(300, 410), gp(430, 350),
                            gp(474, 246), gp(428, 108), gp(296, 54), gp(166, 84), gp(102, 154)])
        return GlyphShape(adv: 578, strokes: [
            Stroke(pts: spine, startCap: 1, endCap: 1)])
    }

    private static func upperT() -> GlyphShape {
        GlyphShape(adv: 590, strokes: [
            bar(62, 528, 700, w: 1.06, left: 5, right: 5),
            stem(296, 0, 700, foot: 1, head: 0)])
    }

    private static func upperU() -> GlyphShape {
        let path = [gp(112, 700), gp(112, 216)] + arcPts(340, 216, 228, 214, Double.pi, 2 * Double.pi, 22)
            + [gp(568, 216), gp(568, 700)]
        return GlyphShape(adv: 676, strokes: [
            Stroke(pts: soften(path, 1), startSerif: 1, endSerif: 1)])
    }

    private static func upperV() -> GlyphShape {
        GlyphShape(adv: 664, strokes: [
            slope(78, 700, 350, -16, w: 1.0, start: 1),
            slope(330, -16, 602, 700, w: 0.58, thin: true, end: 1)])
    }

    private static func upperW() -> GlyphShape {
        GlyphShape(adv: 880, strokes: [
            slope(62, 700, 250, -16, w: 1.0, start: 1),
            slope(228, -16, 428, 700, w: 0.58, thin: true, cutEnd: true),
            slope(414, 700, 610, -16, w: 1.0, cutStart: true),
            slope(588, -16, 786, 700, w: 0.58, thin: true, end: 1)])
    }

    private static func upperX() -> GlyphShape {
        GlyphShape(adv: 650, strokes: [
            slope(90, 700, 568, 0, w: 1.0, start: 1, end: 1),
            slope(568, 700, 90, 0, w: 0.58, thin: true, start: 1, end: 1)])
    }

    private static func upperY() -> GlyphShape {
        GlyphShape(adv: 632, strokes: [
            slope(76, 700, 322, 352, w: 1.0, start: 1),
            slope(568, 700, 306, 352, w: 0.58, thin: true, start: 1),
            stem(316, 0, 372, foot: 1, head: 0)])
    }

    private static func upperZ() -> GlyphShape {
        GlyphShape(adv: 600, strokes: [
            bar(88, 514, 700, w: 1.02, left: 5),
            slope(508, 690, 100, 14, w: 1.0),
            bar(92, 522, 0, w: 1.10, right: 6)])
    }

    private static func lowerA() -> GlyphShape {
        let arch = soften([gp(148, 384), gp(196, 456), gp(292, 490), gp(388, 470),
                           gp(442, 404), gp(448, 344)])
        return GlyphShape(adv: 546, strokes: [
            stem(448, 44, 410, foot: 0, head: 0),
            loopL(448, 40, 306, 96),
            Stroke(pts: arch, w: 0.46, wEnd: 1.0, stress: false, startCap: 1),
            Stroke(pts: soften([gp(448, 52), gp(486, 8), gp(534, 24)], 1),
                   w: 0.58, wEnd: 0.30, stress: false, endCap: 1)])
    }

    private static func lowerB() -> GlyphShape {
        GlyphShape(adv: 556, strokes: [
            stem(112, 0, 730),
            loopR(112, 0, 480, 470)])
    }

    private static func lowerC() -> GlyphShape {
        GlyphShape(adv: 496, strokes: [
            Stroke(pts: arcPts(288, 240, 186, 240, 1.02, 5.26, 28), startCap: 1, endCap: 1)])
    }

    private static func lowerD() -> GlyphShape {
        GlyphShape(adv: 556, strokes: [
            stem(444, 0, 730),
            loopL(444, 0, 480, 86)])
    }

    private static func lowerE() -> GlyphShape {
        let cut = [gp(300, 118), gp(486, 60), gp(520, 168), gp(342, 226)]
        return GlyphShape(adv: 510, strokes: [
            ring(268, 240, 194, 240, splitY: 250, splitGap: 26),
            bar(80, 456, 250, w: 0.98),
            Stroke(pts: cut, counter: true)])
    }

    private static func lowerF() -> GlyphShape {
        let spine = soften([gp(228, 0), gp(228, 588), gp(250, 684), gp(322, 726), gp(388, 700)])
        return GlyphShape(adv: 372, strokes: [
            Stroke(pts: spine, w: 1.0, wEnd: 0.46, startSerif: 1, endCap: 1),
            bar(84, 356, 476, w: 0.94)])
    }

    private static func lowerG() -> GlyphShape {
        GlyphShape(adv: 552, strokes: [
            ring(268, 246, 182, 232),
            Stroke(pts: soften([gp(452, 468), gp(452, -66), gp(392, -158), gp(268, -186),
                                gp(172, -150)], 1),
                   w: 1.0, wEnd: 0.42, stress: false, endCap: 1)])
    }

    private static func lowerH() -> GlyphShape {
        let arch = soften([gp(112, 296), gp(160, 430), gp(258, 486), gp(358, 466),
                           gp(422, 380), gp(434, 296)])
        return GlyphShape(adv: 556, strokes: [
            stem(112, 0, 730),
            Stroke(pts: arch, w: 0.44, wEnd: 1.0, stress: false),
            stem(434, 0, 316, foot: 1, head: 0)])
    }

    private static func lowerI() -> GlyphShape {
        GlyphShape(adv: 290, strokes: [
            stem(142, 0, 480, foot: 1, head: 2),
            Stroke(pts: ringPts(142, 636, 60, 60, 20), solid: true)])
    }

    private static func lowerJ() -> GlyphShape {
        GlyphShape(adv: 290, strokes: [
            Stroke(pts: soften([gp(160, 480), gp(160, -66), gp(110, -158), gp(6, -146)], 1),
                   w: 1.0, wEnd: 0.42, stress: false, startSerif: 2, endCap: 1),
            Stroke(pts: ringPts(160, 636, 60, 60, 20), solid: true)])
    }

    private static func lowerK() -> GlyphShape {
        GlyphShape(adv: 528, strokes: [
            stem(112, 0, 730),
            slope(118, 236, 474, 480, w: 0.60, thin: true, end: 1),
            slope(176, 276, 496, 0, w: 1.0, end: 1)])
    }

    private static func lowerL() -> GlyphShape {
        GlyphShape(adv: 282, strokes: [stem(132, 0, 730)])
    }

    private static func lowerM() -> GlyphShape {
        let a1 = soften([gp(106, 296), gp(152, 430), gp(248, 484), gp(344, 464),
                         gp(402, 380), gp(412, 296)])
        let a2 = soften([gp(412, 296), gp(458, 430), gp(554, 484), gp(650, 464),
                         gp(708, 380), gp(718, 296)])
        return GlyphShape(adv: 840, strokes: [
            stem(106, 0, 480, foot: 1, head: 2),
            Stroke(pts: a1, w: 0.44, wEnd: 1.0, stress: false),
            stem(412, 0, 316, foot: 1, head: 0),
            Stroke(pts: a2, w: 0.44, wEnd: 1.0, stress: false),
            stem(718, 0, 316, foot: 1, head: 0)])
    }

    private static func lowerN() -> GlyphShape {
        let arch = soften([gp(112, 296), gp(160, 430), gp(258, 486), gp(358, 466),
                           gp(422, 380), gp(434, 296)])
        return GlyphShape(adv: 556, strokes: [
            stem(112, 0, 480, foot: 1, head: 2),
            Stroke(pts: arch, w: 0.44, wEnd: 1.0, stress: false),
            stem(434, 0, 316, foot: 1, head: 0)])
    }

    private static func lowerO() -> GlyphShape {
        GlyphShape(adv: 548, strokes: [ring(274, 240, 206, 240)])
    }

    private static func lowerP() -> GlyphShape {
        GlyphShape(adv: 556, strokes: [
            stem(112, -200, 480, foot: 1, head: 2),
            loopR(112, 0, 480, 470)])
    }

    private static func lowerQ() -> GlyphShape {
        GlyphShape(adv: 556, strokes: [
            stem(444, -200, 480, foot: 1, head: 0),
            loopL(444, 0, 480, 86)])
    }

    private static func lowerR() -> GlyphShape {
        let arch = soften([gp(112, 300), gp(166, 438), gp(268, 488), gp(360, 472)])
        return GlyphShape(adv: 408, strokes: [
            stem(112, 0, 480, foot: 1, head: 2),
            Stroke(pts: arch, w: 0.44, wEnd: 0.82, stress: false, endCap: 1)])
    }

    private static func lowerS() -> GlyphShape {
        let spine = soften([gp(384, 396), gp(330, 466), gp(228, 492), gp(126, 458),
                            gp(96, 388), gp(140, 320), gp(244, 274), gp(332, 224),
                            gp(356, 148), gp(308, 56), gp(206, 12), gp(110, 38), gp(62, 96)])
        return GlyphShape(adv: 452, strokes: [
            Stroke(pts: spine, startCap: 1, endCap: 1)])
    }

    private static func lowerT() -> GlyphShape {
        GlyphShape(adv: 360, strokes: [
            Stroke(pts: soften([gp(180, 636), gp(180, 92), gp(226, 22), gp(310, 40)], 1),
                   w: 1.0, wEnd: 0.48, endCap: 1),
            bar(50, 322, 476, w: 0.94)])
    }

    private static func lowerU() -> GlyphShape {
        let path = [gp(112, 480), gp(112, 178)] + arcPts(272, 178, 160, 176, Double.pi, 2 * Double.pi, 18)
        return GlyphShape(adv: 556, strokes: [
            Stroke(pts: soften(path, 1), w: 1.0, wEnd: 0.62, startSerif: 2, endSerif: 0),
            stem(432, 0, 480, foot: 1, head: 1)])
    }

    private static func lowerV() -> GlyphShape {
        GlyphShape(adv: 508, strokes: [
            slope(70, 480, 268, -12, w: 1.0, start: 1),
            slope(252, -12, 446, 480, w: 0.58, thin: true, end: 1)])
    }

    private static func lowerW() -> GlyphShape {
        GlyphShape(adv: 730, strokes: [
            slope(56, 480, 222, -14, w: 1.0, start: 1),
            slope(202, -14, 372, 480, w: 0.58, thin: true, cutEnd: true),
            slope(358, 480, 526, -14, w: 1.0, cutStart: true),
            slope(506, -14, 672, 480, w: 0.58, thin: true, end: 1)])
    }

    private static func lowerX() -> GlyphShape {
        GlyphShape(adv: 498, strokes: [
            slope(70, 480, 424, 0, w: 1.0, start: 1, end: 1),
            slope(424, 480, 70, 0, w: 0.58, thin: true, start: 1, end: 1)])
    }

    private static func lowerY() -> GlyphShape {
        GlyphShape(adv: 508, strokes: [
            slope(64, 480, 272, 32, w: 1.0, start: 1),
            Stroke(pts: soften([gp(446, 480), gp(250, 22), gp(178, -124), gp(58, -186)], 1),
                   w: 0.58, thin: true, stress: false, startSerif: 1, endCap: 1,
                   flatStart: true)])
    }

    private static func lowerZ() -> GlyphShape {
        GlyphShape(adv: 470, strokes: [
            bar(74, 392, 480, w: 1.02, left: 5),
            slope(388, 472, 88, 10, w: 1.0),
            bar(80, 404, 0, w: 1.10, right: 6)])
    }

    private static func fig0() -> GlyphShape {
        GlyphShape(adv: 552, strokes: [ring(276, 350, 190, 352)])
    }

    private static func fig1() -> GlyphShape {
        GlyphShape(adv: 552, strokes: [
            stem(288, 0, 700, foot: 0, head: 0),
            slope(120, 548, 290, 692, w: 0.58, thin: true),
            bar(122, 452, 0, w: 1.10)])
    }

    private static func fig2() -> GlyphShape {
        let spine = soften([gp(86, 546), gp(150, 650), gp(268, 704), gp(398, 668),
                            gp(440, 556), gp(390, 444), gp(250, 326), gp(120, 188), gp(78, 30)])
        return GlyphShape(adv: 552, strokes: [
            Stroke(pts: spine, startCap: 1),
            bar(70, 472, 22, w: 1.10)])
    }

    private static func fig3() -> GlyphShape {
        let top = soften([gp(94, 554), gp(152, 652), gp(270, 704), gp(394, 662), gp(414, 552),
                          gp(330, 470), gp(238, 456)])
        let low = soften([gp(238, 456), gp(364, 440), gp(454, 358), gp(444, 198),
                          gp(340, 66), gp(198, 42), gp(102, 90), gp(72, 162)])
        return GlyphShape(adv: 552, strokes: [
            Stroke(pts: top, w: 0.94, startCap: 1),
            Stroke(pts: low, endCap: 1)])
    }

    private static func fig4() -> GlyphShape {
        GlyphShape(adv: 552, strokes: [
            slope(344, 690, 68, 214, w: 0.58, thin: true),
            bar(56, 488, 214, w: 1.06),
            stem(350, 0, 700, foot: 1, head: 0)])
    }

    private static func fig5() -> GlyphShape {
        let bowl = soften([gp(106, 452), gp(252, 476), gp(392, 424), gp(452, 300),
                           gp(430, 142), gp(310, 34), gp(166, 34), gp(80, 108)])
        return GlyphShape(adv: 552, strokes: [
            bar(122, 436, 700, w: 1.02, left: 5),
            stem(116, 452, 700, w: 0.86, foot: 0, head: 0),
            Stroke(pts: bowl, endCap: 1)])
    }

    private static func fig6() -> GlyphShape {
        let spine = soften([gp(446, 606), gp(372, 686), gp(254, 700), gp(158, 622),
                            gp(110, 470), gp(98, 306)])
        return GlyphShape(adv: 552, strokes: [
            Stroke(pts: spine, startCap: 1),
            ring(276, 196, 180, 196)])
    }

    private static func fig7() -> GlyphShape {
        GlyphShape(adv: 552, strokes: [
            bar(80, 478, 700, w: 1.02, left: 5),
            slope(472, 692, 214, 0, w: 1.0, end: 1)])
    }

    private static func fig8() -> GlyphShape {
        GlyphShape(adv: 552, strokes: [
            ring(276, 528, 158, 170, w: 0.90),
            ring(276, 182, 192, 184)])
    }

    private static func fig9() -> GlyphShape {
        let spine = soften([gp(102, 94), gp(180, 14), gp(298, 4), gp(394, 84),
                            gp(442, 236), gp(454, 400)])
        return GlyphShape(adv: 552, strokes: [
            Stroke(pts: spine, endCap: 1),
            ring(276, 510, 180, 196)])
    }
}

public enum Forge {
    private static var cache: [String: Metal] = [:]

    public static func metal(_ ch: String, _ f: TypeFace) -> Metal? {
        let key = f.key + "|" + ch
        if let hit = cache[key] { return hit }
        guard let shape = Sorts.shape(ch) else { return nil }
        let made = build(shape, f, ch)
        cache[key] = made
        return made
    }

    public static func setWidth(_ ch: String, _ f: TypeFace) -> Double {
        if ch == " " { return 0 }
        guard let m = metal(ch, f) else { return 0 }
        return m.adv
    }

    private static func hashOf(_ s: String) -> UInt64 {
        var h: UInt64 = 14695981039346656037
        for b in s.utf8 { h = (h ^ UInt64(b)) &* 1099511628211 }
        return h
    }

    private struct Spin {
        var s: UInt64
        init(_ v: UInt64) { s = v == 0 ? 0x9E3779B97F4A7C15 : v }
        mutating func next() -> UInt64 { s ^= s << 13; s ^= s >> 7; s ^= s << 17; return s }
        mutating func d() -> Double { Double(next() % 1_000_000) / 1_000_000.0 }
        mutating func signed() -> Double { d() * 2 - 1 }
    }

    private static func yMap(_ y: Double, _ f: TypeFace) -> Double {
        let xhOut = EmBox.xh * f.xhScale
        let capOut = EmBox.cap * f.capScale
        if y <= 0 { return y }
        if y <= EmBox.xh { return y / EmBox.xh * xhOut }
        return xhOut + (y - EmBox.xh) / (EmBox.cap - EmBox.xh) * (capOut - xhOut)
    }

    private static func place(_ p: CGPoint, _ f: TypeFace, _ dx: Double) -> CGPoint {
        let y = yMap(Double(p.y), f)
        let x = Double(p.x) * f.wide + f.slant * y + dx
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    private static func build(_ shape: GlyphShape, _ f: TypeFace, _ ch: String) -> Metal {
        var ink: [[CGPoint]] = []
        var counters: [[CGPoint]] = []
        var rng = Spin(hashOf(f.key + ch))
        var adv = shape.adv * f.wide
        var dx = 0.0
        if f.mono > 0 {
            dx = (f.mono - adv) / 2
            adv = f.mono
        }
        let wobble = f.jitter > 0 ? f.jitter : 0

        for s in shape.strokes {
            let lean = wobble > 0 ? rng.signed() * wobble * 0.9 : 0
            let rise = wobble > 0 ? rng.signed() * wobble * 0.5 : 0
            let gain = wobble > 0 ? 1 + rng.signed() * wobble * 0.006 : 1
            var raw = s.pts.map { place($0, f, dx) }
            if wobble > 0 {
                raw = raw.map { CGPoint(x: $0.x + CGFloat(lean), y: $0.y + CGFloat(rise)) }
            }
            if s.solid { ink.append(facing(raw)); continue }
            if s.counter { counters.append(facing(raw)); continue }
            if s.closed {
                let (outer, inner) = closedBody(raw, s, f, gain)
                ink.append(facing(outer))
                let cut = shrink(inner, 2.0)
                if s.splitY > -9000 {
                    let mid = yMap(s.splitY, f) + rise
                    let gap = s.splitGap * 0.5
                    let hi = clipHalf(cut, y: mid + gap, above: true)
                    let lo = clipHalf(cut, y: mid - gap, above: false)
                    if hi.count > 2 { counters.append(facing(hi)) }
                    if lo.count > 2 { counters.append(facing(lo)) }
                } else {
                    counters.append(facing(cut))
                }
                if f.inlineRatio > 0 {
                    let mid = zip(outer, inner).map { a, b in
                        CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
                    }
                    let grow = zip(outer, mid).map { a, b in
                        CGPoint(x: b.x + (a.x - b.x) * CGFloat(f.inlineRatio),
                                y: b.y + (a.y - b.y) * CGFloat(f.inlineRatio))
                    }
                    let shrunk = zip(inner, mid).map { a, b in
                        CGPoint(x: b.x + (a.x - b.x) * CGFloat(f.inlineRatio),
                                y: b.y + (a.y - b.y) * CGFloat(f.inlineRatio))
                    }
                    counters.append(facing(grow))
                    counters.append(facing(shrunk))
                }
                continue
            }
            let parts = openBody(raw, s, f, gain)
            for piece in parts.0 { ink.append(facing(piece)) }
            if f.inlineRatio > 0, let core = parts.1 { counters.append(facing(core)) }
        }
        return Metal(ink: ink, counters: counters, adv: adv)
    }

    private static func halfWidth(_ theta: Double, _ s: Stroke, _ t: Double,
                                  _ f: TypeFace, _ gain: Double) -> Double {
        let base = s.wEnd < 0 ? s.w : s.w + (s.wEnd - s.w) * t
        var factor = 1.0
        if s.thin {
            factor = min(1.05, 0.12 + f.hair * 0.86)
        } else if s.stress {
            factor = f.hair + (1 - f.hair) * pow(abs(sin(theta - f.pen)), 0.85)
        }
        var hw = f.stem * base * factor * gain * 0.5
        if !s.closed && f.entasis > 0 {
            hw *= 1 - f.entasis * sin(Double.pi * min(1, max(0, t)))
        }
        return max(2.6, hw)
    }

    private static func closedBody(_ raw: [CGPoint], _ s: Stroke, _ f: TypeFace,
                                   _ gain: Double) -> ([CGPoint], [CGPoint]) {
        let smooth = softenRing(raw, 2)
        let lens = spanOf(smooth, closed: true)
        let total = lens[lens.count - 1]
        let n = max(30, min(180, Int(total / 12) + 24))
        let spine = resample(smooth, n, closed: true)
        var sideA: [CGPoint] = []
        var sideB: [CGPoint] = []
        var minR = 1_000_000.0
        var cx = 0.0, cy = 0.0
        for p in spine { cx += Double(p.x); cy += Double(p.y) }
        cx /= Double(spine.count); cy /= Double(spine.count)
        for p in spine {
            let dx = Double(p.x) - cx, dy = Double(p.y) - cy
            minR = min(minR, (dx * dx + dy * dy).squareRoot())
        }
        let maxHW = max(8.0, minR * 0.62)
        for i in 0..<spine.count {
            let prev = spine[(i - 1 + spine.count) % spine.count]
            let next = spine[(i + 1) % spine.count]
            var tx = Double(next.x - prev.x), ty = Double(next.y - prev.y)
            let len = (tx * tx + ty * ty).squareRoot()
            if len > 0 { tx /= len; ty /= len } else { tx = 1; ty = 0 }
            let theta = atan2(ty, tx)
            let hw = min(maxHW, halfWidth(theta, s, 0.5, f, gain))
            let nx = -ty, ny = tx
            let px = Double(spine[i].x), py = Double(spine[i].y)
            sideA.append(CGPoint(x: CGFloat(px + nx * hw), y: CGFloat(py + ny * hw)))
            sideB.append(CGPoint(x: CGFloat(px - nx * hw), y: CGFloat(py - ny * hw)))
        }
        let aBig = abs(signedArea(sideA)) >= abs(signedArea(sideB))
        return (aBig ? sideA : sideB, aBig ? sideB : sideA)
    }

    private static func openBody(_ raw: [CGPoint], _ s: Stroke, _ f: TypeFace,
                                 _ gain: Double) -> ([[CGPoint]], [CGPoint]?) {
        guard raw.count > 1 else { return ([], nil) }
        let lens = spanOf(raw, closed: false)
        let total = lens[lens.count - 1]
        guard total > 1 else { return ([], nil) }
        let n = max(8, min(160, Int(total / 11) + 8))
        let spine = resample(raw, n, closed: false)
        let count = spine.count
        var sideA: [CGPoint] = []
        var sideB: [CGPoint] = []
        var tangents: [(Double, Double)] = []
        var widths: [Double] = []
        for i in 0..<count {
            let t = count > 1 ? Double(i) / Double(count - 1) : 0
            let prev = spine[max(0, i - 1)]
            let next = spine[min(count - 1, i + 1)]
            var tx = Double(next.x - prev.x), ty = Double(next.y - prev.y)
            let len = (tx * tx + ty * ty).squareRoot()
            if len > 0 { tx /= len; ty /= len } else { tx = 1; ty = 0 }
            let theta = atan2(ty, tx)
            var hw = halfWidth(theta, s, t, f, gain)
            if f.terminal == 3 {
                let edge = min(t, 1 - t)
                if edge < 0.12 { hw *= 1 + (0.12 - edge) * 2.6 }
            }
            tangents.append((tx, ty))
            widths.append(hw)
            let nx = -ty, ny = tx
            sideA.append(CGPoint(x: spine[i].x + CGFloat(nx * hw), y: spine[i].y + CGFloat(ny * hw)))
            sideB.append(CGPoint(x: spine[i].x - CGFloat(nx * hw), y: spine[i].y - CGFloat(ny * hw)))
        }

        if s.flatStart { flatten(&sideA, &sideB, 0, tangents[0]) }
        if s.flatEnd { flatten(&sideA, &sideB, count - 1, tangents[count - 1]) }
        if s.startCap == 2 { shear(&sideA, &sideB, 0, tangents[0], widths[0], -1) }
        if s.endCap == 2 { shear(&sideA, &sideB, count - 1, tangents[count - 1], widths[count - 1], 1) }
        if f.terminal == 2 {
            if s.startCap == 1 { shear(&sideA, &sideB, 0, tangents[0], widths[0], -1) }
            if s.endCap == 1 { shear(&sideA, &sideB, count - 1, tangents[count - 1], widths[count - 1], 1) }
        }

        var out: [[CGPoint]] = [sideA + sideB.reversed()]
        if f.terminal == 1 {
            if s.startCap == 1 { out.append(knob(spine[0], tangents[0], widths[0], f, -1)) }
            if s.endCap == 1 { out.append(knob(spine[count - 1], tangents[count - 1], widths[count - 1], f, 1)) }
        }
        if f.serif > 0 {
            if let piece = serif(spine[0], tangents[0], widths[0], s.startSerif, f, into: 1) {
                out.append(piece)
            }
            if let piece = serif(spine[count - 1], tangents[count - 1], widths[count - 1],
                                 s.endSerif, f, into: -1) {
                out.append(piece)
            }
        }

        var core: [CGPoint]? = nil
        if f.inlineRatio > 0 {
            var a: [CGPoint] = []
            var b: [CGPoint] = []
            for i in 0..<count {
                let (tx, ty) = tangents[i]
                let hw = widths[i] * f.inlineRatio
                let nx = -ty, ny = tx
                a.append(CGPoint(x: spine[i].x + CGFloat(nx * hw), y: spine[i].y + CGFloat(ny * hw)))
                b.append(CGPoint(x: spine[i].x - CGFloat(nx * hw), y: spine[i].y - CGFloat(ny * hw)))
            }
            core = a + b.reversed()
        }
        return (out, core)
    }

    private static func flatten(_ a: inout [CGPoint], _ b: inout [CGPoint], _ i: Int,
                                _ tangent: (Double, Double)) {
        guard abs(tangent.1) > 0.08 else { return }
        let target = (Double(a[i].y) + Double(b[i].y)) / 2
        func snap(_ p: CGPoint) -> CGPoint {
            let dy = target - Double(p.y)
            let k = dy / tangent.1
            return CGPoint(x: p.x + CGFloat(tangent.0 * k), y: CGFloat(target))
        }
        a[i] = snap(a[i])
        b[i] = snap(b[i])
    }

    private static func shear(_ a: inout [CGPoint], _ b: inout [CGPoint], _ i: Int,
                              _ tangent: (Double, Double), _ hw: Double, _ dir: Double) {
        let push = hw * 0.40 * dir
        a[i] = CGPoint(x: a[i].x + CGFloat(tangent.0 * push), y: a[i].y + CGFloat(tangent.1 * push))
        b[i] = CGPoint(x: b[i].x - CGFloat(tangent.0 * push * 0.30),
                       y: b[i].y - CGFloat(tangent.1 * push * 0.30))
    }

    private static func knob(_ p: CGPoint, _ tangent: (Double, Double), _ hw: Double,
                             _ f: TypeFace, _ dir: Double) -> [CGPoint] {
        let r = max(hw * 1.06, f.stem * f.ball * 0.5)
        let cx = Double(p.x) + tangent.0 * (r - hw * 0.5) * dir
        let cy = Double(p.y) + tangent.1 * (r - hw * 0.5) * dir
        var out: [CGPoint] = []
        for i in 0..<20 {
            let a = Double(i) / 20 * 2 * Double.pi
            out.append(CGPoint(x: CGFloat(cx + cos(a) * r), y: CGFloat(cy + sin(a) * r * 0.96)))
        }
        return out
    }

    private static func serif(_ p: CGPoint, _ tangent: (Double, Double), _ hw: Double,
                              _ kind: Int, _ f: TypeFace, into: Double) -> [CGPoint]? {
        guard kind > 0 else { return nil }
        var ux = 1.0, uy = 0.0
        var vx = 0.0, vy = 1.0
        if kind >= 4 {
            guard abs(tangent.0) > 0.05 else { return nil }
            ux = 0; uy = 1
            vx = tangent.0 * into >= 0 ? 1 : -1
            vy = 0
        } else {
            let up = tangent.1 * into
            guard abs(up) > 0.12 else { return nil }
            vy = up > 0 ? 1 : -1
        }
        let half = max(3.0, hw)
        let proj = f.serifLen
        var left = half + proj
        var right = half + proj
        switch kind {
        case 2: right = half + proj * 0.14
        case 3: left = half + proj * 0.14
        case 5: left = half + proj * 0.94; right = half + proj * 0.16
        case 6: left = half + proj * 0.16; right = half + proj * 0.94
        default: break
        }
        let th = f.serifThick
        func at(_ u: Double, _ v: Double) -> CGPoint {
            CGPoint(x: p.x + CGFloat(ux * u + vx * v), y: p.y + CGFloat(uy * u + vy * v))
        }
        if f.serif == 4 {
            return [at(-left, th * 0.86), at(0, -th * 0.14), at(right, th * 0.86), at(0, th * 1.86)]
        }
        if f.serif == 5 {
            return [at(-left, th * 1.16), at(-left * 0.58, -th * 0.12), at(-left * 0.20, th * 0.66),
                    at(0, th * 0.08), at(right * 0.20, th * 0.66), at(right * 0.58, -th * 0.12),
                    at(right, th * 1.16), at(right * 0.62, th * 1.86), at(0, th * 1.26),
                    at(-left * 0.62, th * 1.86)]
        }
        let slim = min(1.0, half / max(1.0, f.stem * 0.38))
        let rise = th * f.bracket * 2.7 * slim
        let runR = max(0, min(proj * 0.88, min(rise * 1.35, right - half - 2)))
        let runL = max(0, min(proj * 0.88, min(rise * 1.35, left - half - 2)))
        let riseR = rise * (runR > 1 ? 1 : 0)
        let riseL = rise * (runL > 1 ? 1 : 0)
        let lift = max(riseR, riseL)
        var out: [CGPoint] = [at(-left, 0)]
        if f.cup > 0 { out.append(at(0, th * f.cup)) }
        out.append(at(right, 0))
        out.append(at(right, th))
        if runR > 1 {
            for k in 0...7 {
                let a = Double(k) / 7 * Double.pi / 2
                out.append(at(half + runR * cos(a), th + riseR * sin(a)))
            }
        } else {
            out.append(at(half, th))
        }
        out.append(at(-half, th + lift))
        if runL > 1 {
            for k in 0...7 {
                let a = Double(7 - k) / 7 * Double.pi / 2
                out.append(at(-(half + runL * cos(a)), th + riseL * sin(a)))
            }
        } else {
            out.append(at(-half, th))
        }
        out.append(at(-left, th))
        return out
    }
}

public enum Composer {
    public static func lineWidth(_ text: String, _ f: TypeFace, _ pointSize: Double) -> Double {
        var total = 0.0
        for ch in text {
            let s = String(ch)
            if s == " " { total += pointSize / 3; continue }
            total += Forge.setWidth(s, f) / EmBox.unit * pointSize
        }
        return total
    }

    public static func available(_ text: String) -> Bool {
        for ch in text where String(ch) != " " {
            if Sorts.shape(String(ch)) == nil { return false }
        }
        return true
    }
}
