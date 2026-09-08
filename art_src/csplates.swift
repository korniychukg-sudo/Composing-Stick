import Foundation
import CoreGraphics

func paperTone(_ i: Int) -> Ink {
    switch i {
    case 1: return Ink(r: 0.953, g: 0.945, b: 0.929)
    case 2: return Ink(r: 0.949, g: 0.937, b: 0.910)
    case 3: return Shop.newsprint
    case 4: return Shop.blotter
    case 5: return Ink(r: 0.396, g: 0.435, b: 0.463)
    case 6: return Ink(r: 0.941, g: 0.925, b: 0.882)
    case 7: return Ink(r: 0.741, g: 0.643, b: 0.502)
    case 8: return Ink(r: 0.898, g: 0.898, b: 0.867)
    default: return Shop.paper
    }
}

func inkTone(_ i: Int) -> Ink {
    switch i {
    case 1: return Ink(r: 0.075, g: 0.071, b: 0.071)
    case 2: return Shop.vermilion
    case 3: return Shop.crimson
    case 4: return Shop.prussian
    case 5: return Shop.bottleGreen
    case 6: return Shop.ochre
    case 7: return Ink(r: 0.412, g: 0.396, b: 0.384)
    case 8: return Shop.opaqueWhite
    case 9: return Shop.mauve
    default: return Shop.black
    }
}

func inkedLine(_ p: Sheet, _ text: String, _ f: TypeFace, size: Double, x: Double, y: Double,
               colour: Ink, paper: Ink, align: Align = .centre, coverage: Double = 1.0,
               seed: UInt64 = 5) {
    setLine(p, text, f, size: size, x: x, y: y, colour: colour, counterTone: paper,
            coverage: coverage, align: align, seed: seed)
    var rng = Quoin(seed &+ 77)
    let width = measureLine(text, f, size: size)
    let x0 = align == .centre ? x - width / 2 : (align == .right ? x - width : x)
    let region = CGRect(x: x0 - size * 0.1, y: y - size * 0.78,
                        width: width + size * 0.2, height: size * 1.06)
    p.clipRect(region) {
        for _ in 0..<Int(width * 0.5) {
            let px = Double(region.minX) + rng.d() * Double(region.width)
            let py = Double(region.minY) + rng.d() * Double(region.height)
            p.disc(px, py, rng.r(0.3, 1.1), colour.al(rng.r(0.05, 0.22)))
        }
    }
}

func typeBlock(_ p: Sheet, _ f: TypeFace, x: Double, y: Double, size: Double,
               colour: Ink, paper: Ink, seed: UInt64) {
    inkedLine(p, "ABCDEFGHIJKLM", f, size: size, x: x, y: y, colour: colour, paper: paper,
              align: .left, coverage: 0.98, seed: seed)
    inkedLine(p, "NOPQRSTUVWXYZ", f, size: size, x: x, y: y + size * 1.26, colour: colour,
              paper: paper, align: .left, coverage: 0.98, seed: seed &+ 3)
    inkedLine(p, "abcdefghijklmn", f, size: size, x: x, y: y + size * 2.52, colour: colour,
              paper: paper, align: .left, coverage: 0.98, seed: seed &+ 5)
    inkedLine(p, "opqrstuvwxyz", f, size: size, x: x, y: y + size * 3.78, colour: colour,
              paper: paper, align: .left, coverage: 0.98, seed: seed &+ 7)
    inkedLine(p, "1234567890 .,;:!?", f, size: size, x: x, y: y + size * 5.04, colour: colour,
              paper: paper, align: .left, coverage: 0.98, seed: seed &+ 11)
}

func facePlate(_ f: TypeFace, dir: String) {
    let p = Sheet(1360, 1780)
    p.light = 2.30
    var rng = Quoin(seedOf("face-" + f.key))
    let stock = Shop.paper
    layStock(p, seed: seedOf("facepaper-" + f.key), tone: stock)
    p.flipTopDown()

    washBand(p, from: 0, to: 300, Shop.sepia, strength: 0.07, seed: rng.next())
    wash(p, [pt(70, 240), pt(1290, 250), pt(1290, 1500), pt(70, 1490)],
         Shop.paperGrey, strength: 0.16, bleed: 9, seed: rng.next())

    borderRule(p, inset: 42, seed: rng.next())
    pen(p, [pt(70, 176), pt(1290, 176)], weight: 3.4, colour: Shop.black, wobble: 0.8,
        taper: false, seed: rng.next())
    pen(p, [pt(70, 186), pt(1290, 186)], weight: 1.4, colour: Shop.blackSoft, wobble: 0.6,
        taper: false, seed: rng.next())

    label(p, "SPECIMEN", at: 680, 110, size: 22, colour: Shop.blackSoft,
          face: "Georgia-Bold", align: .centre, tracking: 9)
    label(p, f.cut, at: 680, 146, size: 15, colour: Shop.blackPale,
          face: "Georgia-Italic", align: .centre)

    let headSize = min(112.0, 1140.0 / max(1.0, measureLine(f.name, f, size: 1.0)))
    inkedLine(p, f.name, f, size: headSize, x: 680, y: 300, colour: Shop.black,
              paper: stock, align: .centre, coverage: 1.0, seed: rng.next())

    pen(p, [pt(340, 336), pt(1020, 336)], weight: 2.0, colour: Shop.blackSoft,
        wobble: 0.7, taper: true, seed: rng.next())

    var y = 420.0
    for (i, size) in f.sizes.enumerated() {
        let s = Double(size) * 1.55
        label(p, "\(size) point", at: 92, y - s * 0.20, size: 13, colour: Shop.blackPale,
              face: "Georgia-Italic", align: .left)
        inkedLine(p, sampleFor(i), f, size: s, x: 92, y: y + s * 0.86,
                  colour: Shop.black, paper: stock, align: .left,
                  coverage: 0.97, seed: rng.next())
        y += s * 1.30 + 46
        penBroken(p, [pt(92, y - 26), pt(1268, y - 26)], weight: 1.0,
                  colour: Shop.blackPale, pieces: 5, gap: 0.05, seed: rng.next())
    }

    let blockTop = max(y + 14, 1010.0)
    typeBlock(p, f, x: 92, y: blockTop, size: 42, colour: Shop.black, paper: stock,
              seed: rng.next())

    let noteTop = blockTop + 42 * 5.04 + 70
    pen(p, [pt(92, noteTop - 30), pt(1268, noteTop - 30)], weight: 1.6,
        colour: Shop.blackSoft, wobble: 0.5, taper: false, seed: rng.next())
    var ny = noteTop
    for line in foldAt(f.story, width: 1150, size: 20, face: "Georgia") {
        label(p, line, at: 92, ny, size: 20, colour: Shop.blackSoft, face: "Georgia", align: .left)
        ny += 30
    }
    ny += 16
    for line in foldAt("On the stone: " + f.colourNote, width: 1150, size: 19, face: "Georgia-Italic") {
        label(p, line, at: 92, ny, size: 19, colour: Shop.sepia, face: "Georgia-Italic", align: .left)
        ny += 28
    }

    grit(p, pathOf([pt(0, 0), pt(p.w, 0), pt(p.w, p.h), pt(0, p.h)]), density: 0.00022,
         sizeMin: 0.4, sizeMax: 1.5, colour: Shop.sepia, seed: rng.next())
    p.write(dir, "fa_" + f.key)
}

