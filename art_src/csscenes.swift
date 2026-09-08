import Foundation
import CoreGraphics

struct ShopHour {
    let key: String
    let hour: Int
    let sky: Ink
    let wall: Ink
    let floor: Ink
    let beam: Double
    let lamp: Double
    let gas: Bool
    let caption: String
}

let shopHours: [ShopHour] = [
    ShopHour(key: "sh_h0", hour: 3, sky: Ink(r: 0.098, g: 0.114, b: 0.176),
             wall: Ink(r: 0.161, g: 0.153, b: 0.153), floor: Ink(r: 0.129, g: 0.114, b: 0.106),
             beam: 0.05, lamp: 0.0, gas: false,
             caption: "Three in the morning. The forme is locked and nothing moves."),
    ShopHour(key: "sh_h1", hour: 6, sky: Ink(r: 0.694, g: 0.529, b: 0.443),
             wall: Ink(r: 0.400, g: 0.365, b: 0.341), floor: Ink(r: 0.243, g: 0.208, b: 0.180),
             beam: 0.34, lamp: 0.18, gas: true,
             caption: "Six. The devil has the stove going and the gas is still on."),
    ShopHour(key: "sh_h2", hour: 9, sky: Ink(r: 0.792, g: 0.827, b: 0.847),
             wall: Ink(r: 0.647, g: 0.612, b: 0.561), floor: Ink(r: 0.373, g: 0.310, b: 0.251),
             beam: 0.82, lamp: 0.0, gas: false,
             caption: "Nine. North light across the case, and the best hour for setting small."),
    ShopHour(key: "sh_h3", hour: 12, sky: Ink(r: 0.859, g: 0.882, b: 0.890),
             wall: Ink(r: 0.706, g: 0.678, b: 0.627), floor: Ink(r: 0.416, g: 0.349, b: 0.286),
             beam: 1.00, lamp: 0.0, gas: false,
             caption: "Noon. The beam has crossed to the stone and the shop is at full work."),
    ShopHour(key: "sh_h4", hour: 15, sky: Ink(r: 0.847, g: 0.812, b: 0.741),
             wall: Ink(r: 0.667, g: 0.612, b: 0.529), floor: Ink(r: 0.396, g: 0.322, b: 0.251),
             beam: 0.74, lamp: 0.0, gas: false,
             caption: "Three. The light is going yellow and the long jobs go on the press."),
    ShopHour(key: "sh_h5", hour: 18, sky: Ink(r: 0.616, g: 0.416, b: 0.353),
             wall: Ink(r: 0.404, g: 0.345, b: 0.310), floor: Ink(r: 0.259, g: 0.216, b: 0.184),
             beam: 0.28, lamp: 0.52, gas: true,
             caption: "Six in the evening. The gas is lit and the window has stopped being useful."),
    ShopHour(key: "sh_h6", hour: 21, sky: Ink(r: 0.176, g: 0.192, b: 0.259),
             wall: Ink(r: 0.212, g: 0.196, b: 0.192), floor: Ink(r: 0.149, g: 0.129, b: 0.118),
             beam: 0.06, lamp: 0.86, gas: true,
             caption: "Nine at night. One lamp over the stone and the rest of the shop in the dark.")
]

