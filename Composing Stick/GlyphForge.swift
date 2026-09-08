import Foundation
import CoreGraphics

public struct EmBox {
    public static let cap = 700.0
    public static let xh = 480.0
    public static let asc = 730.0
    public static let dsc = -200.0
    public static let unit = 1000.0
}

public struct Strand {
    public var pts: [CGPoint]
    public var closed: Bool = false
    public var w: Double = 1.0
    public var wEnd: Double = -1
    public var a: Int = 0
    public var b: Int = 0
    public var hole: Bool = false
    public var blob: Bool = false
    public var counterOnly: Bool = false
}

public struct GlyphShape {
    public var adv: Double
    public var strands: [Strand]
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
    public let ball: Double
    public let inlineRatio: Double
    public let mono: Double
    public let jitter: Double
    public let sizes: [Int]
    public let cut: String
    public let story: String
    public let colourNote: String
}

public enum Foundry {
    public static let faces: [TypeFace] = [
        TypeFace(key: "caslon", name: "Caslon Old Face", stem: 90, hair: 0.34, pen: -0.30,
                 wide: 1.00, slant: 0, xhScale: 0.95, capScale: 1.00, serif: 3,
                 serifLen: 112, serifThick: 40, ball: 0.34, inlineRatio: 0, mono: 0,
                 jitter: 5.5, sizes: [12, 18, 24, 36],
                 cut: "William Caslon, London, about 1725",
                 story: "Cut by a gunlock engraver who taught himself punchcutting, and for a century the default in every English-speaking shop. The individual letters are not beautiful and no two are quite in agreement, which is exactly why a page of it holds together: the irregularity keeps the eye moving.",
                 colourNote: "Uneven colour on the page, a warm grey mass, letters that lean very slightly against one another."),
        TypeFace(key: "bodoni", name: "Bodoni", stem: 106, hair: 0.10, pen: 0.0,
                 wide: 0.97, slant: 0, xhScale: 1.00, capScale: 1.00, serif: 2,
                 serifLen: 124, serifThick: 22, ball: 0.56, inlineRatio: 0, mono: 0,
                 jitter: 1.0, sizes: [18, 24, 36, 48],
                 cut: "Giambattista Bodoni, Parma, 1790s",
                 story: "The modern face taken to its limit: stress dead vertical, serifs reduced to unbracketed hairlines, the fat of the letter set hard against the thin. Made for smooth paper and a light impression, and punished by anything else.",
                 colourNote: "Brilliant on a kiss impression. Drive it deep and the hairlines break up or vanish entirely."),
        TypeFace(key: "clarendon", name: "Clarendon", stem: 120, hair: 0.62, pen: 0.0,
                 wide: 1.02, slant: 0, xhScale: 1.03, capScale: 1.00, serif: 1,
                 serifLen: 108, serifThick: 66, ball: 0.50, inlineRatio: 0, mono: 0,
                 jitter: 1.5, sizes: [18, 24, 36, 60],
                 cut: "Robert Besley for Fann Street Foundry, London, 1845",
                 story: "The first typeface registered under the Ornamental Designs Act, and copied within the three years its protection lasted. A slab serif with brackets, cut to sit beside a roman as a bold rather than to shout on its own.",
                 colourNote: "Solid and even. Takes a heavy impression without complaint and fills in last of all the text faces."),
        TypeFace(key: "gothic", name: "Franklin Gothic", stem: 98, hair: 1.00, pen: 0.0,
                 wide: 0.98, slant: 0, xhScale: 1.04, capScale: 1.00, serif: 0,
                 serifLen: 0, serifThick: 0, ball: 0, inlineRatio: 0, mono: 0,
                 jitter: 1.0, sizes: [12, 18, 24, 36],
                 cut: "Morris Fuller Benton, American Type Founders, 1902",
                 story: "In the trade a sans serif is a gothic, and had been since the first one appeared in a Caslon specimen in 1816 under the name Two Lines English Egyptian. Monoline, no serifs, nothing to break: the jobbing face for anything that has to be read across a room.",
                 colourNote: "Flat, dark and unvarying. No hairlines means no weak places, so it survives bad makeready."),
        TypeFace(key: "textura", name: "Old English Text", stem: 136, hair: 0.12, pen: 0.66,
                 wide: 0.70, slant: 0, xhScale: 0.92, capScale: 1.00, serif: 4,
                 serifLen: 74, serifThick: 74, ball: 0, inlineRatio: 0, mono: 0,
                 jitter: 2.0, sizes: [18, 24, 36],
                 cut: "After the northern textura hands, recut through the nineteenth century",
                 story: "Gutenberg's type imitated the formal book hand of the Rhineland, and the shape stayed in the cases long after anyone read it easily. Everything is made with one broad nib held at a fixed angle, which is why the thin strokes all run the same way.",
                 colourNote: "Very dark, very close. Counters are small and it is the first face to fill in when the brayer is loaded."),
        TypeFace(key: "poster", name: "Poster Wood Letter", stem: 172, hair: 0.24, pen: 0.0,
                 wide: 1.18, slant: 0, xhScale: 1.02, capScale: 1.00, serif: 1,
                 serifLen: 128, serifThick: 82, ball: 0, inlineRatio: 0, mono: 0,
                 jitter: 3.0, sizes: [60, 72, 96],
                 cut: "Cut on end grain maple, American, 1850s onward",
                 story: "Above about seventy two point, metal is too heavy to lift and too expensive to cast, so poster letters were cut from end grain wood on a pantograph. Lighter, cheaper, and it dents rather than breaks.",
                 colourNote: "Wood takes ink unevenly and shows its grain in the solids, which is the look, not a fault."),
        TypeFace(key: "italic", name: "Old Style Italic", stem: 82, hair: 0.34, pen: -0.36,
                 wide: 0.87, slant: 0.21, xhScale: 0.94, capScale: 0.98, serif: 3,
                 serifLen: 82, serifThick: 30, ball: 0.30, inlineRatio: 0, mono: 0,
                 jitter: 4.5, sizes: [12, 18, 24, 36],
                 cut: "After the chancery hands, by way of Aldus Manutius, Venice, 1501",
                 story: "The first italic was not a companion to a roman at all but a face in its own right, cut to squeeze a pocket classic into fewer pages. Only later did shops start keeping it in the same case as an accompaniment.",
                 colourNote: "Narrower, so a line of it sets shorter than the same words in roman. Watch the measure."),
        TypeFace(key: "script", name: "Engraver's Script", stem: 78, hair: 0.11, pen: -0.46,
                 wide: 0.94, slant: 0.32, xhScale: 0.86, capScale: 1.06, serif: 0,
                 serifLen: 0, serifThick: 0, ball: 0.40, inlineRatio: 0, mono: 0,
                 jitter: 2.0, sizes: [18, 24, 36],
                 cut: "After the copperplate engravers, English, eighteenth century",
                 story: "Imitates a pointed steel nib on copper, where pressure alone makes the thick stroke. In metal the hairlines are cast as delicate spurs that overhang the body, so the sorts nest into one another and chip if handled roughly.",
                 colourNote: "The most fragile thing in the case. A deep impression crushes the hairlines flat."),
        TypeFace(key: "typewriter", name: "Typewriter Face", stem: 86, hair: 0.80, pen: 0.0,
                 wide: 1.00, slant: 0, xhScale: 1.00, capScale: 0.98, serif: 1,
                 serifLen: 96, serifThick: 36, ball: 0, inlineRatio: 0, mono: 600,
                 jitter: 3.5, sizes: [12, 18, 24],
                 cut: "After the pica typebar faces, 1890s onward",
                 story: "Every sort is the same width, because a typewriter carriage steps the same distance whatever key is struck. In a case that means an i sits on a body as wide as an m, with the letter marooned in the middle of it.",
                 colourNote: "Even and slightly weak. Designed for a ribbon, so it looks thin under proper ink."),
        TypeFace(key: "tuscan", name: "Ornamented Tuscan", stem: 122, hair: 0.40, pen: 0.0,
                 wide: 1.05, slant: 0, xhScale: 1.00, capScale: 1.00, serif: 5,
                 serifLen: 132, serifThick: 48, ball: 0, inlineRatio: 0, mono: 0,
                 jitter: 2.5, sizes: [36, 48, 72],
                 cut: "Vincent Figgins and successors, London, from 1817",
                 story: "The serifs split into two prongs and curl, and often a spur grows out of the middle of the stem. Made for playbills and auction notices, where nobody was going to read a paragraph of it.",
                 colourNote: "The prongs are the weak point. They snap off in the chase and the loss shows on every sheet after."),
        TypeFace(key: "doric", name: "Condensed Doric", stem: 134, hair: 0.86, pen: 0.0,
                 wide: 0.72, slant: 0, xhScale: 1.06, capScale: 1.00, serif: 0,
                 serifLen: 0, serifThick: 0, ball: 0, inlineRatio: 0, mono: 0,
                 jitter: 1.5, sizes: [24, 36, 48, 60],
                 cut: "English jobbing foundries, from the 1840s",
                 story: "Squeezed sideways so a long word fits a narrow bill without dropping to a smaller size. Handbill printers lived on it, and it is still the reason old notices read as urgent.",
                 colourNote: "Very dark in the mass. The counters are slots and close up before anything else."),
        TypeFace(key: "shaded", name: "Antique Shaded", stem: 152, hair: 0.66, pen: 0.0,
                 wide: 1.06, slant: 0, xhScale: 1.00, capScale: 1.00, serif: 1,
                 serifLen: 116, serifThick: 72, ball: 0, inlineRatio: 0.42, mono: 0,
                 jitter: 2.0, sizes: [36, 48, 72],
                 cut: "Inline display letter, French and English, 1830s",
                 story: "A fat slab letter with a white line cut down the middle of every stroke, so it prints as an outline within a solid. The inline is shallower than the face, so it takes no ink at all unless the impression is far too deep.",
                 colourNote: "The inline closing up is the surest sign the forme is over inked or driven too hard.")
    ]