func sampleFor(_ i: Int) -> String {
    switch i % 4 {
    case 0: return "Hamburgefonstiv"
    case 1: return "The Composing Stick"
    case 2: return "Quick brown fox 1874"
    default: return "PRINTED BY HAND"
    }
}

func faceDetail(_ f: TypeFace, dir: String) {
    let p = Sheet(1360, 1240)
    p.light = 2.42
    var rng = Quoin(seedOf("detail-" + f.key))
    layStock(p, seed: seedOf("detailpaper-" + f.key), tone: Shop.paperCool, laid: false)
    p.flipTopDown()

    wash(p, [pt(60, 60), pt(1300, 70), pt(1300, 700), pt(60, 690)],
         Shop.paperGrey, strength: 0.20, bleed: 11, seed: rng.next())
    borderRule(p, inset: 34, seed: rng.next())

    label(p, "THE LETTER ITSELF", at: 680, 96, size: 19, colour: Shop.blackSoft,
          face: "Georgia-Bold", align: .centre, tracking: 7)

    let letters = ["R", "a", "g", "e"]
    var x = 150.0
    for (i, ch) in letters.enumerated() {
        let size = 330.0
        inkedLine(p, ch, f, size: size, x: x, y: 560, colour: Shop.black,
                  paper: Shop.paperCool, align: .left, coverage: 1.0,
                  seed: rng.next())
        let adv = measureLine(ch, f, size: size)
        pen(p, [pt(x - 12, 578), pt(x + adv + 12, 578)], weight: 1.2,
            colour: Shop.blackPale, wobble: 0.5, taper: false, seed: rng.next())
        label(p, ["stem and leg", "the bowl", "the tail", "the counter"][i],
              at: x + adv / 2, 606, size: 15, colour: Shop.blackPale,
              face: "Georgia-Italic", align: .centre)
        x += adv + 56
    }

    drawSortSolid(p, x: 210, y: 900, w: 300, h: 250, face: f, ch: "R", seed: rng.next())

    label(p, "A sort of " + f.name, at: 700, 760, size: 22, colour: Shop.black,
          face: "Georgia-Bold", align: .left)
    var ny = 800.0
    for line in foldAt(f.colourNote, width: 560, size: 19, face: "Georgia") {
        label(p, line, at: 700, ny, size: 19, colour: Shop.blackSoft, face: "Georgia", align: .left)
        ny += 28
    }
    ny += 14
    for line in foldAt("Cast in " + f.sizes.map { "\($0)" }.joined(separator: ", ") + " point in this shop.",
                       width: 560, size: 18, face: "Georgia-Italic") {
        label(p, line, at: 700, ny, size: 18, colour: Shop.sepia, face: "Georgia-Italic", align: .left)
        ny += 26
    }

    p.write(dir, "fd_" + f.key)
}

func drawSortSolid(_ p: Sheet, x: Double, y: Double, w: Double, h: Double,
                   face: TypeFace, ch: String, seed: UInt64) {
    var rng = Quoin(seed)
    let skew = w * 0.30
    let topLeft = pt(x, y - h)
    let topRight = pt(x + w, y - h)
    let backLeft = pt(x + skew, y - h - w * 0.26)
    let backRight = pt(x + w + skew, y - h - w * 0.26)

    p.poly([pt(x, y), pt(x + w, y), topRight, topLeft], Shop.lead)
    formTone(p, [pt(x, y), pt(x + w, y), topRight, topLeft], inset: w * 0.30, depth: 3,
             spacing: 6.5, colour: Shop.leadDark, seed: rng.next())
    p.poly([topLeft, topRight, backRight, backLeft], Shop.leadLight)
    crossHatch(p, pathOf([topLeft, topRight, backRight, backLeft]), depth: 2, spacing: 8,
               colour: Shop.lead, seed: rng.next())
    p.poly([pt(x + w, y), topRight, backRight, pt(x + w + skew, y - w * 0.26)], Shop.leadDark)

    let nickY = y - h * 0.30
    p.poly([pt(x + w * 0.16, nickY), pt(x + w * 0.84, nickY),
            pt(x + w * 0.84, nickY + h * 0.075), pt(x + w * 0.16, nickY + h * 0.075)],
           Shop.leadDark.dk(0.32))
    pen(p, [pt(x + w * 0.16, nickY + h * 0.078), pt(x + w * 0.84, nickY + h * 0.078)],
        weight: 2.2, colour: Shop.leadLight.lt(0.30), wobble: 0.4, taper: false, seed: rng.next())

    let faceInset = w * 0.16
    let faceQuad = [pt(topLeft.x + faceInset, topLeft.y - 4),
                    pt(topRight.x - faceInset, topRight.y - 4),
                    pt(backRight.x - faceInset, backRight.y + 6),
                    pt(backLeft.x + faceInset, backLeft.y + 6)]
    p.poly(faceQuad, Shop.antimony.lt(0.10))
    let glyphSize = w * 0.52
    setLine(p, ch, face, size: glyphSize,
            x: Double(topLeft.x) + w * 0.30 + glyphSize * 0.30,
            y: Double(topLeft.y) - w * 0.08,
            colour: Shop.leadDark.dk(0.44), counterTone: Shop.antimony.lt(0.16),
            coverage: 1.0, align: .centre, seed: rng.next())

    grainRun(p, pathOf([pt(x, y), pt(x + w, y), topRight, topLeft]), count: 220,
             length: 26, weight: 1.4, spread: 0.12, angle: 1.57,
             colour: Shop.leadLight.al(0.30), seed: rng.next())
    penEdge(p, [pt(x, y), pt(x + w, y), topRight, topLeft], weight: 2.4,
            colour: Shop.ironBlack, seed: rng.next())

    let base = y + 14
    p.poly(lumpy(cx: x + w * 0.56, cy: base + 10, rx: w * 0.62, ry: 16, rough: 0.16,
                 steps: 22, seed: rng.next()), Shop.blackSoft.al(0.30))

    label(p, "nick", at: x - 26, nickY + 6, size: 15, colour: Shop.blackPale,
          face: "Georgia-Italic", align: .right)
    label(p, "face", at: x + w + skew + 26, Double(backLeft.y) + 20, size: 15,
          colour: Shop.blackPale, face: "Georgia-Italic", align: .left)
    label(p, "shoulder", at: x + w + skew + 26, Double(backLeft.y) + 48, size: 15,
          colour: Shop.blackPale, face: "Georgia-Italic", align: .left)
    label(p, "body", at: x - 26, y - h * 0.72, size: 15, colour: Shop.blackPale,
          face: "Georgia-Italic", align: .right)
}

func leafBlade(_ cx: Double, _ cy: Double, _ len: Double, _ wide: Double,
               _ ang: Double, _ curl: Double) -> [CGPoint] {
    var side1: [CGPoint] = []
    var side2: [CGPoint] = []
    for i in 0...18 {
        let t = Double(i) / 18
        let bend = curl * sin(t * .pi) * len * 0.30
        let px = cx + cos(ang) * len * t - sin(ang) * bend
        let py = cy + sin(ang) * len * t + cos(ang) * bend
        let hw = wide * pow(sin(.pi * t), 0.62)
        side1.append(pt(px - sin(ang) * hw, py + cos(ang) * hw))
        side2.append(pt(px + sin(ang) * hw, py - cos(ang) * hw))
    }
    return side1 + side2.reversed()
}