func shopPlate(_ h: ShopHour, dir: String) {
    let p = Sheet(1500, 1020)
    p.light = 3.70
    var rng = Quoin(seedOf("shop-" + h.key))
    layStock(p, seed: seedOf("shoppaper-" + h.key), tone: Shop.paper, laid: false)
    p.flipTopDown()

    washBand(p, from: 0, to: 700, h.wall, strength: 0.72, seed: rng.next())
    washBand(p, from: 660, to: 1020, h.floor, strength: 0.78, seed: rng.next())

    let winX0 = 880.0, winX1 = 1290.0, winY0 = 80.0, winY1 = 470.0
    p.poly([pt(winX0, winY0), pt(winX1, winY0), pt(winX1, winY1), pt(winX0, winY1)], h.sky)
    wash(p, [pt(winX0, winY0), pt(winX1, winY0), pt(winX1, winY1), pt(winX0, winY1)],
         h.sky.lt(0.14), strength: 0.5, bleed: 6, seed: rng.next())
    for k in 1..<4 {
        let x = winX0 + Double(k) * (winX1 - winX0) / 4
        pen(p, [pt(x, winY0), pt(x, winY1)], weight: 8, colour: h.wall.dk(0.44),
            wobble: 0.5, taper: false, seed: rng.next())
    }
    pen(p, [pt(winX0, (winY0 + winY1) / 2), pt(winX1, (winY0 + winY1) / 2)], weight: 9,
        colour: h.wall.dk(0.44), wobble: 0.5, taper: false, seed: rng.next())
    penEdge(p, [pt(winX0 - 14, winY0 - 14), pt(winX1 + 14, winY0 - 14),
                pt(winX1 + 14, winY1 + 14), pt(winX0 - 14, winY1 + 14)],
            weight: 8, colour: h.wall.dk(0.56), seed: rng.next())

    if h.beam > 0.10 {
        let spread = 1.0 - h.beam * 0.35
        let beamPoly = [pt(winX0, winY1), pt(winX1, winY1),
                        pt(winX1 - 260 * spread, 1020), pt(winX0 - 620 * spread, 1020)]
        p.poly(beamPoly, Ink(r: 1.0, g: 0.949, b: 0.812).al(0.10 + h.beam * 0.22))
        for _ in 0..<Int(h.beam * 700) {
            let t = rng.d()
            let x = winX0 - 620 * spread * t + rng.d() * (winX1 - winX0)
            let y = winY1 + t * (1020 - winY1)
            p.disc(x, y, rng.r(0.6, 2.4), Ink(r: 1, g: 0.976, b: 0.878).al(rng.r(0.06, 0.34)))
        }
    }

    let frameTop = 470.0
    let caseQuad = [pt(120, frameTop + 40), pt(760, frameTop), pt(830, frameTop + 190), pt(70, frameTop + 240)]
    p.poly(caseQuad, Shop.oak)
    crossHatch(p, pathOf(caseQuad), depth: 2, spacing: 9, colour: Shop.oakDark.al(0.42), seed: rng.next())
    grainRun(p, pathOf(caseQuad), count: 260, length: 60, weight: 1.5, spread: 0.10,
             angle: -0.28, colour: Shop.oakDark.al(0.44), seed: rng.next())
    let boxTone = h.wall.dk(0.30)
    for row in 0..<5 {
        for col in 0..<13 {
            let u = Double(col) / 13, v = Double(row) / 5
            let x = 130 + u * 660 + v * -40
            let y = frameTop + 52 + v * 176 + u * -34
            let w = 660.0 / 13 - 6
            let hgt = 176.0 / 5 - 6
            p.poly([pt(x, y), pt(x + w, y - 4), pt(x + w - 3, y + hgt), pt(x - 3, y + hgt + 4)],
                   boxTone.dk(rng.r(0.0, 0.22)))
            if rng.chance(0.55) {
                for _ in 0..<rng.i(3, 9) {
                    let sx = x + rng.r(2, w - 4), sy = y + rng.r(2, hgt - 3)
                    p.rect(sx, sy, rng.r(2.5, 5), rng.r(4, 9), Shop.lead.dk(rng.r(0, 0.3)).al(0.85))
                }
            }
        }
    }
    penEdge(p, caseQuad, weight: 4.4, colour: Shop.oakDark, seed: rng.next())

    let stoneQuad = [pt(60, 760), pt(720, 726), pt(760, 900), pt(40, 946)]
    p.poly(stoneQuad, Shop.stoneTop)
    crossHatch(p, pathOf(stoneQuad), depth: 3, spacing: 7, colour: Shop.stoneDark.al(0.36), seed: rng.next())
    let chase = [pt(230, 780), pt(600, 760), pt(618, 862), pt(240, 886)]
    p.poly(chase, Shop.ironBlack)
    p.poly([pt(268, 794), pt(566, 778), pt(580, 848), pt(278, 868)], Shop.lead.dk(0.16))
    for k in 0..<9 {
        let t = Double(k) / 9
        pen(p, [pt(276 + t * 292, 800 + t * -14), pt(280 + t * 292, 862 + t * -14)],
            weight: 3.0, colour: Shop.leadDark, wobble: 0.4, taper: false, seed: rng.next())
    }
    penEdge(p, chase, weight: 4.6, colour: Shop.ironBlack.dk(0.4), seed: rng.next())

    let pressX = 1080.0
    let pressBody = [pt(pressX - 140, 980), pt(pressX + 160, 960), pt(pressX + 130, 470), pt(pressX - 100, 480)]
    p.poly(pressBody, Shop.ironBlack.lt(h.beam * 0.24))
    crossHatch(p, pathOf(pressBody), depth: 3, spacing: 8, colour: Shop.ironBlack.dk(0.5), seed: rng.next())
    p.poly([pt(pressX - 120, 700), pt(pressX + 150, 686), pt(pressX + 150, 742), pt(pressX - 118, 756)],
           Shop.steel.dk(0.24))
    pen(p, [pt(pressX + 140, 690), pt(pressX + 300, 600), pt(pressX + 330, 520)], weight: 20,
        colour: Shop.ironBlack, wobble: 0.7, taper: true, seed: rng.next())
    p.disc(pressX + 334, 512, 26, Shop.oakDark)
    penEdge(p, pressBody, weight: 5.0, colour: Shop.ironBlack.dk(0.6), seed: rng.next())

    if h.gas && h.lamp > 0.05 {
        let lx = 640.0, ly = 250.0
        pen(p, [pt(lx, 40), pt(lx, ly - 40)], weight: 7, colour: Shop.ironBlack,
            wobble: 0.4, taper: false, seed: rng.next())
        p.poly([pt(lx - 62, ly - 40), pt(lx + 62, ly - 40), pt(lx + 40, ly + 16), pt(lx - 40, ly + 16)],
               Shop.ironBlack)
        if let g = CGGradient(colorsSpace: shopSpace,
                              colors: [cg(Shop.gasGlow.al(0.62 * h.lamp)),
                                       cg(Shop.gasGlow.al(0))] as CFArray, locations: [0, 1]) {
            p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: lx, y: ly + 30), startRadius: 0,
                                     endCenter: CGPoint(x: lx, y: ly + 30), endRadius: 420, options: [])
        }
        p.disc(lx, ly + 26, 22, Shop.lampGlow.al(0.9))
        for k in 0..<16 {
            let a = Double(k) / 16 * 2 * .pi
            pen(p, [pt(lx + cos(a) * 30, ly + 26 + sin(a) * 30),
                    pt(lx + cos(a) * 74, ly + 26 + sin(a) * 74)],
                weight: 3.2, colour: Shop.lampGlow.al(0.35 * h.lamp), wobble: 0.5,
                taper: true, seed: rng.next())
        }
    }

    let nearStick = [pt(-30, 990), pt(430, 940), pt(444, 1020), pt(-30, 1020)]
    p.poly(nearStick, Shop.brass.dk(0.32))
    crossHatch(p, pathOf(nearStick), depth: 2, spacing: 6, colour: Shop.brassDark, seed: rng.next())
    for k in 0..<12 {
        let x = -10 + Double(k) * 38
        p.rect(x, 952 - Double(k) * 4, 26, 46, Shop.lead.dk(rng.r(0.0, 0.22)))
        p.rect(x + 3, 968 - Double(k) * 4, 20, 5, Shop.leadDark.dk(0.4))
    }
    penEdge(p, nearStick, weight: 5.0, colour: Shop.brassDark.dk(0.4), seed: rng.next())

    let dark = 1.0 - h.beam * 0.7 - h.lamp * 0.25
    if dark > 0.12 {
        if let g = CGGradient(colorsSpace: shopSpace,
                              colors: [cg(Shop.shadowRoom.al(0)),
                                       cg(Shop.shadowRoom.al(min(0.68, dark * 0.72)))] as CFArray,
                              locations: [0.24, 1]) {
            p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 900, y: 400), startRadius: 0,
                                     endCenter: CGPoint(x: 900, y: 400), endRadius: 1180,
                                     options: [.drawsAfterEndLocation])
        }
    }
    grit(p, pathOf([pt(0, 0), pt(1500, 0), pt(1500, 1020), pt(0, 1020)]), density: 0.00016,
         sizeMin: 0.4, sizeMax: 1.6, colour: Shop.sepia, seed: rng.next())
    p.write(dir, h.key)
}

func diagramBase(_ p: Sheet, _ title: String, _ seed: UInt64) -> Quoin {
    var rng = Quoin(seed)
    layStock(p, seed: seed &+ 3, tone: Shop.paperWarm)
    p.flipTopDown()
    wash(p, [pt(46, 40), pt(p.w - 46, 48), pt(p.w - 46, p.h - 40), pt(46, p.h - 48)],
         Shop.paperGrey, strength: 0.14, bleed: 10, seed: rng.next())
    borderRule(p, inset: 30, seed: rng.next())
    label(p, title.uppercased(), at: p.w / 2, 86, size: 21, colour: Shop.blackSoft,
          face: "Georgia-Bold", align: .centre, tracking: 7)
    pen(p, [pt(120, 108), pt(p.w - 120, 108)], weight: 1.6, colour: Shop.blackPale,
        wobble: 0.5, taper: true, seed: rng.next())
    return rng
}

func callout(_ p: Sheet, from: CGPoint, to: CGPoint, text: String, align: Align, seed: UInt64) {
    pen(p, [from, to], weight: 1.5, colour: Shop.blackPale, wobble: 0.6, taper: false, seed: seed)
    p.disc(Double(from.x), Double(from.y), 4, Shop.blackSoft)
    let dx = align == .right ? -10.0 : (align == .left ? 10.0 : 0)
    label(p, text, at: Double(to.x) + dx, Double(to.y) + 6, size: 17,
          colour: Shop.blackSoft, face: "Georgia-Italic", align: align)
}