    public static func face(_ key: String) -> TypeFace {
        faces.first { $0.key == key } ?? faces[0]
    }
}

private func gp(_ x: Double, _ y: Double) -> CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }

private func arcPts(_ cx: Double, _ cy: Double, _ rx: Double, _ ry: Double,
                    _ a0: Double, _ a1: Double, _ n: Int = 22) -> [CGPoint] {
    var out: [CGPoint] = []
    for i in 0...n {
        let a = a0 + (a1 - a0) * Double(i) / Double(n)
        out.append(gp(cx + cos(a) * rx, cy + sin(a) * ry))
    }
    return out
}

private func ringPts(_ cx: Double, _ cy: Double, _ rx: Double, _ ry: Double, _ n: Int = 32) -> [CGPoint] {
    var out: [CGPoint] = []
    for i in 0..<n {
        let a = Double(i) / Double(n) * 2 * Double.pi
        out.append(gp(cx + cos(a) * rx, cy + sin(a) * ry))
    }
    return out
}

private func dLoop(_ x0: Double, _ yb: Double, _ yt: Double, _ xr: Double, _ n: Int = 22) -> [CGPoint] {
    let cy = (yb + yt) / 2, ry = (yt - yb) / 2, rx = xr - x0
    var out: [CGPoint] = []
    for i in 0...n {
        let t = Double(i) / Double(n) * Double.pi
        out.append(gp(x0 + rx * sin(t), cy + ry * cos(t)))
    }
    let back = 8
    for k in 1..<back { out.append(gp(x0, yb + (yt - yb) * Double(k) / Double(back))) }
    return out
}