func petalRing(_ cx: Double, _ cy: Double, _ count: Int, _ len: Double, _ wide: Double,
               _ phase: Double, _ curl: Double) -> [[CGPoint]] {
    var out: [[CGPoint]] = []
    for k in 0..<count {
        let a = phase + Double(k) / Double(count) * 2 * .pi
        out.append(leafBlade(cx, cy, len, wide, a, curl))
    }
    return out
}

func ornamentPlate(_ o: Flower, dir: String) {
    let p = Sheet(640, 640)
    p.light = 2.36
    var rng = Quoin(seedOf("orn-" + o.key))
    let stock = o.kind == 3 ? Shop.paperCool : Shop.paper
    layStock(p, seed: seedOf("ornpaper-" + o.key), tone: stock, laid: false)
    p.flipTopDown()

    wash(p, [pt(46, 46), pt(594, 50), pt(594, 594), pt(46, 590)],
         Shop.paperGrey, strength: 0.22, bleed: 8, seed: rng.next())
    borderRule(p, inset: 26, seed: rng.next())

    let cx = 320.0, cy = 300.0
    let ink = Shop.black
    drawOrnament(p, o.key, cx: cx, cy: cy, scale: 1.0, ink: ink, paper: stock, seed: rng.next())

    pen(p, [pt(90, 540), pt(550, 540)], weight: 1.2, colour: Shop.blackPale,
        wobble: 0.5, taper: true, seed: rng.next())
    label(p, o.name, at: 320, 574, size: 22, colour: Shop.black, face: "Georgia-Bold", align: .centre)
    label(p, o.family, at: 320, 600, size: 14, colour: Shop.blackPale,
          face: "Georgia-Italic", align: .centre)
    p.write(dir, "or_" + o.key)
}

func drawOrnament(_ p: Sheet, _ key: String, cx: Double, cy: Double, scale: Double,
                  ink: Ink, paper: Ink, seed: UInt64) {
    var rng = Quoin(seed)
    let s = scale
    func fill(_ pts: [CGPoint], _ tone: Ink) { p.poly(pts, tone) }

    switch key {
    case "acorn":
        let bodyPts = lumpy(cx: cx, cy: cy + 30 * s, rx: 74 * s, ry: 96 * s, rough: 0.03, steps: 30, seed: rng.next())
        fill(bodyPts, ink)
        formTone(p, bodyPts, inset: 34 * s, depth: 3, spacing: 5.4, colour: paper.al(0.7), seed: rng.next())
        let cup = [pt(cx - 82 * s, cy - 28 * s), pt(cx + 82 * s, cy - 28 * s),
                   pt(cx + 66 * s, cy - 96 * s), pt(cx - 66 * s, cy - 96 * s)]
        fill(cup, ink)
        for k in 0..<7 {
            let x = cx - 74 * s + Double(k) * 24.6 * s
            pen(p, [pt(x, cy - 96 * s), pt(x, cy - 28 * s)], weight: 3.4 * s,
                colour: paper.al(0.72), wobble: 0.6, taper: false, seed: rng.next())
        }
        pen(p, [pt(cx, cy - 96 * s), pt(cx + 8 * s, cy - 132 * s)], weight: 10 * s,
            colour: ink, wobble: 0.6, taper: true, seed: rng.next())
        for blade in [leafBlade(cx - 6 * s, cy - 118 * s, 96 * s, 26 * s, 3.5, 0.7),
                      leafBlade(cx + 14 * s, cy - 122 * s, 88 * s, 24 * s, -0.4, -0.7)] {
            fill(blade, ink)
        }
    case "oakleaf":
        var edge: [CGPoint] = []
        for i in 0...40 {
            let t = Double(i) / 40
            let lob = 1.0 + 0.30 * cos(t * 10 * .pi)
            let hw = 86 * s * pow(sin(.pi * t), 0.5) * lob
            edge.append(pt(cx - hw, cy - 150 * s + t * 300 * s))
        }
        for i in stride(from: 40, through: 0, by: -1) {
            let t = Double(i) / 40
            let lob = 1.0 + 0.30 * cos(t * 10 * .pi + 0.4)
            let hw = 86 * s * pow(sin(.pi * t), 0.5) * lob
            edge.append(pt(cx + hw, cy - 150 * s + t * 300 * s))
        }
        fill(edge, ink)
        pen(p, [pt(cx, cy - 150 * s), pt(cx, cy + 158 * s)], weight: 8 * s,
            colour: paper.al(0.78), wobble: 0.5, taper: true, seed: rng.next())
        for k in 0..<8 {
            let t = 0.14 + Double(k) / 8 * 0.74
            let y = cy - 150 * s + t * 300 * s
            let hw = 74 * s * pow(sin(.pi * t), 0.5)
            pen(p, [pt(cx, y), pt(cx - hw, y - 22 * s)], weight: 3.2 * s,
                colour: paper.al(0.70), wobble: 0.4, taper: true, seed: rng.next())
            pen(p, [pt(cx, y), pt(cx + hw, y - 22 * s)], weight: 3.2 * s,
                colour: paper.al(0.70), wobble: 0.4, taper: true, seed: rng.next())
        }
    case "rosette":
        for blade in petalRing(cx, cy, 8, 148 * s, 44 * s, 0.20, 0.34) { fill(blade, ink) }
        for blade in petalRing(cx, cy, 8, 96 * s, 32 * s, 0.20 + .pi / 8, -0.30) { fill(blade, ink) }
        p.disc(cx, cy, 42 * s, ink)
        p.disc(cx, cy, 24 * s, paper)
        p.disc(cx, cy, 11 * s, ink)
    case "fleuron":
        let stemPts = [pt(cx - 4 * s, cy + 158 * s), pt(cx - 16 * s, cy + 60 * s),
                       pt(cx - 4 * s, cy - 40 * s), pt(cx + 6 * s, cy - 120 * s)]
        pen(p, stemPts, weight: 22 * s, colour: ink, wobble: 0.7, taper: true, seed: rng.next())
        fill(leafBlade(cx - 8 * s, cy + 40 * s, 148 * s, 54 * s, 3.4, 0.86), ink)
        fill(leafBlade(cx + 4 * s, cy + 10 * s, 138 * s, 48 * s, -0.3, -0.86), ink)
        fill(leafBlade(cx + 2 * s, cy - 110 * s, 96 * s, 34 * s, 4.9, 0.5), ink)
        p.disc(cx + 6 * s, cy - 128 * s, 20 * s, ink)
    case "vine":
        var spine: [CGPoint] = []
        for i in 0...30 {
            let t = Double(i) / 30
            spine.append(pt(cx - 170 * s + t * 340 * s, cy + sin(t * 2.6 * .pi) * 66 * s))
        }
        pen(p, spine, weight: 13 * s, colour: ink, wobble: 0.8, taper: true, seed: rng.next())
        for k in 0..<6 {
            let t = 0.10 + Double(k) / 6 * 0.80
            let bx = cx - 170 * s + t * 340 * s
            let by = cy + sin(t * 2.6 * .pi) * 66 * s
            fill(leafBlade(bx, by, 78 * s, 26 * s, k % 2 == 0 ? -1.2 : 1.2, 0.7), ink)
            p.disc(bx + 18 * s, by + (k % 2 == 0 ? -40 : 40) * s, 12 * s, ink)
        }
    case "thistle":
        pen(p, [pt(cx, cy + 170 * s), pt(cx - 6 * s, cy + 20 * s)], weight: 16 * s,
            colour: ink, wobble: 0.6, taper: false, seed: rng.next())
        let head = lumpy(cx: cx, cy: cy - 40 * s, rx: 62 * s, ry: 54 * s, rough: 0.05, steps: 24, seed: rng.next())
        fill(head, ink)
        for k in 0..<15 {
            let a = -.pi / 2 + Double(k - 7) * 0.15
            pen(p, [pt(cx + cos(a) * 30 * s, cy - 70 * s), pt(cx + cos(a) * 92 * s, cy - 176 * s)],
                weight: 6.5 * s, colour: ink, wobble: 0.7, taper: true, seed: rng.next())
        }
        fill(leafBlade(cx - 4 * s, cy + 60 * s, 108 * s, 28 * s, 3.5, 0.9), ink)
        fill(leafBlade(cx + 4 * s, cy + 84 * s, 96 * s, 26 * s, -0.4, -0.9), ink)
    case "ivy":
        var edge: [CGPoint] = []
        for i in 0...44 {
            let a = Double(i) / 44 * 2 * .pi - .pi / 2
            let lobe = 1.0 + 0.34 * cos(a * 3 + .pi)
            edge.append(pt(cx + cos(a) * 128 * s * lobe, cy + sin(a) * 140 * s * lobe))
        }
        fill(edge, ink)
        pen(p, [pt(cx, cy + 140 * s), pt(cx, cy - 130 * s)], weight: 7 * s,
            colour: paper.al(0.76), wobble: 0.4, taper: true, seed: rng.next())
        for a in [2.2, 0.94, 3.9, 5.4] {
            pen(p, [pt(cx, cy + 30 * s), pt(cx + cos(a) * 112 * s, cy + sin(a) * 112 * s)],
                weight: 5 * s, colour: paper.al(0.70), wobble: 0.4, taper: true, seed: rng.next())
        }
    case "tulip":
        pen(p, [pt(cx, cy + 176 * s), pt(cx, cy + 20 * s)], weight: 14 * s,
            colour: ink, wobble: 0.6, taper: false, seed: rng.next())
        let cup = [pt(cx - 78 * s, cy - 20 * s), pt(cx + 78 * s, cy - 20 * s),
                   pt(cx + 62 * s, cy - 120 * s), pt(cx + 20 * s, cy - 60 * s),
                   pt(cx, cy - 148 * s), pt(cx - 20 * s, cy - 60 * s),
                   pt(cx - 62 * s, cy - 120 * s)]
        fill(cup, ink)
        fill(leafBlade(cx - 4 * s, cy + 100 * s, 132 * s, 30 * s, 3.5, 0.8), ink)
        fill(leafBlade(cx + 4 * s, cy + 120 * s, 120 * s, 28 * s, -0.4, -0.8), ink)
    default:
        drawOrnamentTwo(p, key, cx: cx, cy: cy, scale: scale, ink: ink, paper: paper, seed: rng.next())
    }
}