func casePlate(dir: String) {
    let p = Sheet(1500, 900)
    var rng = diagramBase(p, "The California Job Case", seedOf("dg-case"))
    let x0 = 70.0, y0 = 150.0
    let sw = 1360.0 / Frame.unitsWide
    let sh = 620.0 / Frame.unitsTall
    p.poly([pt(x0 - 22, y0 - 22), pt(x0 + 1360 + 22, y0 - 22),
            pt(x0 + 1360 + 22, y0 + 620 + 22), pt(x0 - 22, y0 + 620 + 22)], Shop.oak)
    grainRun(p, pathOf([pt(x0 - 22, y0 - 22), pt(x0 + 1382, y0 - 22),
                        pt(x0 + 1382, y0 + 642), pt(x0 - 22, y0 + 642)]),
             count: 420, length: 74, weight: 1.4, spread: 0.06, angle: 0,
             colour: Shop.oakDark.al(0.42), seed: rng.next())
    for box in JobCase.boxes {
        let bx = x0 + box.x * sw, by = y0 + box.y * sh
        let bw = box.w * sw - 4, bh = box.h * sh - 4
        let tone: Ink
        switch box.kind {
        case 1: tone = Shop.paperCool.dk(0.10)
        case 2: tone = Shop.paperCool.dk(0.18)
        case 3: tone = Shop.paperGrey.dk(0.06)
        case 4: tone = Shop.paperWarm.dk(0.14)
        case 5: tone = Shop.leadLight.lt(0.20)
        default: tone = Shop.paperWarm.lt(0.20)
        }
        p.poly([pt(bx + 2, by + 2), pt(bx + bw, by + 2), pt(bx + bw, by + bh), pt(bx + 2, by + bh)], tone)
        penEdge(p, [pt(bx + 2, by + 2), pt(bx + bw, by + 2), pt(bx + bw, by + bh), pt(bx + 2, by + bh)],
                weight: 2.0, colour: Shop.oakDark.al(0.8), seed: rng.next())
        let size = min(bh * 0.52, bw * 0.62)
        label(p, box.label, at: bx + bw / 2 + 1, by + bh / 2 + size * 0.34,
              size: max(9, min(26, size)), colour: Shop.black, face: "Georgia", align: .centre)
    }
    penEdge(p, [pt(x0 - 22, y0 - 22), pt(x0 + 1382, y0 - 22),
                pt(x0 + 1382, y0 + 642), pt(x0 - 22, y0 + 642)],
            weight: 5, colour: Shop.oakDark.dk(0.4), seed: rng.next())
    label(p, "lower case, figures, points and spaces", at: x0 + 440, y0 + 686, size: 18,
          colour: Shop.blackSoft, face: "Georgia-Italic", align: .centre)
    label(p, "capitals", at: x0 + 1090, y0 + 686, size: 18,
          colour: Shop.blackSoft, face: "Georgia-Italic", align: .centre)
    label(p, "The box for e is the largest in the case. J and U sit after Z because they were not separate letters when the order was fixed.",
          at: p.w / 2, y0 + 726, size: 17, colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    p.write(dir, "dg_case")
}

func anatomyPlate(dir: String) {
    let p = Sheet(1300, 1000)
    p.light = 2.44
    var rng = diagramBase(p, "The Anatomy of a Sort", seedOf("dg-anatomy"))
    let f = Foundry.face("caslon")
    drawSortSolid(p, x: 300, y: 720, w: 420, h: 380, face: f, ch: "a", seed: rng.next())
    var y = 250.0
    for (name, meaning) in Tables.anatomy {
        label(p, name, at: 830, y, size: 20, colour: Shop.black, face: "Georgia-Bold", align: .left)
        var ly = y + 24
        for line in foldAt(meaning, width: 400, size: 16, face: "Georgia") {
            label(p, line, at: 830, ly, size: 16, colour: Shop.blackSoft, face: "Georgia", align: .left)
            ly += 21
        }
        y = ly + 14
    }
    callout(p, from: pt(500, 560), to: pt(230, 500), text: "the face, mirrored", align: .right, seed: rng.next())
    callout(p, from: pt(420, 640), to: pt(200, 660), text: "the nick", align: .right, seed: rng.next())
    callout(p, from: pt(340, 712), to: pt(190, 780), text: "the feet", align: .right, seed: rng.next())
    p.write(dir, "dg_anatomy")
}

func stickPlate(dir: String) {
    let p = Sheet(1400, 940)
    p.light = 2.36
    var rng = diagramBase(p, "The Stick, and Why It Reads Backwards", seedOf("dg-stick"))
    let f = Foundry.face("caslon")
    let x0 = 120.0, y0 = 300.0, w = 1160.0, h = 300.0
    p.poly([pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + h), pt(x0, y0 + h)], Shop.brass)
    crossHatch(p, pathOf([pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + h), pt(x0, y0 + h)]),
               depth: 2, spacing: 9, colour: Shop.brassDark.al(0.44), seed: rng.next())
    grainRun(p, pathOf([pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + h), pt(x0, y0 + h)]),
             count: 300, length: 90, weight: 1.4, spread: 0.05, angle: 0,
             colour: Shop.brassLight.al(0.36), seed: rng.next())
    p.poly([pt(x0, y0 + h - 46), pt(x0 + w, y0 + h - 46), pt(x0 + w, y0 + h), pt(x0, y0 + h)],
           Shop.brassDark)
    for k in 0...36 {
        let x = x0 + 24 + Double(k) * 30
        let tall = k % 6 == 0 ? 26.0 : 14.0
        pen(p, [pt(x, y0 + h - 46), pt(x, y0 + h - 46 + tall)], weight: 2.2,
            colour: Shop.brassDark.dk(0.5), wobble: 0.3, taper: false, seed: rng.next())
        pen(p, [pt(x + 3, y0 + h - 46), pt(x + 3, y0 + h - 46 + tall)], weight: 1.4,
            colour: Shop.brassLight.lt(0.3), wobble: 0.3, taper: false, seed: rng.next())
    }
    let text = "SET IN A STICK"
    let size = 150.0
    var cursor = x0 + 40
    let total = measureLine(text, f, size: size)
    cursor = x0 + (w - total) / 2
    for ch in text.reversed() {
        let s = String(ch)
        if s == " " { cursor += size / 3; continue }
        guard let m = Forge.metal(s, f) else { continue }
        let adv = m.adv * size / EmBox.unit
        p.poly([pt(cursor + 2, y0 + 40), pt(cursor + adv - 2, y0 + 40),
                pt(cursor + adv - 2, y0 + h - 52), pt(cursor + 2, y0 + h - 52)], Shop.lead)
        p.poly([pt(cursor + 4, y0 + h - 82), pt(cursor + adv - 4, y0 + h - 82),
                pt(cursor + adv - 4, y0 + h - 66), pt(cursor + 4, y0 + h - 66)], Shop.leadDark.dk(0.36))
        _ = setSort(p, s, f, size: size, x: cursor, y: y0 + 120,
                    colour: Shop.leadDark.dk(0.42), counterTone: Shop.antimony.lt(0.2),
                    coverage: 1.0, seed: rng.next(), turned: true)
        cursor += adv
    }
    penEdge(p, [pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + h), pt(x0, y0 + h)],
            weight: 5, colour: Shop.brassDark.dk(0.5), seed: rng.next())
    label(p, "in the stick the line reads away from you, mirrored and upside down",
          at: p.w / 2, y0 - 30, size: 19, colour: Shop.blackSoft, face: "Georgia-Italic", align: .centre)
    inkedLine(p, text, f, size: 96, x: p.w / 2, y: 780, colour: Shop.black,
              paper: Shop.paperWarm, align: .centre, coverage: 0.98, seed: rng.next())
    label(p, "and on the sheet it comes out the right way round", at: p.w / 2, 830,
          size: 19, colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    p.write(dir, "dg_stick")
}