private func dLoopL(_ x0: Double, _ yb: Double, _ yt: Double, _ xl: Double, _ n: Int = 22) -> [CGPoint] {
    let cy = (yb + yt) / 2, ry = (yt - yb) / 2, rx = x0 - xl
    var out: [CGPoint] = []
    for i in 0...n {
        let t = Double(i) / Double(n) * Double.pi
        out.append(gp(x0 - rx * sin(t), cy - ry * cos(t)))
    }
    let back = 8
    for k in 1..<back { out.append(gp(x0, yt - (yt - yb) * Double(k) / Double(back))) }
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

private func rail(_ pts: [CGPoint], _ n: Int) -> [CGPoint] {
    guard pts.count > 1, n > 1 else { return pts }
    var lens: [Double] = [0]
    var total = 0.0
    for i in 1..<pts.count {
        let dx = Double(pts[i].x - pts[i - 1].x), dy = Double(pts[i].y - pts[i - 1].y)
        total += (dx * dx + dy * dy).squareRoot()
        lens.append(total)
    }
    guard total > 0 else { return pts }
    var out: [CGPoint] = []
    var seg = 1
    for k in 0..<n {
        let target = total * Double(k) / Double(n - 1)
        while seg < lens.count - 1 && lens[seg] < target { seg += 1 }
        let l0 = lens[seg - 1], l1 = lens[seg]
        let t = l1 > l0 ? (target - l0) / (l1 - l0) : 0
        let a = pts[seg - 1], b = pts[seg]
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
        case ".": return GlyphShape(adv: 250, strands: [Strand(pts: ringPts(125, 58, 64, 64, 18), closed: true, blob: true)])
        case ",": return pointComma(0)
        case ":": return GlyphShape(adv: 250, strands: [
            Strand(pts: ringPts(125, 58, 62, 62, 18), closed: true, blob: true),
            Strand(pts: ringPts(125, 400, 62, 62, 18), closed: true, blob: true)])
        case ";": return pointComma(400)
        case "!": return GlyphShape(adv: 280, strands: [
            Strand(pts: [gp(140, 700), gp(152, 200)], w: 1.0, wEnd: 0.42),
            Strand(pts: ringPts(152, 58, 62, 62, 18), closed: true, blob: true)])
        case "?": return pointQuery()
        case "'": return GlyphShape(adv: 200, strands: [
            Strand(pts: soften([gp(105, 700), gp(96, 620), gp(74, 528)]), w: 0.95, wEnd: 0.30)])
        case "\"": return GlyphShape(adv: 330, strands: [
            Strand(pts: soften([gp(105, 700), gp(96, 620), gp(74, 528)]), w: 0.95, wEnd: 0.30),
            Strand(pts: soften([gp(240, 700), gp(231, 620), gp(209, 528)]), w: 0.95, wEnd: 0.30)])
        case "-": return GlyphShape(adv: 340, strands: [Strand(pts: [gp(58, 300), gp(282, 300)], w: 0.52, a: 2, b: 2)])
        case "\u{2013}": return GlyphShape(adv: 500, strands: [Strand(pts: [gp(46, 300), gp(454, 300)], w: 0.50, a: 2, b: 2)])
        case "\u{2014}": return GlyphShape(adv: 1000, strands: [Strand(pts: [gp(28, 300), gp(972, 300)], w: 0.50, a: 2, b: 2)])
        case "(": return GlyphShape(adv: 310, strands: [
            Strand(pts: arcPts(345, 260, 250, 480, 2.10, 4.18, 20), w: 0.86, wEnd: 0.86)])
        case ")": return GlyphShape(adv: 310, strands: [
            Strand(pts: arcPts(-35, 260, 250, 480, 1.04, -1.04, 20), w: 0.86, wEnd: 0.86)])
        case "&": return pointAmp()
        case "*": return pointStar()
        case "/": return GlyphShape(adv: 380, strands: [Strand(pts: [gp(36, -60), gp(344, 720)], w: 0.58)])
        default: return nil
        }
    }

    private static func pointComma(_ lift: Double) -> GlyphShape {
        var s: [Strand] = [
            Strand(pts: ringPts(128, 58 + lift * 0, 62, 62, 18), closed: true, blob: true),
            Strand(pts: soften([gp(126, 40), gp(112, -60), gp(58, -160)]), w: 0.62, wEnd: 0.22)]
        if lift > 0 { s.append(Strand(pts: ringPts(128, lift, 62, 62, 18), closed: true, blob: true)) }
        return GlyphShape(adv: 250, strands: s)
    }

    private static func pointQuery() -> GlyphShape {
        let spine = soften([gp(74, 520), gp(112, 632), gp(228, 702), gp(360, 668),
                            gp(404, 560), gp(340, 470), gp(258, 412), gp(232, 322), gp(230, 232)])
        return GlyphShape(adv: 460, strands: [
            Strand(pts: spine, w: 0.96, wEnd: 0.60),
            Strand(pts: ringPts(230, 58, 62, 62, 18), closed: true, blob: true)])
    }

    private static func pointAmp() -> GlyphShape {
        let spine = soften([gp(646, 210), gp(560, 60), gp(400, 8), gp(232, 44), gp(150, 158),
                            gp(196, 288), gp(340, 386), gp(438, 478), gp(444, 596),
                            gp(362, 668), gp(258, 654), gp(212, 560), gp(276, 452),
                            gp(430, 300), gp(560, 128), gp(650, 96)])
        return GlyphShape(adv: 700, strands: [Strand(pts: spine, w: 1.0, wEnd: 0.5)])
    }

    private static func pointStar() -> GlyphShape {
        var s: [Strand] = []
        for k in 0..<5 {
            let a = Double.pi / 2 + Double(k) / 5 * 2 * Double.pi
            s.append(Strand(pts: [gp(200, 540), gp(200 + cos(a) * 140, 540 + sin(a) * 150)], w: 0.62))
        }
        return GlyphShape(adv: 400, strands: s)
    }

    private static func upperA() -> GlyphShape {
        GlyphShape(adv: 660, strands: [
            Strand(pts: [gp(82, 0), gp(320, 700)], w: 0.62, a: 1),
            Strand(pts: [gp(580, 0), gp(346, 700)], w: 1.0, a: 1),
            Strand(pts: [gp(166, 232), gp(500, 232)], w: 0.46)])
    }

    private static func upperB() -> GlyphShape {
        GlyphShape(adv: 620, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 1.0, a: 1, b: 1),
            Strand(pts: dLoop(112, 376, 700, 408), closed: true, w: 0.98, hole: true),
            Strand(pts: dLoop(112, 0, 376, 450), closed: true, w: 1.0, hole: true)])
    }

    private static func upperC() -> GlyphShape {
        GlyphShape(adv: 640, strands: [
            Strand(pts: arcPts(340, 350, 252, 356, 0.95, 5.33, 28), w: 1.0, a: 5, b: 5)])
    }

    private static func upperD() -> GlyphShape {
        GlyphShape(adv: 670, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 1.0, a: 1, b: 1),
            Strand(pts: dLoop(112, 0, 700, 566), closed: true, w: 1.0, hole: true)])
    }

    private static func upperE() -> GlyphShape {
        GlyphShape(adv: 580, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 1.0),
            Strand(pts: [gp(112, 700), gp(496, 700)], w: 0.50, b: 2),
            Strand(pts: [gp(112, 372), gp(430, 372)], w: 0.44, b: 2),
            Strand(pts: [gp(112, 0), gp(516, 0)], w: 0.52, b: 2)])
    }

    private static func upperF() -> GlyphShape {
        GlyphShape(adv: 560, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 1.0, a: 1),
            Strand(pts: [gp(112, 700), gp(496, 700)], w: 0.50, b: 2),
            Strand(pts: [gp(112, 386), gp(422, 386)], w: 0.44, b: 2)])
    }

    private static func upperG() -> GlyphShape {
        GlyphShape(adv: 690, strands: [
            Strand(pts: arcPts(340, 350, 252, 356, 0.95, 5.90, 30), w: 1.0, a: 5),
            Strand(pts: [gp(572, 216), gp(572, 336)], w: 0.98),
            Strand(pts: [gp(572, 336), gp(412, 336)], w: 0.48, b: 2)])
    }

    private static func upperH() -> GlyphShape {
        GlyphShape(adv: 670, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 1.0, a: 1, b: 1),
            Strand(pts: [gp(556, 0), gp(556, 700)], w: 1.0, a: 1, b: 1),
            Strand(pts: [gp(112, 366), gp(556, 366)], w: 0.46)])
    }

    private static func upperI() -> GlyphShape {
        GlyphShape(adv: 300, strands: [
            Strand(pts: [gp(150, 0), gp(150, 700)], w: 1.0, a: 1, b: 1)])
    }

    private static func upperJ() -> GlyphShape {
        GlyphShape(adv: 420, strands: [
            Strand(pts: [gp(292, 700), gp(292, 190)] + arcPts(168, 190, 124, 186, 0, -Double.pi, 14),
                   w: 1.0, wEnd: 0.72, a: 1)])
    }

    private static func upperK() -> GlyphShape {
        GlyphShape(adv: 650, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 1.0, a: 1, b: 1),
            Strand(pts: [gp(576, 700), gp(186, 336)], w: 0.56, a: 2),
            Strand(pts: [gp(268, 410), gp(606, 0)], w: 0.98, b: 1)])
    }

    private static func upperL() -> GlyphShape {
        GlyphShape(adv: 546, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 1.0, b: 1),
            Strand(pts: [gp(112, 0), gp(498, 0)], w: 0.52, b: 2)])
    }

    private static func upperM() -> GlyphShape {
        GlyphShape(adv: 810, strands: [
            Strand(pts: [gp(108, 0), gp(108, 700)], w: 0.78, a: 1),
            Strand(pts: [gp(114, 692), gp(404, 132)], w: 1.0),
            Strand(pts: [gp(404, 132), gp(694, 692)], w: 0.60),
            Strand(pts: [gp(700, 0), gp(700, 700)], w: 0.90, a: 1)])
    }

    private static func upperN() -> GlyphShape {
        GlyphShape(adv: 690, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 0.72, a: 1),
            Strand(pts: [gp(120, 690), gp(568, 22)], w: 1.0),
            Strand(pts: [gp(576, 0), gp(576, 700)], w: 0.72, a: 1)])
    }

    private static func upperO() -> GlyphShape {
        GlyphShape(adv: 730, strands: [
            Strand(pts: ringPts(364, 350, 276, 358, 36), closed: true, w: 1.0, hole: true)])
    }

    private static func upperP() -> GlyphShape {
        GlyphShape(adv: 596, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 1.0, a: 1, b: 1),
            Strand(pts: dLoop(112, 326, 700, 486), closed: true, w: 1.0, hole: true)])
    }

    private static func upperQ() -> GlyphShape {
        GlyphShape(adv: 730, strands: [
            Strand(pts: ringPts(364, 350, 276, 358, 36), closed: true, w: 1.0, hole: true),
            Strand(pts: [gp(392, 116), gp(632, -136)], w: 0.80, wEnd: 0.44)])
    }

    private static func upperR() -> GlyphShape {
        GlyphShape(adv: 640, strands: [
            Strand(pts: [gp(112, 0), gp(112, 700)], w: 1.0, a: 1, b: 1),
            Strand(pts: dLoop(112, 336, 700, 466), closed: true, w: 1.0, hole: true),
            Strand(pts: [gp(318, 340), gp(596, 0)], w: 0.94, b: 1)])
    }

    private static func upperS() -> GlyphShape {
        let spine = soften([gp(492, 592), gp(430, 674), gp(300, 702), gp(162, 662),
                            gp(118, 566), gp(160, 468), gp(300, 406), gp(432, 348),
                            gp(474, 246), gp(430, 108), gp(298, 56), gp(168, 82), gp(102, 152)])
        return GlyphShape(adv: 578, strands: [Strand(pts: spine, w: 1.0, a: 5, b: 5)])
    }

    private static func upperT() -> GlyphShape {
        GlyphShape(adv: 590, strands: [
            Strand(pts: [gp(62, 700), gp(528, 700)], w: 0.50, a: 2, b: 2),
            Strand(pts: [gp(294, 0), gp(294, 700)], w: 1.0, a: 1)])
    }

    private static func upperU() -> GlyphShape {
        let path = [gp(112, 700), gp(112, 190)] + arcPts(338, 190, 226, 190, Double.pi, 2 * Double.pi, 18)
            + [gp(564, 190), gp(564, 700)]
        return GlyphShape(adv: 676, strands: [Strand(pts: path, w: 1.0, wEnd: 0.74, a: 1, b: 1)])
    }

    private static func upperV() -> GlyphShape {
        GlyphShape(adv: 664, strands: [
            Strand(pts: [gp(78, 700), gp(340, 0)], w: 1.0, a: 1),
            Strand(pts: [gp(340, 0), gp(600, 700)], w: 0.58, b: 1)])
    }

    private static func upperW() -> GlyphShape {
        GlyphShape(adv: 880, strands: [
            Strand(pts: [gp(62, 700), gp(240, 0)], w: 1.0, a: 1),
            Strand(pts: [gp(240, 0), gp(420, 686)], w: 0.58),
            Strand(pts: [gp(420, 686), gp(600, 0)], w: 1.0),
            Strand(pts: [gp(600, 0), gp(782, 700)], w: 0.58, b: 1)])
    }

    private static func upperX() -> GlyphShape {
        GlyphShape(adv: 650, strands: [
            Strand(pts: [gp(90, 700), gp(566, 0)], w: 1.0, a: 1, b: 1),
            Strand(pts: [gp(566, 700), gp(90, 0)], w: 0.58, a: 1, b: 1)])
    }

    private static func upperY() -> GlyphShape {
        GlyphShape(adv: 632, strands: [
            Strand(pts: [gp(78, 700), gp(314, 344)], w: 1.0, a: 1),
            Strand(pts: [gp(566, 700), gp(314, 344)], w: 0.58, a: 1),
            Strand(pts: [gp(314, 344), gp(314, 0)], w: 1.0, b: 1)])
    }

    private static func upperZ() -> GlyphShape {
        GlyphShape(adv: 600, strands: [
            Strand(pts: [gp(90, 700), gp(514, 700)], w: 0.50, a: 2),
            Strand(pts: [gp(508, 692), gp(100, 12)], w: 1.0),
            Strand(pts: [gp(94, 0), gp(522, 0)], w: 0.52, b: 2)])
    }

    private static func lowerA() -> GlyphShape {
        let arch = soften([gp(146, 396), gp(196, 462), gp(292, 492), gp(384, 476), gp(438, 412), gp(444, 340)])
        return GlyphShape(adv: 546, strands: [
            Strand(pts: [gp(444, 400), gp(444, 66)], w: 1.0),
            Strand(pts: dLoopL(444, 46, 316, 96), closed: true, w: 0.96, hole: true),
            Strand(pts: arch, w: 0.92, wEnd: 0.44, a: 5),
            Strand(pts: soften([gp(444, 60), gp(478, 6), gp(524, 22)]), w: 0.52, wEnd: 0.30)])
    }

    private static func lowerB() -> GlyphShape {
        GlyphShape(adv: 556, strands: [
            Strand(pts: [gp(112, 0), gp(112, 730)], w: 1.0, a: 1, b: 1),
            Strand(pts: dLoop(112, 0, 480, 474), closed: true, w: 1.0, hole: true)])
    }

    private static func lowerC() -> GlyphShape {
        GlyphShape(adv: 496, strands: [
            Strand(pts: arcPts(282, 240, 184, 250, 0.95, 5.33, 26), w: 1.0, a: 5, b: 5)])
    }

    private static func lowerD() -> GlyphShape {
        GlyphShape(adv: 556, strands: [
            Strand(pts: [gp(444, 0), gp(444, 730)], w: 1.0, a: 1, b: 1),
            Strand(pts: dLoopL(444, 0, 480, 82), closed: true, w: 1.0, hole: true)])
    }

    private static func lowerE() -> GlyphShape {
        let counter = [gp(122, 268)] + arcPts(268, 268, 146, 148, Double.pi, 0, 16) + [gp(414, 268)]
        return GlyphShape(adv: 510, strands: [
            Strand(pts: arcPts(268, 240, 190, 250, 0.02, 5.30, 28), w: 1.0, b: 5),
            Strand(pts: [gp(84, 248), gp(452, 248)], w: 0.44),
            Strand(pts: counter, closed: true, counterOnly: true)])
    }

    private static func lowerF() -> GlyphShape {
        GlyphShape(adv: 372, strands: [
            Strand(pts: soften([gp(232, 0), gp(232, 596), gp(252, 686), gp(322, 730), gp(382, 706)]),
                   w: 1.0, wEnd: 0.52, a: 1),
            Strand(pts: [gp(88, 476), gp(352, 476)], w: 0.44)])
    }

    private static func lowerG() -> GlyphShape {
        GlyphShape(adv: 552, strands: [
            Strand(pts: ringPts(268, 244, 178, 236, 30), closed: true, w: 0.96, hole: true),
            Strand(pts: soften([gp(452, 480), gp(452, -78), gp(392, -168), gp(272, -194), gp(178, -158)]),
                   w: 1.0, wEnd: 0.46, a: 1)])
    }

    private static func lowerH() -> GlyphShape {
        let arch = soften([gp(112, 328), gp(162, 442), gp(262, 486), gp(360, 468), gp(422, 388), gp(432, 302)])
        return GlyphShape(adv: 556, strands: [
            Strand(pts: [gp(112, 0), gp(112, 730)], w: 1.0, a: 1, b: 1),
            Strand(pts: arch + [gp(432, 0)], w: 0.94, b: 1)])
    }

    private static func lowerI() -> GlyphShape {
        GlyphShape(adv: 290, strands: [
            Strand(pts: [gp(142, 0), gp(142, 480)], w: 1.0, a: 1, b: 1),
            Strand(pts: ringPts(142, 634, 58, 58, 18), closed: true, blob: true)])
    }

    private static func lowerJ() -> GlyphShape {
        GlyphShape(adv: 290, strands: [
            Strand(pts: soften([gp(158, 480), gp(158, -76), gp(102, -170), gp(4, -158)]),
                   w: 1.0, wEnd: 0.46, a: 1),
            Strand(pts: ringPts(158, 634, 58, 58, 18), closed: true, blob: true)])
    }

    private static func lowerK() -> GlyphShape {
        GlyphShape(adv: 528, strands: [
            Strand(pts: [gp(112, 0), gp(112, 730)], w: 1.0, a: 1, b: 1),
            Strand(pts: [gp(476, 480), gp(186, 242)], w: 0.58, a: 2),
            Strand(pts: [gp(252, 300), gp(496, 0)], w: 0.94, b: 1)])
    }

    private static func lowerL() -> GlyphShape {
        GlyphShape(adv: 282, strands: [
            Strand(pts: [gp(132, 0), gp(132, 730)], w: 1.0, a: 1, b: 1)])
    }

    private static func lowerM() -> GlyphShape {
        let a1 = soften([gp(106, 328), gp(154, 442), gp(248, 484), gp(342, 466), gp(400, 386), gp(410, 302)])
        let a2 = soften([gp(410, 328), gp(458, 442), gp(552, 484), gp(646, 466), gp(704, 386), gp(714, 302)])
        return GlyphShape(adv: 840, strands: [
            Strand(pts: [gp(106, 0), gp(106, 480)], w: 1.0, a: 1, b: 1),
            Strand(pts: a1 + [gp(410, 0)], w: 0.94, b: 1),
            Strand(pts: a2 + [gp(714, 0)], w: 0.94, b: 1)])
    }

    private static func lowerN() -> GlyphShape {
        let arch = soften([gp(112, 328), gp(162, 442), gp(262, 486), gp(360, 468), gp(422, 388), gp(432, 302)])
        return GlyphShape(adv: 556, strands: [
            Strand(pts: [gp(112, 0), gp(112, 480)], w: 1.0, a: 1, b: 1),
            Strand(pts: arch + [gp(432, 0)], w: 0.94, b: 1)])
    }

    private static func lowerO() -> GlyphShape {
        GlyphShape(adv: 548, strands: [
            Strand(pts: ringPts(274, 240, 208, 250, 32), closed: true, w: 1.0, hole: true)])
    }

    private static func lowerP() -> GlyphShape {
        GlyphShape(adv: 556, strands: [
            Strand(pts: [gp(112, -200), gp(112, 480)], w: 1.0, a: 1, b: 1),
            Strand(pts: dLoop(112, 0, 480, 474), closed: true, w: 1.0, hole: true)])
    }

    private static func lowerQ() -> GlyphShape {
        GlyphShape(adv: 556, strands: [
            Strand(pts: [gp(444, -200), gp(444, 480)], w: 1.0, a: 1, b: 1),
            Strand(pts: dLoopL(444, 0, 480, 82), closed: true, w: 1.0, hole: true)])
    }

    private static func lowerR() -> GlyphShape {
        let arch = soften([gp(112, 328), gp(168, 446), gp(268, 488), gp(364, 472)])
        return GlyphShape(adv: 408, strands: [
            Strand(pts: [gp(112, 0), gp(112, 480)], w: 1.0, a: 1, b: 1),
            Strand(pts: arch, w: 0.86, wEnd: 0.52, b: 5)])
    }

    private static func lowerS() -> GlyphShape {
        let spine = soften([gp(390, 392), gp(332, 464), gp(230, 490), gp(128, 458),
                            gp(98, 388), gp(138, 320), gp(242, 274), gp(332, 224),
                            gp(358, 148), gp(310, 56), gp(208, 12), gp(112, 36), gp(64, 92)])
        return GlyphShape(adv: 452, strands: [Strand(pts: spine, w: 1.0, a: 5, b: 5)])
    }

    private static func lowerT() -> GlyphShape {
        GlyphShape(adv: 360, strands: [
            Strand(pts: soften([gp(182, 634), gp(182, 76), gp(232, 12), gp(308, 30)]),
                   w: 1.0, wEnd: 0.54),
            Strand(pts: [gp(52, 476), gp(316, 476)], w: 0.44)])
    }

    private static func lowerU() -> GlyphShape {
        let path = [gp(112, 480), gp(112, 168)] + arcPts(272, 168, 160, 168, Double.pi, 2 * Double.pi, 16)
            + [gp(432, 168), gp(432, 480)]
        return GlyphShape(adv: 556, strands: [
            Strand(pts: path, w: 1.0, wEnd: 0.94, a: 1, b: 1),
            Strand(pts: [gp(432, 200), gp(432, 0)], w: 0.94, b: 1)])
    }

    private static func lowerV() -> GlyphShape {
        GlyphShape(adv: 508, strands: [
            Strand(pts: [gp(70, 480), gp(256, 0)], w: 1.0, a: 2),
            Strand(pts: [gp(256, 0), gp(442, 480)], w: 0.58, b: 2)])
    }

    private static func lowerW() -> GlyphShape {
        GlyphShape(adv: 730, strands: [
            Strand(pts: [gp(58, 480), gp(212, 0)], w: 1.0, a: 2),
            Strand(pts: [gp(212, 0), gp(360, 470)], w: 0.58),
            Strand(pts: [gp(360, 470), gp(508, 0)], w: 1.0),
            Strand(pts: [gp(508, 0), gp(664, 480)], w: 0.58, b: 2)])
    }

    private static func lowerX() -> GlyphShape {
        GlyphShape(adv: 498, strands: [
            Strand(pts: [gp(72, 480), gp(422, 0)], w: 1.0, a: 2, b: 2),
            Strand(pts: [gp(422, 480), gp(72, 0)], w: 0.58, a: 2, b: 2)])
    }

    private static func lowerY() -> GlyphShape {
        GlyphShape(adv: 508, strands: [
            Strand(pts: [gp(66, 480), gp(266, 36)], w: 1.0, a: 2),
            Strand(pts: soften([gp(438, 480), gp(244, 18), gp(176, -126), gp(62, -186)]),
                   w: 0.60, wEnd: 0.42, a: 2)])
    }

    private static func lowerZ() -> GlyphShape {
        GlyphShape(adv: 470, strands: [
            Strand(pts: [gp(76, 480), gp(392, 480)], w: 0.46, a: 2),
            Strand(pts: [gp(388, 472), gp(88, 10)], w: 1.0),
            Strand(pts: [gp(82, 0), gp(404, 0)], w: 0.48, b: 2)])
    }

    private static func fig0() -> GlyphShape {
        GlyphShape(adv: 552, strands: [
            Strand(pts: ringPts(274, 350, 190, 356, 32), closed: true, w: 1.0, hole: true)])
    }

    private static func fig1() -> GlyphShape {
        GlyphShape(adv: 552, strands: [
            Strand(pts: [gp(286, 0), gp(286, 700)], w: 1.0),
            Strand(pts: [gp(120, 552), gp(288, 690)], w: 0.58),
            Strand(pts: [gp(122, 0), gp(452, 0)], w: 0.50, a: 2, b: 2)])
    }

    private static func fig2() -> GlyphShape {
        let spine = soften([gp(88, 544), gp(150, 646), gp(266, 702), gp(396, 668),
                            gp(438, 558), gp(390, 446), gp(250, 328), gp(120, 190), gp(78, 30)])
        return GlyphShape(adv: 552, strands: [
            Strand(pts: spine, w: 1.0, a: 5),
            Strand(pts: [gp(72, 22), gp(470, 22)], w: 0.50, b: 2)])
    }

    private static func fig3() -> GlyphShape {
        let top = soften([gp(96, 552), gp(152, 650), gp(268, 702), gp(392, 662), gp(412, 552),
                          gp(330, 470), gp(240, 456)])
        let low = soften([gp(240, 456), gp(364, 440), gp(452, 358), gp(442, 198),
                          gp(340, 68), gp(200, 44), gp(104, 90), gp(74, 162)])
        return GlyphShape(adv: 552, strands: [
            Strand(pts: top, w: 0.94, a: 5), Strand(pts: low, w: 1.0, b: 5)])
    }

    private static func fig4() -> GlyphShape {
        GlyphShape(adv: 552, strands: [
            Strand(pts: [gp(342, 690), gp(70, 216)], w: 0.56),
            Strand(pts: [gp(58, 216), gp(486, 216)], w: 0.48, b: 2),
            Strand(pts: [gp(348, 0), gp(348, 700)], w: 1.0, a: 1)])
    }

    private static func fig5() -> GlyphShape {
        let bowl = soften([gp(108, 452), gp(252, 474), gp(392, 424), gp(452, 300),
                           gp(430, 142), gp(310, 36), gp(168, 36), gp(82, 108)])
        return GlyphShape(adv: 552, strands: [
            Strand(pts: [gp(122, 700), gp(436, 700)], w: 0.50, a: 2, b: 2),
            Strand(pts: [gp(122, 700), gp(106, 452)], w: 0.82),
            Strand(pts: bowl, w: 1.0, b: 5)])
    }

    private static func fig6() -> GlyphShape {
        let spine = soften([gp(444, 604), gp(372, 684), gp(256, 698), gp(160, 622),
                            gp(112, 470), gp(100, 306)])
        return GlyphShape(adv: 552, strands: [
            Strand(pts: spine, w: 1.0, a: 5),
            Strand(pts: ringPts(274, 194, 178, 194, 28), closed: true, w: 0.98, hole: true)])
    }

    private static func fig7() -> GlyphShape {
        GlyphShape(adv: 552, strands: [
            Strand(pts: [gp(82, 700), gp(476, 700)], w: 0.50, a: 2, b: 2),
            Strand(pts: [gp(472, 692), gp(216, 0)], w: 1.0, b: 1)])
    }

    private static func fig8() -> GlyphShape {
        GlyphShape(adv: 552, strands: [
            Strand(pts: ringPts(274, 528, 158, 172, 28), closed: true, w: 0.90, hole: true),
            Strand(pts: ringPts(274, 182, 192, 186, 28), closed: true, w: 1.0, hole: true)])
    }

    private static func fig9() -> GlyphShape {
        let spine = soften([gp(104, 96), gp(180, 18), gp(296, 6), gp(392, 86),
                            gp(440, 236), gp(452, 400)])
        return GlyphShape(adv: 552, strands: [
            Strand(pts: spine, w: 1.0, b: 5),
            Strand(pts: ringPts(274, 508, 178, 194, 28), closed: true, w: 0.98, hole: true)])
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

        for strand in shape.strands {
            let raw = strand.pts.map { place($0, f, dx) }
            if strand.counterOnly {
                counters.append(raw)
                continue
            }
            if strand.blob {
                ink.append(raw)
                continue
            }
            let (solid, hollow) = ribbon(raw, strand, f, &rng)
            ink.append(contentsOf: solid)
            counters.append(contentsOf: hollow)
            if f.inlineRatio > 0 && !strand.closed {
                var thin = strand
                thin.w = strand.w * f.inlineRatio
                thin.wEnd = (strand.wEnd < 0 ? strand.w : strand.wEnd) * f.inlineRatio
                thin.a = 0
                thin.b = 0
                var rng2 = Spin(hashOf(f.key + ch + "in"))
                let (core, _) = ribbon(raw, thin, f, &rng2)
                counters.append(contentsOf: core)
            }
        }
        return Metal(ink: ink, counters: counters, adv: adv)
    }

    private static func ribbon(_ raw: [CGPoint], _ strand: Strand, _ f: TypeFace,
                               _ rng: inout Spin) -> ([[CGPoint]], [[CGPoint]]) {
        guard raw.count > 1 else { return ([], []) }
        var length = 0.0
        for i in 1..<raw.count {
            let dx = Double(raw[i].x - raw[i - 1].x), dy = Double(raw[i].y - raw[i - 1].y)
            length += (dx * dx + dy * dy).squareRoot()
        }
        let n = max(6, min(120, Int(length / 16) + 6))
        var spine = strand.closed ? raw : rail(raw, n)
        if strand.closed && spine.count > 3 && spine.first == spine.last { spine.removeLast() }

        let wStart = strand.w
        let wFinish = strand.wEnd < 0 ? strand.w : strand.wEnd
        var sideA: [CGPoint] = []
        var sideB: [CGPoint] = []
        let count = spine.count
        for i in 0..<count {
            let t = count > 1 ? Double(i) / Double(count - 1) : 0
            let prev = strand.closed ? spine[(i - 1 + count) % count] : spine[max(0, i - 1)]
            let next = strand.closed ? spine[(i + 1) % count] : spine[min(count - 1, i + 1)]
            var tx = Double(next.x - prev.x), ty = Double(next.y - prev.y)
            let len = (tx * tx + ty * ty).squareRoot()
            if len > 0 { tx /= len; ty /= len } else { tx = 1; ty = 0 }
            let theta = atan2(ty, tx)
            let contrast = max(f.hair, abs(sin(theta - f.pen)))
            let scale = wStart + (wFinish - wStart) * t
            var hw = f.stem * scale * contrast * 0.5
            if f.jitter > 0 { hw += rng.signed() * f.jitter * 0.35 }
            hw = max(4.0, hw)
            let nx = -ty, ny = tx
            let wob = f.jitter > 0 ? rng.signed() * f.jitter * 0.30 : 0
            let cx = Double(spine[i].x) + nx * wob
            let cy = Double(spine[i].y) + ny * wob
            sideA.append(CGPoint(x: cx + nx * hw, y: cy + ny * hw))
            sideB.append(CGPoint(x: cx - nx * hw, y: cy - ny * hw))
        }

        if strand.closed {
            let outer = abs(signedArea(sideA)) >= abs(signedArea(sideB)) ? sideA : sideB
            let inner = abs(signedArea(sideA)) >= abs(signedArea(sideB)) ? sideB : sideA
            var solid: [[CGPoint]] = [outer]
            var hollow: [[CGPoint]] = []
            if strand.hole { hollow.append(inner) } else { solid.append(inner) }
            if f.inlineRatio > 0 && strand.hole {
                let mid = zip(outer, inner).map { a, b in
                    CGPoint(x: a.x * 0.5 + b.x * 0.5, y: a.y * 0.5 + b.y * 0.5)
                }
                let grow = zip(outer, mid).map { a, b in
                    CGPoint(x: b.x + (a.x - b.x) * CGFloat(f.inlineRatio),
                            y: b.y + (a.y - b.y) * CGFloat(f.inlineRatio))
                }
                let shrink = zip(inner, mid).map { a, b in
                    CGPoint(x: b.x + (a.x - b.x) * CGFloat(f.inlineRatio),
                            y: b.y + (a.y - b.y) * CGFloat(f.inlineRatio))
                }
                hollow.append(grow)
                hollow.append(shrink)
            }
            return (solid, hollow)
        }

        var solid: [[CGPoint]] = [sideA + sideB.reversed()]
        if f.serif > 0 {
            if let s = serifAt(spine, first: true, kind: strand.a, f: f) { solid.append(s) }
            if let s = serifAt(spine, first: false, kind: strand.b, f: f) { solid.append(s) }
        }
        if f.ball > 0 {
            if strand.a == 5 { solid.append(ballAt(spine[0], f)) }
            if strand.b == 5 { solid.append(ballAt(spine[count - 1], f)) }
        }
        return (solid, [])
    }

    private static func ballAt(_ p: CGPoint, _ f: TypeFace) -> [CGPoint] {
        let r = f.stem * f.ball
        var out: [CGPoint] = []
        for i in 0..<16 {
            let a = Double(i) / 16 * 2 * Double.pi
            out.append(CGPoint(x: p.x + CGFloat(cos(a) * r), y: p.y + CGFloat(sin(a) * r)))
        }
        return out
    }

    private static func serifAt(_ spine: [CGPoint], first: Bool, kind: Int, f: TypeFace) -> [CGPoint]? {
        guard kind == 1 || kind == 2 || kind == 3 || kind == 4 else { return nil }
        let p = first ? spine[0] : spine[spine.count - 1]
        let q = first ? spine[min(1, spine.count - 1)] : spine[max(0, spine.count - 2)]
        var ix = Double(q.x - p.x), iy = Double(q.y - p.y)
        let len = (ix * ix + iy * iy).squareRoot()
        if len > 0 { ix /= len; iy /= len } else { ix = 0; iy = 1 }
        var ux = 1.0, uy = 0.0
        if kind == 2 { ux = 0; uy = 1 }
        let base = kind == 2 ? f.serifLen * 0.44 : f.serifLen
        var left = base, right = base
        if kind == 3 { right = base * 0.16 }
        if kind == 4 { left = base * 0.16 }
        let th = f.serifThick
        let sx = f.slant * (kind == 2 ? 0 : 1) * 0
        _ = sx
        func at(_ u: Double, _ v: Double) -> CGPoint {
            CGPoint(x: p.x + CGFloat(ux * u + ix * v), y: p.y + CGFloat(uy * u + iy * v))
        }
        switch f.serif {
        case 1:
            return [at(-left, 0), at(right, 0), at(right, th), at(-left, th)]
        case 2:
            return [at(-left, 0), at(right, 0), at(right, th * 0.9), at(-left, th * 0.9)]
        case 3:
            let core = f.stem * 0.42
            return [at(-left, 0), at(right, 0), at(right * 0.62, th * 0.5),
                    at(core, th * 1.5), at(core * 0.8, th * 2.4),
                    at(-core * 0.8, th * 2.4), at(-core, th * 1.5), at(-left * 0.62, th * 0.5)]
        case 4:
            return [at(-left, th * 0.9), at(0, 0), at(right, th * 0.9), at(0, th * 1.9)]
        case 5:
            return [at(-left, th * 1.15), at(-left * 0.62, 0), at(-left * 0.24, th * 0.62),
                    at(0, th * 0.14), at(left * 0.24, th * 0.62), at(left * 0.62, 0),
                    at(left, th * 1.15), at(left * 0.7, th * 1.7), at(0, th * 1.25),
                    at(-left * 0.7, th * 1.7)]
        default:
            return nil
        }
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