func drawOrnamentTwo(_ p: Sheet, _ key: String, cx: Double, cy: Double, scale: Double,
                     ink: Ink, paper: Ink, seed: UInt64) {
    var rng = Quoin(seed)
    let s = scale
    func fill(_ pts: [CGPoint], _ tone: Ink) { p.poly(pts, tone) }

    switch key {
    case "laurel":
        var spine: [CGPoint] = []
        for i in 0...24 { let t = Double(i) / 24
            spine.append(pt(cx - 150 * s + t * 300 * s, cy + 70 * s - sin(t * .pi) * 130 * s)) }
        pen(p, spine, weight: 12 * s, colour: ink, wobble: 0.6, taper: true, seed: rng.next())
        for k in 0..<11 {
            let t = 0.06 + Double(k) / 11 * 0.88
            let i = Int(t * 24)
            let q = spine[min(24, i)]
            let up = k % 2 == 0
            fill(leafBlade(Double(q.x), Double(q.y), 74 * s, 20 * s,
                           up ? -1.9 : -1.1, up ? 0.6 : -0.6), ink)
        }
    case "wreath":
        for k in 0..<26 {
            let a = Double(k) / 26 * 2 * .pi
            let bx = cx + cos(a) * 132 * s
            let by = cy + sin(a) * 132 * s
            fill(leafBlade(bx, by, 62 * s, 17 * s, a + 1.9, 0.55), ink)
        }
        for k in 0..<26 {
            let a = Double(k) / 26 * 2 * .pi + 0.12
            let bx = cx + cos(a) * 118 * s
            let by = cy + sin(a) * 118 * s
            fill(leafBlade(bx, by, 48 * s, 13 * s, a + 1.3, -0.5), ink)
        }
        pen(p, [pt(cx - 30 * s, cy + 140 * s), pt(cx, cy + 176 * s), pt(cx + 30 * s, cy + 140 * s)],
            weight: 9 * s, colour: ink, wobble: 0.5, taper: true, seed: rng.next())
    case "palmette":
        for k in 0..<9 {
            let a = -.pi / 2 + Double(k - 4) * 0.30
            let len = 168 * s * (1.0 - abs(Double(k - 4)) * 0.10)
            fill(leafBlade(cx, cy + 90 * s, len, 24 * s, a, Double(k - 4) * 0.10), ink)
        }
        pen(p, [pt(cx - 78 * s, cy + 108 * s), pt(cx, cy + 78 * s), pt(cx + 78 * s, cy + 108 * s)],
            weight: 16 * s, colour: ink, wobble: 0.6, taper: true, seed: rng.next())
    case "anthemion":
        for k in 0..<7 {
            let a = -.pi / 2 + Double(k - 3) * 0.34
            fill(leafBlade(cx, cy + 70 * s, 150 * s, 22 * s, a, 0), ink)
        }
        for side in [-1.0, 1.0] {
            var curl: [CGPoint] = []
            for i in 0...20 {
                let t = Double(i) / 20
                let a = t * 3.0
                let r = 74 * s * (1 - t * 0.68)
                curl.append(pt(cx + side * (60 * s + cos(a) * r), cy + 96 * s - sin(a) * r * 0.7))
            }
            pen(p, curl, weight: 15 * s, colour: ink, wobble: 0.6, taper: true, seed: rng.next())
        }
    case "arabesque":
        for side in [-1.0, 1.0] {
            var band: [CGPoint] = []
            for i in 0...36 {
                let t = Double(i) / 36
                band.append(pt(cx + side * (-160 * s + t * 320 * s),
                               cy + sin(t * 2.2 * .pi) * 84 * s * side))
            }
            pen(p, band, weight: 14 * s, colour: ink, wobble: 0.7, taper: true, seed: rng.next())
        }
        for k in 0..<4 {
            let a = Double(k) / 4 * 2 * .pi + 0.4
            fill(leafBlade(cx + cos(a) * 96 * s, cy + sin(a) * 74 * s, 70 * s, 20 * s, a, 0.8), ink)
        }
        p.disc(cx, cy, 22 * s, ink)
    case "shell":
        var edge: [CGPoint] = []
        for i in 0...30 {
            let a = .pi + Double(i) / 30 * .pi
            let flute = 1.0 + 0.06 * cos(Double(i) * 1.9)
            edge.append(pt(cx + cos(a) * 150 * s * flute, cy + 60 * s + sin(a) * 150 * s * flute))
        }
        edge.append(pt(cx + 40 * s, cy + 84 * s))
        edge.append(pt(cx - 40 * s, cy + 84 * s))
        fill(edge, ink)
        for k in 0..<9 {
            let a = .pi + Double(k + 1) / 10 * .pi
            pen(p, [pt(cx, cy + 76 * s), pt(cx + cos(a) * 142 * s, cy + 60 * s + sin(a) * 142 * s)],
                weight: 5.4 * s, colour: paper.al(0.74), wobble: 0.4, taper: true, seed: rng.next())
        }
    case "scroll":
        for side in [-1.0, 1.0] {
            var curl: [CGPoint] = []
            for i in 0...34 {
                let t = Double(i) / 34
                let a = t * 4.4
                let r = 130 * s * (1 - t * 0.80)
                curl.append(pt(cx + side * (cos(a) * r + 34 * s), cy - sin(a) * r * side))
            }
            pen(p, curl, weight: 20 * s, colour: ink, wobble: 0.8, taper: true, seed: rng.next())
        }
    case "cartouche":
        var edge: [CGPoint] = []
        for i in 0...44 {
            let a = Double(i) / 44 * 2 * .pi
            let bump = 1.0 + 0.12 * cos(a * 4)
            edge.append(pt(cx + cos(a) * 166 * s * bump, cy + sin(a) * 122 * s * bump))
        }
        fill(edge, ink)
        var inner: [CGPoint] = []
        for i in 0...44 {
            let a = Double(i) / 44 * 2 * .pi
            let bump = 1.0 + 0.10 * cos(a * 4)
            inner.append(pt(cx + cos(a) * 132 * s * bump, cy + sin(a) * 92 * s * bump))
        }
        fill(inner, paper)
        for k in 0..<4 {
            let a = Double(k) / 4 * 2 * .pi + .pi / 4
            fill(leafBlade(cx + cos(a) * 160 * s, cy + sin(a) * 120 * s, 60 * s, 18 * s, a, 0.6), ink)
        }
    default:
        drawOrnamentThree(p, key, cx: cx, cy: cy, scale: scale, ink: ink, paper: paper, seed: rng.next())
    }
}