func spacingPlate(dir: String) {
    let p = Sheet(1300, 980)
    var rng = diagramBase(p, "Spaces and Quads", seedOf("dg-spacing"))
    let em = 260.0
    var y = 190.0
    for row in Tables.spaces {
        let w = em * row.ems
        p.poly([pt(200, y), pt(200 + w, y), pt(200 + w, y + 62), pt(200, y + 62)], Shop.leadLight)
        crossHatch(p, pathOf([pt(200, y), pt(200 + w, y), pt(200 + w, y + 62), pt(200, y + 62)]),
                   depth: 2, spacing: 7, colour: Shop.lead.al(0.5), seed: rng.next())
        penEdge(p, [pt(200, y), pt(200 + w, y), pt(200 + w, y + 62), pt(200, y + 62)],
                weight: 2.6, colour: Shop.leadDark, seed: rng.next())
        label(p, row.name, at: 186, y + 40, size: 20, colour: Shop.black,
              face: "Georgia-Bold", align: .right)
        label(p, row.use, at: 480 + em, y + 40, size: 17, colour: Shop.blackSoft,
              face: "Georgia", align: .left)
        y += 86
    }
    pen(p, [pt(200, 170), pt(200 + em, 170)], weight: 2.0, colour: Shop.sepia,
        wobble: 0.4, taper: false, seed: rng.next())
    label(p, "one em, the body square", at: 200 + em / 2, 158, size: 16,
          colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    label(p, "The brass thin is one point and the copper thin is half a point, whatever the size of the body.",
          at: p.w / 2, y + 40, size: 18, colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    p.write(dir, "dg_spacing")
}

func pointsPlate(dir: String) {
    let p = Sheet(1400, 860)
    p.light = 2.40
    var rng = diagramBase(p, "The Point System", seedOf("dg-points"))
    let x0 = 100.0, y0 = 260.0, w = 1200.0
    p.poly([pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + 130), pt(x0, y0 + 130)], Shop.brass)
    grainRun(p, pathOf([pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + 130), pt(x0, y0 + 130)]),
             count: 280, length: 90, weight: 1.3, spread: 0.05, angle: 0,
             colour: Shop.brassLight.al(0.4), seed: rng.next())
    let picas = 24
    for k in 0...picas * 2 {
        let x = x0 + 20 + Double(k) * (w - 40) / Double(picas * 2)
        let tall = k % 2 == 0 ? 54.0 : 30.0
        pen(p, [pt(x, y0 + 130), pt(x, y0 + 130 - tall)], weight: 2.6,
            colour: Shop.brassDark.dk(0.5), wobble: 0.25, taper: false, seed: rng.next())
        pen(p, [pt(x + 3.4, y0 + 130), pt(x + 3.4, y0 + 130 - tall)], weight: 1.6,
            colour: Shop.brassLight.lt(0.34), wobble: 0.25, taper: false, seed: rng.next())
        if k % 4 == 0 {
            label(p, "\(k / 2)", at: x, y0 + 56, size: 17, colour: Shop.brassDark.dk(0.6),
                  face: "Georgia", align: .centre)
        }
    }
    penEdge(p, [pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + 130), pt(x0, y0 + 130)],
            weight: 4.4, colour: Shop.brassDark.dk(0.5), seed: rng.next())
    label(p, "a line gauge, marked in picas", at: p.w / 2, y0 - 26, size: 19,
          colour: Shop.blackSoft, face: "Georgia-Italic", align: .centre)

    var y = 470.0
    var x = 130.0
    for (points, name, note) in Tables.sizes {
        label(p, "\(points)", at: x, y, size: 22, colour: Shop.black, face: "Georgia-Bold", align: .left)
        label(p, name, at: x + 46, y, size: 20, colour: Shop.blackSoft, face: "Georgia", align: .left)
        label(p, note, at: x + 46, y + 24, size: 15, colour: Shop.blackPale,
              face: "Georgia-Italic", align: .left)
        y += 68
        if y > 800 { y = 470; x = 740 }
    }
    p.write(dir, "dg_points")
}