func drawOrnamentThree(_ p: Sheet, _ key: String, cx: Double, cy: Double, scale: Double,
                       ink: Ink, paper: Ink, seed: UInt64) {
    var rng = Quoin(seed)
    let s = scale
    func fill(_ pts: [CGPoint], _ tone: Ink) { p.poly(pts, tone) }
    func starPts(_ n: Int, _ outer: Double, _ inner: Double, _ phase: Double) -> [CGPoint] {
        var out: [CGPoint] = []
        for i in 0..<(n * 2) {
            let a = phase + Double(i) / Double(n * 2) * 2 * .pi
            let r = i % 2 == 0 ? outer : inner
            out.append(pt(cx + cos(a) * r, cy + sin(a) * r))
        }
        return out
    }

    switch key {
    case "star6":
        fill(starPts(6, 160 * s, 66 * s, -.pi / 2), ink)
        fill(starPts(6, 84 * s, 34 * s, -.pi / 2), paper)
    case "sunburst":
        for k in 0..<24 {
            let a = Double(k) / 24 * 2 * .pi
            let len = k % 2 == 0 ? 176.0 : 132.0
            pen(p, [pt(cx + cos(a) * 60 * s, cy + sin(a) * 60 * s),
                    pt(cx + cos(a) * len * s, cy + sin(a) * len * s)],
                weight: 13 * s, colour: ink, wobble: 0.5, taper: true, seed: rng.next())
        }
        p.disc(cx, cy, 62 * s, ink)
        p.disc(cx, cy, 42 * s, paper)
        p.disc(cx, cy, 20 * s, ink)
    case "lozenge":
        fill([pt(cx, cy - 168 * s), pt(cx + 104 * s, cy), pt(cx, cy + 168 * s), pt(cx - 104 * s, cy)], ink)
        fill([pt(cx, cy - 112 * s), pt(cx + 68 * s, cy), pt(cx, cy + 112 * s), pt(cx - 68 * s, cy)], paper)
        fill([pt(cx, cy - 58 * s), pt(cx + 36 * s, cy), pt(cx, cy + 58 * s), pt(cx - 36 * s, cy)], ink)
    case "quatrefoil":
        for k in 0..<4 {
            let a = Double(k) / 4 * 2 * .pi + .pi / 4
            p.disc(cx + cos(a) * 88 * s, cy + sin(a) * 88 * s, 82 * s, ink)
        }
        for k in 0..<4 {
            let a = Double(k) / 4 * 2 * .pi + .pi / 4
            p.disc(cx + cos(a) * 88 * s, cy + sin(a) * 88 * s, 50 * s, paper)
        }
        p.disc(cx, cy, 44 * s, ink)
    case "trefoil":
        for k in 0..<3 {
            let a = -.pi / 2 + Double(k) / 3 * 2 * .pi
            p.disc(cx + cos(a) * 88 * s, cy + sin(a) * 88 * s, 84 * s, ink)
        }
        for k in 0..<3 {
            let a = -.pi / 2 + Double(k) / 3 * 2 * .pi
            p.disc(cx + cos(a) * 88 * s, cy + sin(a) * 88 * s, 50 * s, paper)
        }
        pen(p, [pt(cx, cy + 60 * s), pt(cx, cy + 178 * s)], weight: 16 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
    case "crown":
        let band = [pt(cx - 150 * s, cy + 96 * s), pt(cx + 150 * s, cy + 96 * s),
                    pt(cx + 150 * s, cy + 36 * s), pt(cx - 150 * s, cy + 36 * s)]
        fill(band, ink)
        fill([pt(cx - 150 * s, cy + 36 * s), pt(cx - 100 * s, cy - 110 * s),
              pt(cx - 50 * s, cy + 4 * s), pt(cx, cy - 150 * s),
              pt(cx + 50 * s, cy + 4 * s), pt(cx + 100 * s, cy - 110 * s),
              pt(cx + 150 * s, cy + 36 * s)], ink)
        for x in [-100.0, 0, 100.0] {
            p.disc(cx + x * s, cy - (x == 0 ? 162 : 122) * s, 18 * s, ink)
        }
        for k in 0..<5 {
            p.disc(cx - 110 * s + Double(k) * 55 * s, cy + 66 * s, 15 * s, paper)
        }
    case "anchor":
        pen(p, [pt(cx, cy - 150 * s), pt(cx, cy + 110 * s)], weight: 24 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
        pen(p, [pt(cx - 96 * s, cy - 92 * s), pt(cx + 96 * s, cy - 92 * s)], weight: 18 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
        var hook: [CGPoint] = []
        for i in 0...24 {
            let a = .pi + Double(i) / 24 * .pi
            hook.append(pt(cx + cos(a) * 128 * s, cy + 84 * s - sin(a) * 92 * s))
        }
        pen(p, hook, weight: 22 * s, colour: ink, wobble: 0.6, taper: false, seed: rng.next())
        fill([pt(cx - 128 * s, cy + 78 * s), pt(cx - 170 * s, cy + 46 * s),
              pt(cx - 104 * s, cy + 40 * s)], ink)
        fill([pt(cx + 128 * s, cy + 78 * s), pt(cx + 170 * s, cy + 46 * s),
              pt(cx + 104 * s, cy + 40 * s)], ink)
        p.ring(cx, cy - 162 * s, 30 * s, 14 * s, ink)
    case "bee":
        let bodyPts = lumpy(cx: cx, cy: cy + 24 * s, rx: 74 * s, ry: 108 * s, rough: 0.02, steps: 28, seed: rng.next())
        fill(bodyPts, ink)
        for k in 0..<4 {
            let y = cy - 24 * s + Double(k) * 40 * s
            pen(p, [pt(cx - 70 * s, y), pt(cx + 70 * s, y)], weight: 11 * s,
                colour: paper.al(0.8), wobble: 0.5, taper: true, seed: rng.next())
        }
        fill(leafBlade(cx - 10 * s, cy - 60 * s, 168 * s, 44 * s, 3.5, 0.7), ink.al(0.55))
        fill(leafBlade(cx + 10 * s, cy - 60 * s, 168 * s, 44 * s, -0.36, -0.7), ink.al(0.55))
        p.disc(cx, cy - 104 * s, 40 * s, ink)
        pen(p, [pt(cx - 14 * s, cy - 134 * s), pt(cx - 46 * s, cy - 176 * s)], weight: 7 * s,
            colour: ink, wobble: 0.4, taper: true, seed: rng.next())
        pen(p, [pt(cx + 14 * s, cy - 134 * s), pt(cx + 46 * s, cy - 176 * s)], weight: 7 * s,
            colour: ink, wobble: 0.4, taper: true, seed: rng.next())
    default:
        drawOrnamentFour(p, key, cx: cx, cy: cy, scale: scale, ink: ink, paper: paper, seed: rng.next())
    }
}

func drawOrnamentFour(_ p: Sheet, _ key: String, cx: Double, cy: Double, scale: Double,
                      ink: Ink, paper: Ink, seed: UInt64) {
    var rng = Quoin(seed)
    let s = scale
    func fill(_ pts: [CGPoint], _ tone: Ink) { p.poly(pts, tone) }

    switch key {
    case "fist":
        let palm = [pt(cx - 40 * s, cy - 74 * s), pt(cx + 58 * s, cy - 68 * s),
                    pt(cx + 74 * s, cy - 40 * s), pt(cx + 70 * s, cy + 62 * s),
                    pt(cx + 30 * s, cy + 94 * s), pt(cx - 52 * s, cy + 88 * s),
                    pt(cx - 96 * s, cy + 40 * s), pt(cx - 92 * s, cy - 32 * s)]
        fill(palm, ink)
        let pointer = [pt(cx + 58 * s, cy - 42 * s), pt(cx + 196 * s, cy - 30 * s),
                       pt(cx + 200 * s, cy - 2 * s), pt(cx + 60 * s, cy + 6 * s)]
        fill(pointer, ink)
        fill([pt(cx + 196 * s, cy - 32 * s), pt(cx + 226 * s, cy - 16 * s),
              pt(cx + 196 * s, cy + 4 * s)], ink)
        for k in 0..<3 {
            let y = cy + 16 * s + Double(k) * 26 * s
            pen(p, [pt(cx - 60 * s, y), pt(cx + 56 * s, y)], weight: 5 * s,
                colour: paper.al(0.76), wobble: 0.4, taper: true, seed: rng.next())
        }
        fill([pt(cx - 92 * s, cy - 30 * s), pt(cx - 150 * s, cy - 4 * s),
              pt(cx - 146 * s, cy + 52 * s), pt(cx - 90 * s, cy + 46 * s)], ink)
        pen(p, [pt(cx - 150 * s, cy - 10 * s), pt(cx - 156 * s, cy + 62 * s)], weight: 12 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
    case "pilcrow":
        pen(p, [pt(cx + 46 * s, cy - 150 * s), pt(cx + 46 * s, cy + 160 * s)], weight: 30 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
        pen(p, [pt(cx + 116 * s, cy - 150 * s), pt(cx + 116 * s, cy + 160 * s)], weight: 22 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
        var bowl: [CGPoint] = []
        for i in 0...22 {
            let a = -.pi / 2 + Double(i) / 22 * .pi
            bowl.append(pt(cx + 46 * s - cos(a) * 96 * s, cy - 60 * s + sin(a) * 90 * s))
        }
        pen(p, bowl, weight: 34 * s, colour: ink, wobble: 0.6, taper: false, seed: rng.next())
    case "dagger", "doubledagger":
        pen(p, [pt(cx, cy - 168 * s), pt(cx, cy + 174 * s)], weight: 26 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
        pen(p, [pt(cx - 88 * s, cy - 92 * s), pt(cx + 88 * s, cy - 92 * s)], weight: 22 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
        if key == "doubledagger" {
            pen(p, [pt(cx - 76 * s, cy + 62 * s), pt(cx + 76 * s, cy + 62 * s)], weight: 22 * s,
                colour: ink, wobble: 0.5, taper: false, seed: rng.next())
        }
        fill([pt(cx - 14 * s, cy + 150 * s), pt(cx + 14 * s, cy + 150 * s), pt(cx, cy + 186 * s)], ink)
    case "asterism":
        for (dx, dy) in [(0.0, -96.0), (-88.0, 66.0), (88.0, 66.0)] {
            for k in 0..<6 {
                let a = Double(k) / 6 * 2 * .pi + .pi / 2
                pen(p, [pt(cx + dx * s, cy + dy * s),
                        pt(cx + dx * s + cos(a) * 56 * s, cy + dy * s + sin(a) * 56 * s)],
                    weight: 12 * s, colour: ink, wobble: 0.4, taper: true, seed: rng.next())
            }
        }
    case "section":
        for side in [-1.0, 1.0] {
            var curve: [CGPoint] = []
            for i in 0...30 {
                let t = Double(i) / 30
                let a = -.pi * 0.30 + t * .pi * 1.72
                curve.append(pt(cx + cos(a) * 62 * s * side, cy + side * 60 * s + sin(a) * 66 * s))
            }
            pen(p, curve, weight: 24 * s, colour: ink, wobble: 0.6, taper: true, seed: rng.next())
        }
    case "torch":
        pen(p, [pt(cx, cy + 178 * s), pt(cx, cy + 20 * s)], weight: 30 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
        fill([pt(cx - 66 * s, cy + 22 * s), pt(cx + 66 * s, cy + 22 * s),
              pt(cx + 50 * s, cy - 26 * s), pt(cx - 50 * s, cy - 26 * s)], ink)
        for k in 0..<5 {
            let a = -.pi / 2 + Double(k - 2) * 0.36
            pen(p, [pt(cx + Double(k - 2) * 12 * s, cy - 30 * s),
                    pt(cx + cos(a) * 116 * s + Double(k - 2) * 24 * s, cy - 30 * s + sin(a) * 150 * s)],
                weight: 20 * s, colour: ink, wobble: 0.9, taper: true, seed: rng.next())
        }
    case "lyre":
        for side in [-1.0, 1.0] {
            var arm: [CGPoint] = []
            for i in 0...24 {
                let t = Double(i) / 24
                let a = .pi * 0.5 - t * .pi * 0.82
                arm.append(pt(cx + side * (44 * s + cos(a) * 96 * s * 0 + t * 96 * s),
                              cy + 110 * s - t * 240 * s + sin(t * .pi) * 26 * s * side))
            }
            pen(p, arm, weight: 20 * s, colour: ink, wobble: 0.6, taper: false, seed: rng.next())
        }
        pen(p, [pt(cx - 140 * s, cy - 130 * s), pt(cx + 140 * s, cy - 130 * s)], weight: 18 * s,
            colour: ink, wobble: 0.5, taper: false, seed: rng.next())
        for k in 0..<5 {
            let x = cx - 76 * s + Double(k) * 38 * s
            pen(p, [pt(x, cy - 122 * s), pt(x, cy + 96 * s)], weight: 6 * s,
                colour: ink, wobble: 0.4, taper: true, seed: rng.next())
        }
        var base: [CGPoint] = []
        for i in 0...20 {
            let a = .pi + Double(i) / 20 * .pi
            base.append(pt(cx + cos(a) * 108 * s, cy + 108 * s - sin(a) * 62 * s))
        }
        pen(p, base, weight: 24 * s, colour: ink, wobble: 0.6, taper: false, seed: rng.next())
    default:
        drawRuleOrnament(p, key, cx: cx, cy: cy, scale: scale, ink: ink, paper: paper, seed: rng.next())
    }
}

func drawRuleOrnament(_ p: Sheet, _ key: String, cx: Double, cy: Double, scale: Double,
                      ink: Ink, paper: Ink, seed: UInt64) {
    var rng = Quoin(seed)
    let s = scale
    let x0 = cx - 210 * s, x1 = cx + 210 * s
    func band(_ y: Double, _ weight: Double) {
        pen(p, [pt(x0, y), pt(x1, y)], weight: weight, colour: ink, wobble: 0.5,
            taper: false, seed: rng.next())
    }
    switch key {
    case "ruleplain":
        band(cy - 40 * s, 5 * s); band(cy + 10 * s, 12 * s); band(cy + 70 * s, 22 * s)
    case "ruledouble":
        band(cy - 44 * s, 9 * s); band(cy - 16 * s, 5 * s)
        band(cy + 40 * s, 14 * s); band(cy + 76 * s, 6 * s)
    case "rulewave":
        for k in 0..<3 {
            var wave: [CGPoint] = []
            for i in 0...60 {
                let t = Double(i) / 60
                wave.append(pt(x0 + t * (x1 - x0),
                               cy - 60 * s + Double(k) * 66 * s + sin(t * 6 * .pi) * (10 + Double(k) * 5) * s))
            }
            pen(p, wave, weight: (7 + Double(k) * 4) * s, colour: ink, wobble: 0.5,
                taper: false, seed: rng.next())
        }
    case "ruledotted":
        for k in 0..<3 {
            let y = cy - 50 * s + Double(k) * 60 * s
            let step = (6 + Double(k) * 6) * s
            var x = x0
            while x < x1 { p.disc(x, y, (3 + Double(k) * 1.6) * s, ink); x += step * 2.6 }
        }
    case "ruleswelled":
        for k in 0..<3 {
            let y = cy - 56 * s + Double(k) * 62 * s
            pen(p, [pt(x0, y), pt(cx, y), pt(x1, y)], weight: (16 + Double(k) * 10) * s,
                colour: ink, wobble: 0.5, taper: true, seed: rng.next())
        }
    case "borderchain":
        for k in 0..<12 {
            let x = x0 + Double(k) * (x1 - x0) / 11
            p.ring(x, cy - 30 * s, 26 * s, 10 * s, ink)
            p.ring(x + (x1 - x0) / 22, cy + 40 * s, 26 * s, 10 * s, ink)
        }
        band(cy + 108 * s, 8 * s)
    case "bordergreek":
        var run: [CGPoint] = []
        var x = x0
        var up = true
        while x < x1 {
            run.append(pt(x, up ? cy - 60 * s : cy + 20 * s))
            run.append(pt(x + 44 * s, up ? cy - 60 * s : cy + 20 * s))
            run.append(pt(x + 44 * s, up ? cy + 20 * s : cy - 60 * s))
            x += 44 * s
            up.toggle()
        }
        pen(p, run, weight: 13 * s, colour: ink, wobble: 0.4, taper: false, seed: rng.next())
        band(cy + 88 * s, 10 * s)
    case "borderleaf":
        for k in 0..<9 {
            let x = x0 + Double(k) * (x1 - x0) / 8
            p.poly(leafBlade(x, cy + 10 * s, 76 * s, 22 * s, -1.57 + (k % 2 == 0 ? 0.3 : -0.3), 0.7), ink)
            p.disc(x + 22 * s, cy + 46 * s, 9 * s, ink)
        }
        band(cy + 96 * s, 7 * s)
    default:
        for k in 0..<6 {
            let a = Double(k) / 6 * 2 * .pi
            p.poly(leafBlade(cx, cy, 150 * s, 40 * s, a, 0.4), ink)
        }
        p.disc(cx, cy, 34 * s, ink)
    }
}

func paperPlate(_ stock: Stock, dir: String) {
    let p = Sheet(780, 780)
    p.light = 2.28
    var rng = Quoin(seedOf("paper-" + stock.key))
    let tone = paperTone(stock.tone)
    layStock(p, seed: seedOf("papergnd-" + stock.key), tone: Shop.stoneTop.dk(0.30), laid: false)
    p.flipTopDown()

    washBand(p, from: 0, to: 780, Shop.stoneDark, strength: 0.30, seed: rng.next())
    grit(p, pathOf([pt(0, 0), pt(780, 0), pt(780, 780), pt(0, 780)]), density: 0.0016,
         sizeMin: 0.5, sizeMax: 2.2, colour: Shop.stoneDark, seed: rng.next())

    var edge: [CGPoint] = []
    let ragged = stock.key == "deckle" || stock.key == "gampi" || stock.key == "rag"
    let jag = ragged ? 16.0 : 2.5
    for i in 0...26 { edge.append(pt(90 + Double(i) * 23, 118 + rng.signed() * jag)) }
    for i in 0...22 { edge.append(pt(688 + rng.signed() * jag, 118 + Double(i) * 24)) }
    for i in stride(from: 26, through: 0, by: -1) { edge.append(pt(90 + Double(i) * 23, 646 + rng.signed() * jag)) }
    for i in stride(from: 22, through: 0, by: -1) { edge.append(pt(90 + rng.signed() * jag, 118 + Double(i) * 24)) }

    p.poly(edge.map { pt(Double($0.x) + 16, Double($0.y) + 20) }, Shop.black.al(0.42))
    p.poly(edge, tone)
    let sheetPath = pathOf(edge)

    p.clip(sheetPath) {
        if stock.key == "laid" {
            var y = 120.0
            while y < 648 { p.rect(88, y, 604, 1.2, tone.dk(0.10).al(0.5)); y += 7.4 }
            var x = 108.0
            while x < 690 { p.rect(x, 118, 2.2, 530, tone.dk(0.14).al(0.42)); x += 78 }
        }
        if stock.absorbency > 0.7 {
            for _ in 0..<380 {
                let x = rng.r(90, 688), y = rng.r(118, 646)
                p.oval(x, y, rng.r(3, 12), rng.r(2, 7), tone.dk(rng.r(0.03, 0.10)).al(0.5))
            }
        }
        if stock.smoothness < 0.5 {
            grainRun(p, sheetPath, count: 900, length: 22, weight: 1.2, spread: 3.14,
                     colour: tone.dk(0.16).al(0.5), seed: rng.next())
        }
        if stock.smoothness > 0.86 {
            washBand(p, from: 140, to: 300, tone.lt(0.5), strength: 0.24, seed: rng.next())
        }
        for _ in 0..<Int(stock.thickness * 500 + 120) {
            let x = rng.r(90, 688), y = rng.r(118, 646)
            let a = rng.r(0, 6.28)
            pen(p, [pt(x, y), pt(x + cos(a) * rng.r(6, 26), y + sin(a) * rng.r(6, 26))],
                weight: rng.r(0.5, 1.5), colour: tone.dk(rng.r(0.05, 0.22)).al(rng.r(0.2, 0.6)),
                wobble: 0.3, taper: true, seed: rng.next())
        }
    }

    let sample = Foundry.face("caslon")
    setLine(p, "Aa", sample, size: 150, x: 250, y: 470, colour: Shop.black.al(0.92),
            counterTone: tone, coverage: min(1.0, 0.62 + (1 - stock.absorbency) * 0.5),
            align: .centre, seed: rng.next())
    if stock.absorbency > 0.75 {
        grit(p, pathOf([pt(160, 320), pt(360, 320), pt(360, 500), pt(160, 500)]),
             density: 0.0022, sizeMin: 0.6, sizeMax: 2.6, colour: Shop.black.al(0.5), seed: rng.next())
    }
    setLine(p, "Bb", sample, size: 150, x: 500, y: 470, colour: Shop.vermilion.al(0.90),
            counterTone: tone, coverage: min(1.0, 0.60 + (1 - stock.absorbency) * 0.5),
            align: .centre, seed: rng.next())

    penEdge(p, edge, weight: 2.2, colour: Shop.blackSoft.al(0.7), seed: rng.next())

    label(p, stock.name, at: 390, 716, size: 26, colour: Shop.paper,
          face: "Georgia-Bold", align: .centre)
    label(p, String(format: "%.0f thousandths", stock.thickness * 12 + 2), at: 390, 748,
          size: 15, colour: Shop.paperGrey.dk(0.2), face: "Georgia-Italic", align: .centre)
    p.write(dir, "pa_" + stock.key)
}

func inkPlate(_ colour: Colour, dir: String) {
    let p = Sheet(720, 720)
    p.light = 2.44
    var rng = Quoin(seedOf("ink-" + colour.key))
    layStock(p, seed: seedOf("inkgnd-" + colour.key), tone: Shop.stoneTop, laid: false)
    p.flipTopDown()

    washBand(p, from: 0, to: 720, Shop.stoneDark, strength: 0.22, seed: rng.next())
    grit(p, pathOf([pt(0, 0), pt(720, 0), pt(720, 720), pt(0, 720)]), density: 0.0022,
         sizeMin: 0.4, sizeMax: 1.8, colour: Shop.stoneDark, seed: rng.next())

    let tone = inkTone(colour.tone)
    var slab: [CGPoint] = []
    for i in 0...20 { slab.append(pt(70 + Double(i) * 29, 96 + rng.signed() * 3)) }
    for i in 0...16 { slab.append(pt(650 + rng.signed() * 3, 96 + Double(i) * 27)) }
    for i in stride(from: 20, through: 0, by: -1) { slab.append(pt(70 + Double(i) * 29, 528 + rng.signed() * 3)) }
    for i in stride(from: 16, through: 0, by: -1) { slab.append(pt(70 + rng.signed() * 3, 96 + Double(i) * 27)) }
    p.poly(slab, Shop.stoneTop.lt(0.10))
    crossHatch(p, pathOf(slab), depth: 2, spacing: 11, colour: Shop.stoneDark.al(0.35), seed: rng.next())

    for k in 0..<7 {
        let y = 150.0 + Double(k) * 54
        var streak: [CGPoint] = []
        for i in 0...30 {
            let t = Double(i) / 30
            streak.append(pt(110 + t * 500, y + sin(t * 3.4 + Double(k)) * 7))
        }
        let dense = 1.0 - Double(k) * 0.10
        pen(p, streak, weight: 34 * dense, colour: tone.al(min(1.0, colour.opacity * dense + 0.08)),
            wobble: 1.6, taper: true, seed: rng.next())
    }
    let blobPts = lumpy(cx: 200, cy: 200, rx: 92, ry: 74, rough: 0.14, steps: 26, seed: rng.next())
    p.poly(blobPts, tone.al(min(1.0, colour.opacity + 0.06)))
    formTone(p, blobPts, inset: 34, depth: 2, spacing: 5.6, colour: tone.dk(0.34).al(0.6), seed: rng.next())
    for run in 0..<3 {
        pen(p, [pt(200 + Double(run) * 18, 262), pt(214 + Double(run) * 22, 330)],
            weight: 9, colour: tone.al(0.7), wobble: 1.2, taper: true, seed: rng.next())
    }

    let knife = [pt(430, 250), pt(600, 176), pt(618, 200), pt(448, 276)]
    p.poly(knife, Shop.steel)
    formTone(p, knife, inset: 16, depth: 2, spacing: 4.2, colour: Shop.leadDark, seed: rng.next())
    penEdge(p, knife, weight: 2.0, colour: Shop.ironBlack, seed: rng.next())
    p.poly([pt(596, 172), pt(676, 138), pt(690, 166), pt(610, 200)], Shop.oak)
    grainRun(p, pathOf([pt(596, 172), pt(676, 138), pt(690, 166), pt(610, 200)]),
             count: 60, length: 26, weight: 1.3, spread: 0.16, angle: -0.4,
             colour: Shop.oakDark.al(0.5), seed: rng.next())

    if colour.overprints {
        let over = lumpy(cx: 470, cy: 420, rx: 96, ry: 66, rough: 0.10, steps: 24, seed: rng.next())
        p.poly(over, Shop.prussian.al(colour.key == "prussian" ? 0.30 : 0.42))
        p.poly(over.map { pt(Double($0.x) + 44, Double($0.y) + 20) }, tone.al(0.42))
        label(p, "overprints", at: 500, 470, size: 15, colour: Shop.paper,
              face: "Georgia-Italic", align: .centre)
    }

    label(p, colour.name, at: 360, 604, size: 27, colour: Shop.paper,
          face: "Georgia-Bold", align: .centre)
    label(p, String(format: "tack %.0f  opacity %.0f", colour.tack * 100, colour.opacity * 100),
          at: 360, 640, size: 15, colour: Shop.paperGrey.dk(0.16),
          face: "Georgia-Italic", align: .centre)
    p.write(dir, "in_" + colour.key)
}