func lockupPlate(dir: String) {
    let p = Sheet(1300, 980)
    p.light = 2.34
    var rng = diagramBase(p, "Locking Up in the Chase", seedOf("dg-lockup"))
    let cx0 = 180.0, cy0 = 190.0, cw = 940.0, ch = 640.0
    p.poly([pt(cx0 - 40, cy0 - 40), pt(cx0 + cw + 40, cy0 - 40),
            pt(cx0 + cw + 40, cy0 + ch + 40), pt(cx0 - 40, cy0 + ch + 40)], Shop.ironBlack)
    crossHatch(p, pathOf([pt(cx0 - 40, cy0 - 40), pt(cx0 + cw + 40, cy0 - 40),
                          pt(cx0 + cw + 40, cy0 + ch + 40), pt(cx0 - 40, cy0 + ch + 40)]),
               depth: 2, spacing: 10, colour: Shop.ironBlack.dk(0.5), seed: rng.next())
    p.poly([pt(cx0, cy0), pt(cx0 + cw, cy0), pt(cx0 + cw, cy0 + ch), pt(cx0, cy0 + ch)],
           Shop.stoneTop.dk(0.10))

    let fx = cx0 + 220, fy = cy0 + 170, fw = 460.0, fh = 300.0
    p.poly([pt(fx, fy), pt(fx + fw, fy), pt(fx + fw, fy + fh), pt(fx, fy + fh)], Shop.lead)
    let face = Foundry.face("clarendon")
    for k in 0..<5 {
        setLine(p, ["THE FORME", "is held by", "NOTHING BUT", "friction and", "the quoins"][k],
                face, size: 44, x: fx + fw / 2, y: fy + 58 + Double(k) * 54,
                colour: Shop.leadDark.dk(0.4), counterTone: Shop.antimony.lt(0.2),
                coverage: 1.0, align: .centre, seed: rng.next())
    }
    penEdge(p, [pt(fx, fy), pt(fx + fw, fy), pt(fx + fw, fy + fh), pt(fx, fy + fh)],
            weight: 3.2, colour: Shop.leadDark, seed: rng.next())

    let furn = Shop.furniture
    for r in [CGRect(x: fx - 120, y: fy - 100, width: fw + 240, height: 90),
              CGRect(x: fx - 120, y: fy + fh + 10, width: fw + 240, height: 90),
              CGRect(x: fx - 120, y: fy, width: 106, height: fh),
              CGRect(x: fx + fw + 14, y: fy, width: 106, height: fh)] {
        let quad = [pt(Double(r.minX), Double(r.minY)), pt(Double(r.maxX), Double(r.minY)),
                    pt(Double(r.maxX), Double(r.maxY)), pt(Double(r.minX), Double(r.maxY))]
        p.poly(quad, furn)
        grainRun(p, pathOf(quad), count: 90, length: 40, weight: 1.3, spread: 0.08,
                 angle: r.width > r.height ? 0 : 1.57, colour: Shop.oakDark.al(0.42), seed: rng.next())
        penEdge(p, quad, weight: 2.4, colour: Shop.oakDark, seed: rng.next())
    }
    for (qx, qy, ang) in [(fx + fw + 130.0, fy + 60.0, 0.0), (fx + fw + 130.0, fy + fh - 130.0, 0.0),
                          (fx + 60.0, fy + fh + 108.0, 1.57), (fx + fw - 130.0, fy + fh + 108.0, 1.57)] {
        let long = ang == 0 ? 60.0 : 130.0
        let short = ang == 0 ? 130.0 : 60.0
        let quad = [pt(qx, qy), pt(qx + long, qy), pt(qx + long, qy + short), pt(qx, qy + short)]
        p.poly(quad, Shop.steel)
        formTone(p, quad, inset: 22, depth: 2, spacing: 5, colour: Shop.leadDark, seed: rng.next())
        p.disc(qx + long / 2, qy + short / 2, 14, Shop.ironBlack)
        penEdge(p, quad, weight: 2.6, colour: Shop.ironBlack, seed: rng.next())
    }
    callout(p, from: pt(fx + fw + 190, fy + 90), to: pt(cx0 + cw + 90, fy + 40),
            text: "quoin", align: .left, seed: rng.next())
    callout(p, from: pt(fx - 60, fy + 150), to: pt(cx0 - 90, fy + 120), text: "furniture",
            align: .right, seed: rng.next())
    callout(p, from: pt(cx0 - 20, cy0 + 30), to: pt(cx0 - 110, cy0 - 10), text: "chase",
            align: .right, seed: rng.next())
    label(p, "Quoins on two sides only. A forme squeezed from all four has nowhere to go.",
          at: p.w / 2, 908, size: 18, colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    p.write(dir, "dg_lockup")
}

func inkDiagram(dir: String) {
    let p = Sheet(1300, 900)
    p.light = 2.42
    var rng = diagramBase(p, "Ink, Slab and Brayer", seedOf("dg-ink"))
    let slab = [pt(120, 260), pt(700, 250), pt(716, 640), pt(126, 654)]
    p.poly(slab, Shop.stoneTop.lt(0.14))
    crossHatch(p, pathOf(slab), depth: 2, spacing: 10, colour: Shop.stoneDark.al(0.30), seed: rng.next())
    for k in 0..<6 {
        var streak: [CGPoint] = []
        for i in 0...26 {
            let t = Double(i) / 26
            streak.append(pt(170 + t * 480, 320 + Double(k) * 52 + sin(t * 3 + Double(k)) * 8))
        }
        pen(p, streak, weight: 34 - Double(k) * 3, colour: Shop.black.al(0.90 - Double(k) * 0.11),
            wobble: 1.8, taper: true, seed: rng.next())
    }
    penEdge(p, slab, weight: 3.4, colour: Shop.stoneDark, seed: rng.next())

    let rx = 940.0, ry = 400.0
    p.poly([pt(rx - 130, ry - 60), pt(rx + 130, ry - 60), pt(rx + 130, ry + 60), pt(rx - 130, ry + 60)],
           Shop.ironBlack.lt(0.18))
    formTone(p, [pt(rx - 130, ry - 60), pt(rx + 130, ry - 60), pt(rx + 130, ry + 60), pt(rx - 130, ry + 60)],
             inset: 40, depth: 3, spacing: 5, colour: Shop.ironBlack.dk(0.4), seed: rng.next())
    p.disc(rx - 130, ry, 60, Shop.ironBlack.lt(0.26))
    p.disc(rx + 130, ry, 60, Shop.ironBlack.lt(0.10))
    pen(p, [pt(rx, ry), pt(rx + 30, ry - 190)], weight: 16, colour: Shop.steel,
        wobble: 0.4, taper: false, seed: rng.next())
    pen(p, [pt(rx + 26, ry - 170), pt(rx + 40, ry - 250)], weight: 34, colour: Shop.oak,
        wobble: 0.5, taper: false, seed: rng.next())
    grainRun(p, pathOf([pt(rx + 12, ry - 260), pt(rx + 62, ry - 260), pt(rx + 62, ry - 160), pt(rx + 12, ry - 160)]),
             count: 60, length: 28, weight: 1.2, spread: 0.1, angle: 1.57,
             colour: Shop.oakDark.al(0.5), seed: rng.next())

    label(p, "Work the ink out on the slab first, then roll the forme in two directions.",
          at: p.w / 2, 720, size: 19, colour: Shop.blackSoft, face: "Georgia-Italic", align: .centre)
    let f = Foundry.face("caslon")
    inkedLine(p, "aeog", f, size: 100, x: 330, y: 830, colour: Shop.black,
              paper: Shop.paperWarm, align: .centre, coverage: 0.62, seed: rng.next())
    inkedLine(p, "aeog", f, size: 100, x: 660, y: 830, colour: Shop.black,
              paper: Shop.paperWarm, align: .centre, coverage: 1.0, seed: rng.next())
    inkedLine(p, "aeog", f, size: 100, x: 990, y: 830, colour: Shop.black,
              paper: Shop.paperWarm, align: .centre, coverage: 1.30, seed: rng.next())
    label(p, "too little", at: 330, 866, size: 15, colour: Shop.blackPale, face: "Georgia-Italic", align: .centre)
    label(p, "right", at: 660, 866, size: 15, colour: Shop.blackPale, face: "Georgia-Italic", align: .centre)
    label(p, "filled in", at: 990, 866, size: 15, colour: Shop.blackPale, face: "Georgia-Italic", align: .centre)
    p.write(dir, "dg_ink")
}

func makereadyPlate(dir: String) {
    let p = Sheet(1300, 900)
    p.light = 2.36
    var rng = diagramBase(p, "Makeready", seedOf("dg-makeready"))
    let baseY = 620.0
    p.poly([pt(120, baseY), pt(1180, baseY), pt(1180, baseY + 120), pt(120, baseY + 120)], Shop.ironBlack)
    label(p, "the platen", at: 650, baseY + 80, size: 20, colour: Shop.paperGrey,
          face: "Georgia-Italic", align: .centre)
    var y = baseY
    for k in 0..<5 {
        let inset = Double(k) * 90 + 140
        let width = 1060 - Double(k) * 180
        y -= 26
        p.poly([pt(inset, y), pt(inset + width, y), pt(inset + width, y + 22), pt(inset, y + 22)],
               Shop.paper.dk(Double(k) * 0.03))
        penEdge(p, [pt(inset, y), pt(inset + width, y), pt(inset + width, y + 22), pt(inset, y + 22)],
                weight: 1.8, colour: Shop.blackPale, seed: rng.next())
        label(p, k == 0 ? "packing" : "tissue \(k)", at: inset - 14, y + 18, size: 15,
              colour: Shop.blackPale, face: "Georgia-Italic", align: .right)
    }
    y -= 40
    p.poly([pt(140, y), pt(1160, y), pt(1160, y + 26), pt(140, y + 26)], Shop.rag)
    label(p, "the sheet", at: 126, y + 22, size: 16, colour: Shop.blackSoft,
          face: "Georgia-Italic", align: .right)
    y -= 118
    p.poly([pt(220, y), pt(1080, y), pt(1080, y + 100), pt(220, y + 100)], Shop.lead)
    let f = Foundry.face("bodoni")
    setLine(p, "MAKEREADY", f, size: 76, x: 650, y: y + 82, colour: Shop.leadDark.dk(0.44),
            counterTone: Shop.antimony.lt(0.20), coverage: 1.0, align: .centre, seed: rng.next())
    penEdge(p, [pt(220, y), pt(1080, y), pt(1080, y + 100), pt(220, y + 100)],
            weight: 3.2, colour: Shop.leadDark, seed: rng.next())
    label(p, "the forme", at: 206, y + 60, size: 16, colour: Shop.blackSoft,
          face: "Georgia-Italic", align: .right)
    label(p, "Paste tissue behind the areas that printed light, and pull again.",
          at: p.w / 2, 838, size: 19, colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    p.write(dir, "dg_makeready")
}

func distPlate(dir: String) {
    let p = Sheet(1300, 900)
    p.light = 2.32
    var rng = diagramBase(p, "Distribution", seedOf("dg-dist"))
    let x0 = 110.0, y0 = 200.0, sw = 1080.0 / Frame.unitsWide, sh = 470.0 / Frame.unitsTall
    p.poly([pt(x0 - 18, y0 - 18), pt(x0 + 1080 + 18, y0 - 18),
            pt(x0 + 1080 + 18, y0 + 470 + 18), pt(x0 - 18, y0 + 470 + 18)], Shop.oak)
    for box in JobCase.boxes {
        let bx = x0 + box.x * sw, by = y0 + box.y * sh
        let bw = box.w * sw - 3, bh = box.h * sh - 3
        p.poly([pt(bx + 2, by + 2), pt(bx + bw, by + 2), pt(bx + bw, by + bh), pt(bx + 2, by + bh)],
               Shop.paperWarm.dk(0.12))
        var g = Quoin(seedOf("dist" + box.key))
        for _ in 0..<g.i(2, 8) {
            p.rect(bx + g.r(4, max(5, bw - 8)), by + g.r(4, max(5, bh - 8)),
                   g.r(2.5, 4.5), g.r(5, 10), Shop.lead.dk(g.r(0, 0.28)))
        }
        penEdge(p, [pt(bx + 2, by + 2), pt(bx + bw, by + 2), pt(bx + bw, by + bh), pt(bx + 2, by + bh)],
                weight: 1.6, colour: Shop.oakDark.al(0.7), seed: rng.next())
    }
    let held = [pt(760, 700), pt(1120, 690), pt(1128, 790), pt(766, 802)]
    p.poly(held, Shop.leadLight)
    for k in 0..<22 {
        let x = 772 + Double(k) * 16
        p.rect(x, 706, 11, 84, Shop.lead.dk(Double(k % 5) * 0.06))
        p.rect(x + 1, 740, 9, 5, Shop.leadDark.dk(0.4))
    }
    penEdge(p, held, weight: 3, colour: Shop.leadDark, seed: rng.next())
    label(p, "a few lines held in the left hand", at: 944, 836, size: 17,
          colour: Shop.blackSoft, face: "Georgia-Italic", align: .centre)
    for k in 0..<7 {
        let sx = 730.0 - Double(k) * 74
        let sy = 690.0 - Double(k) * 46
        p.rect(sx, sy, 12, 26, Shop.lead.dk(0.1))
        pen(p, [pt(sx + 6, sy + 30), pt(sx + 6 + Double(k) * 4, sy + 62)], weight: 1.2,
            colour: Shop.blackPale.al(0.5), wobble: 0.6, taper: true, seed: rng.next())
    }
    label(p, "Read the line, then let the sorts fall into their boxes several at a time.",
          at: 470, 838, size: 18, colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    p.write(dir, "dg_dist")
}

func pressPlate(dir: String) {
    let p = Sheet(1400, 1000)
    p.light = 2.30
    var rng = diagramBase(p, "Two Presses", seedOf("dg-press"))
    let ax = 380.0
    let frame = [pt(ax - 170, 880), pt(ax + 170, 880), pt(ax + 130, 260), pt(ax - 130, 260)]
    p.poly(frame, Shop.ironBlack.lt(0.20))
    crossHatch(p, pathOf(frame), depth: 3, spacing: 8, colour: Shop.ironBlack.dk(0.5), seed: rng.next())
    p.poly([pt(ax - 150, 560), pt(ax + 150, 560), pt(ax + 150, 620), pt(ax - 150, 620)], Shop.steel)
    p.poly([pt(ax - 130, 470), pt(ax + 130, 470), pt(ax + 130, 540), pt(ax - 130, 540)], Shop.lead)
    pen(p, [pt(ax + 140, 600), pt(ax + 330, 470), pt(ax + 360, 350)], weight: 24,
        colour: Shop.ironBlack, wobble: 0.6, taper: true, seed: rng.next())
    p.disc(ax + 364, 340, 30, Shop.oakDark)
    penEdge(p, frame, weight: 5, colour: Shop.ironBlack.dk(0.6), seed: rng.next())
    callout(p, from: pt(ax, 500), to: pt(ax - 260, 430), text: "the forme", align: .right, seed: rng.next())
    callout(p, from: pt(ax, 590), to: pt(ax - 260, 660), text: "the platen", align: .right, seed: rng.next())
    label(p, "Platen jobbing press", at: ax, 930, size: 21, colour: Shop.black,
          face: "Georgia-Bold", align: .centre)

    let bx = 1000.0
    let post = [pt(bx - 40, 880), pt(bx + 60, 880), pt(bx + 40, 220), pt(bx - 20, 220)]
    p.poly(post, Shop.ironBlack.lt(0.16))
    crossHatch(p, pathOf(post), depth: 3, spacing: 8, colour: Shop.ironBlack.dk(0.5), seed: rng.next())
    p.poly([pt(bx - 260, 250), pt(bx + 90, 250), pt(bx + 90, 310), pt(bx - 260, 310)], Shop.ironBlack.lt(0.24))
    p.poly([pt(bx - 240, 560), pt(bx + 70, 560), pt(bx + 70, 610), pt(bx - 240, 610)], Shop.steel)
    p.poly([pt(bx - 230, 620), pt(bx + 60, 620), pt(bx + 60, 700), pt(bx - 230, 700)], Shop.oak)
    grainRun(p, pathOf([pt(bx - 230, 620), pt(bx + 60, 620), pt(bx + 60, 700), pt(bx - 230, 700)]),
             count: 80, length: 40, weight: 1.3, spread: 0.06, angle: 0,
             colour: Shop.oakDark.al(0.5), seed: rng.next())
    pen(p, [pt(bx - 130, 400), pt(bx - 130, 560)], weight: 30, colour: Shop.steel,
        wobble: 0.4, taper: false, seed: rng.next())
    pen(p, [pt(bx + 40, 420), pt(bx + 280, 470), pt(bx + 340, 560)], weight: 22,
        colour: Shop.ironBlack, wobble: 0.6, taper: true, seed: rng.next())
    p.disc(bx + 344, 570, 30, Shop.oakDark)
    penEdge(p, post, weight: 5, colour: Shop.ironBlack.dk(0.6), seed: rng.next())
    callout(p, from: pt(bx - 130, 430), to: pt(bx + 300, 330), text: "the toggle", align: .left, seed: rng.next())
    callout(p, from: pt(bx - 100, 650), to: pt(bx + 300, 700), text: "the bed", align: .left, seed: rng.next())
    label(p, "Iron hand press", at: bx, 930, size: 21, colour: Shop.black,
          face: "Georgia-Bold", align: .centre)
    p.write(dir, "dg_press")
}

func woodPlate(dir: String) {
    let p = Sheet(1300, 900)
    p.light = 2.44
    var rng = diagramBase(p, "Wood Letter", seedOf("dg-wood"))
    let block = [pt(180, 220), pt(1120, 210), pt(1130, 700), pt(186, 716)]
    p.poly(block, Shop.maple)
    for _ in 0..<60 {
        let cx = rng.r(200, 1100), cy = rng.r(230, 690)
        p.ring(cx, cy, rng.r(6, 26), rng.r(1.2, 2.6), Shop.mapleDark.al(rng.r(0.18, 0.44)))
    }
    grainRun(p, pathOf(block), count: 900, length: 20, weight: 1.2, spread: 3.14,
             colour: Shop.mapleDark.al(0.30), seed: rng.next())
    let f = Foundry.face("poster")
    setLine(p, "WOOD", f, size: 300, x: 650, y: 580, colour: Shop.vermilion.dk(0.20),
            counterTone: Shop.maple, coverage: 1.0, align: .centre, seed: rng.next())
    grainRun(p, pathOf(block), count: 500, length: 24, weight: 1.6, spread: 0.10,
             angle: 0, colour: Shop.maple.al(0.34), seed: rng.next())
    penEdge(p, block, weight: 5, colour: Shop.mapleDark.dk(0.4), seed: rng.next())
    label(p, "End grain maple, cut on a pantograph. Lighter than metal, cheaper above seventy two point, and it shows its grain in the solids.",
          at: p.w / 2, 800, size: 19, colour: Shop.blackSoft, face: "Georgia-Italic", align: .centre)
    p.write(dir, "dg_wood")
}

func colourPlate(dir: String) {
    let p = Sheet(1300, 900)
    var rng = diagramBase(p, "The Second Colour", seedOf("dg-colour"))
    let f = Foundry.face("clarendon")
    let stock = Shop.paper
    for (i, off) in [0.0, 3.0, 14.0].enumerated() {
        let x = 260.0 + Double(i) * 400
        p.poly([pt(x - 170, 220), pt(x + 170, 220), pt(x + 170, 560), pt(x - 170, 560)], stock.lt(0.30))
        penEdge(p, [pt(x - 170, 220), pt(x + 170, 220), pt(x + 170, 560), pt(x - 170, 560)],
                weight: 2.2, colour: Shop.blackPale, seed: rng.next())
        setLine(p, "TWO", f, size: 96, x: x, y: 360, colour: Shop.prussian.al(0.62),
                counterTone: stock.lt(0.30), coverage: 1.0, align: .centre, seed: rng.next())
        setLine(p, "TWO", f, size: 96, x: x + off, y: 360 + off * 0.5,
                colour: Shop.crimson.al(0.62), counterTone: stock.lt(0.30),
                coverage: 1.0, align: .centre, seed: rng.next())
        setLine(p, "COLOURS", f, size: 52, x: x, y: 460, colour: Shop.black,
                counterTone: stock.lt(0.30), coverage: 1.0, align: .centre, seed: rng.next())
        label(p, ["in register", "one point out", "five points out"][i], at: x, 600,
              size: 18, colour: Shop.blackSoft, face: "Georgia-Italic", align: .centre)
    }
    label(p, "Two transparent inks laid over one another give a third colour where they cross. Opaque inks cover instead.",
          at: p.w / 2, 700, size: 19, colour: Shop.blackSoft, face: "Georgia", align: .centre)
    label(p, "The sheet is registered against a side lay and two front lays, and everything depends on it being cut square.",
          at: p.w / 2, 740, size: 19, colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    p.write(dir, "dg_colour")
}

func onboardPlate(_ index: Int, dir: String) {
    let p = Sheet(1320, 960)
    p.light = 2.36
    var rng = Quoin(seedOf("onboard-\(index)"))
    layStock(p, seed: seedOf("onboardpaper-\(index)"), tone: Shop.paperWarm)
    p.flipTopDown()
    washBand(p, from: 0, to: 480, Shop.sepia, strength: 0.07, seed: rng.next())
    borderRule(p, inset: 34, seed: rng.next())
    let f = Foundry.face("caslon")

    switch index {
    case 0:
        let x0 = 110.0, y0 = 200.0, sw = 1100.0 / Frame.unitsWide, sh = 520.0 / Frame.unitsTall
        p.poly([pt(x0 - 20, y0 - 20), pt(x0 + 1120, y0 - 20), pt(x0 + 1120, y0 + 540), pt(x0 - 20, y0 + 540)],
               Shop.oak)
        for box in JobCase.boxes {
            let bx = x0 + box.x * sw, by = y0 + box.y * sh
            let bw = box.w * sw - 3, bh = box.h * sh - 3
            let hot = box.key == "e"
            p.poly([pt(bx + 2, by + 2), pt(bx + bw, by + 2), pt(bx + bw, by + bh), pt(bx + 2, by + bh)],
                   hot ? Shop.ochre.lt(0.42) : Shop.paperWarm.dk(0.10))
            penEdge(p, [pt(bx + 2, by + 2), pt(bx + bw, by + 2), pt(bx + bw, by + bh), pt(bx + 2, by + bh)],
                    weight: 1.8, colour: Shop.oakDark.al(0.8), seed: rng.next())
            label(p, box.label, at: bx + bw / 2, by + bh / 2 + 6,
                  size: max(8, min(20, bh * 0.44)), colour: Shop.black, face: "Georgia", align: .centre)
        }
        label(p, "the largest box in the case", at: x0 + 250, y0 + 300, size: 18,
              colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    case 1:
        let x0 = 110.0, y0 = 300.0, w = 1100.0, h = 300.0
        p.poly([pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + h), pt(x0, y0 + h)], Shop.brass)
        grainRun(p, pathOf([pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + h), pt(x0, y0 + h)]),
                 count: 260, length: 80, weight: 1.3, spread: 0.05, angle: 0,
                 colour: Shop.brassLight.al(0.36), seed: rng.next())
        let text = "NICK UP"
        var cursor = x0 + (w - measureLine(text, f, size: 150)) / 2
        for ch in text.reversed() {
            let s = String(ch)
            if s == " " { cursor += 50; continue }
            guard let m = Forge.metal(s, f) else { continue }
            let adv = m.adv * 150 / EmBox.unit
            p.poly([pt(cursor + 2, y0 + 40), pt(cursor + adv - 2, y0 + 40),
                    pt(cursor + adv - 2, y0 + h - 40), pt(cursor + 2, y0 + h - 40)], Shop.lead)
            p.poly([pt(cursor + 4, y0 + h - 74), pt(cursor + adv - 4, y0 + h - 74),
                    pt(cursor + adv - 4, y0 + h - 58), pt(cursor + 4, y0 + h - 58)],
                   Shop.leadDark.dk(0.4))
            _ = setSort(p, s, f, size: 150, x: cursor, y: y0 + 128,
                        colour: Shop.leadDark.dk(0.42), counterTone: Shop.antimony.lt(0.2),
                        coverage: 1.0, seed: rng.next(), turned: true)
            cursor += adv
        }
        penEdge(p, [pt(x0, y0), pt(x0 + w, y0), pt(x0 + w, y0 + h), pt(x0, y0 + h)],
                weight: 5, colour: Shop.brassDark.dk(0.5), seed: rng.next())
        label(p, "the nick faces you, and the letter does not", at: p.w / 2, y0 + h + 60,
              size: 20, colour: Shop.sepia, face: "Georgia-Italic", align: .centre)
    case 2:
        let em = 220.0
        var y = 240.0
        for row in Tables.spaces.prefix(6) {
            let w = em * row.ems
            p.poly([pt(260, y), pt(260 + w, y), pt(260 + w, y + 66), pt(260, y + 66)], Shop.leadLight)
            crossHatch(p, pathOf([pt(260, y), pt(260 + w, y), pt(260 + w, y + 66), pt(260, y + 66)]),
                       depth: 2, spacing: 7, colour: Shop.lead.al(0.5), seed: rng.next())
            penEdge(p, [pt(260, y), pt(260 + w, y), pt(260 + w, y + 66), pt(260, y + 66)],
                    weight: 2.6, colour: Shop.leadDark, seed: rng.next())
            label(p, row.name, at: 244, y + 44, size: 20, colour: Shop.black,
                  face: "Georgia-Bold", align: .right)
            y += 92
        }
        pen(p, [pt(700, 220), pt(700, 800)], weight: 3.0, colour: Shop.vermilion,
            wobble: 0.5, taper: false, seed: rng.next())
        label(p, "the measure", at: 720, 250, size: 20, colour: Shop.vermilion.dk(0.2),
              face: "Georgia-Italic", align: .left)
        label(p, "swap spaces until the line comes exactly to it", at: 720, 286, size: 18,
              colour: Shop.blackSoft, face: "Georgia", align: .left)
    default:
        let sheetQuad = [pt(300, 160), pt(1020, 150), pt(1030, 800), pt(306, 812)]
        p.poly(sheetQuad.map { pt(Double($0.x) + 18, Double($0.y) + 22) }, Shop.black.al(0.30))
        p.poly(sheetQuad, Shop.rag)
        penEdge(p, sheetQuad, weight: 2.4, colour: Shop.blackPale, seed: rng.next())
        drawOrnament(p, "fleuron", cx: 664, cy: 300, scale: 0.52, ink: Shop.vermilion,
                     paper: Shop.rag, seed: rng.next())
        inkedLine(p, "A FINE PULL", f, size: 76, x: 664, y: 480, colour: Shop.black,
                  paper: Shop.rag, align: .centre, coverage: 1.0, seed: rng.next())
        inkedLine(p, "and it goes in the book", Foundry.face("italic"), size: 46, x: 664, y: 560,
                  colour: Shop.black, paper: Shop.rag, align: .centre, coverage: 0.98, seed: rng.next())
        pen(p, [pt(420, 610), pt(910, 610)], weight: 2.4, colour: Shop.vermilion,
            wobble: 0.5, taper: true, seed: rng.next())
        drawOrnament(p, "laurel", cx: 664, cy: 700, scale: 0.44, ink: Shop.black,
                     paper: Shop.rag, seed: rng.next())
    }
    grit(p, pathOf([pt(0, 0), pt(p.w, 0), pt(p.w, p.h), pt(0, p.h)]), density: 0.00018,
         sizeMin: 0.4, sizeMax: 1.5, colour: Shop.sepia, seed: rng.next())
    p.write(dir, "ob_\(index)")
}

func commissionPlate(_ c: Commission, dir: String) {
    let p = Sheet(1060, 1420)
    p.light = 2.34
    var rng = Quoin(seedOf("cm-" + c.key))
    let stock = Papers.find(c.paperKey)
    let tone = paperTone(stock.tone)
    let face = Foundry.face(c.faceKey)
    let ink = inkTone(Inks.find(c.inkKey).tone)
    let second = c.secondInk.map { inkTone(Inks.find($0).tone) }

    layStock(p, seed: seedOf("cmgnd-" + c.key), tone: Shop.stoneTop.dk(0.34), laid: false)
    p.flipTopDown()
    washBand(p, from: 0, to: 1420, Shop.stoneDark, strength: 0.36, seed: rng.next())
    grit(p, pathOf([pt(0, 0), pt(1060, 0), pt(1060, 1420), pt(0, 1420)]), density: 0.0012,
         sizeMin: 0.4, sizeMax: 2.0, colour: Shop.stoneDark, seed: rng.next())

    let ragged = stock.key == "deckle" || stock.key == "rag" || stock.key == "gampi"
    let jag = ragged ? 14.0 : 2.0
    var edge: [CGPoint] = []
    for i in 0...24 { edge.append(pt(90 + Double(i) * 36, 100 + rng.signed() * jag)) }
    for i in 0...30 { edge.append(pt(954 + rng.signed() * jag, 100 + Double(i) * 40)) }
    for i in stride(from: 24, through: 0, by: -1) { edge.append(pt(90 + Double(i) * 36, 1300 + rng.signed() * jag)) }
    for i in stride(from: 30, through: 0, by: -1) { edge.append(pt(90 + rng.signed() * jag, 100 + Double(i) * 40)) }
    p.poly(edge.map { pt(Double($0.x) + 20, Double($0.y) + 26) }, Shop.black.al(0.44))
    p.poly(edge, tone)
    let sheetPath = pathOf(edge)
    p.clip(sheetPath) {
        if stock.key == "laid" {
            var y = 100.0
            while y < 1300 { p.rect(88, y, 870, 1.2, tone.dk(0.09).al(0.46)); y += 7.6 }
        }
        if stock.smoothness < 0.5 {
            grainRun(p, sheetPath, count: 1100, length: 20, weight: 1.1, spread: 3.14,
                     colour: tone.dk(0.14).al(0.44), seed: rng.next())
        }
        washBand(p, from: 100, to: 340, tone.lt(0.32), strength: 0.18, seed: rng.next())
    }

    let coverage = min(1.06, 0.80 + (1 - stock.absorbency) * 0.28)
    let ornInk = second ?? ink
    drawOrnament(p, c.ornamentKey, cx: 522, cy: 268, scale: 0.42, ink: ornInk.al(0.94),
                 paper: tone, seed: rng.next())

    pen(p, [pt(190, 380), pt(856, 380)], weight: 3.0, colour: ink.al(0.9),
        wobble: 0.6, taper: true, seed: rng.next())

    var y = 500.0
    let sizes: [Double] = c.copy.count > 2 ? [1.0, 0.72, 0.60, 0.52] : [1.0, 0.70]
    for (i, line) in c.copy.enumerated() {
        let scale = sizes[min(i, sizes.count - 1)]
        var size = Double(c.size) * 2.2 * scale
        while measureLine(line, face, size: size) > 700 { size *= 0.94 }
        let colour = (i == 1 && second != nil) ? second! : ink
        setLine(p, line, face, size: size, x: 522, y: y + size * 0.72,
                colour: colour.al(min(1.0, coverage)), counterTone: tone,
                coverage: coverage, align: .centre, seed: rng.next())
        y += size * 1.34 + 26
    }

    pen(p, [pt(250, min(1180.0, y + 40)), pt(796, min(1180.0, y + 40))], weight: 2.0,
        colour: ink.al(0.8), wobble: 0.5, taper: true, seed: rng.next())
    drawOrnament(p, c.ornamentKey, cx: 522, cy: min(1250.0, y + 130), scale: 0.26,
                 ink: ink.al(0.86), paper: tone, seed: rng.next())

    if stock.absorbency > 0.78 {
        p.clip(sheetPath) {
            grit(p, sheetPath, density: 0.0004, sizeMin: 0.5, sizeMax: 2.2,
                 colour: ink.al(0.22), seed: rng.next())
        }
    }
    penEdge(p, edge, weight: 2.2, colour: Shop.blackSoft.al(0.6), seed: rng.next())

    label(p, c.name.uppercased(), at: 530, 1364, size: 22, colour: Shop.paper,
          face: "Georgia-Bold", align: .centre, tracking: 5)
    label(p, "\(face.name)  \(c.size) point  \(Int(c.measurePicas)) picas  \(stock.name)",
          at: 530, 1396, size: 15, colour: Shop.paperGrey.dk(0.22),
          face: "Georgia-Italic", align: .centre)
    p.write(dir, "cm_" + c.key)
}
