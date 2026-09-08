import Foundation
import CoreGraphics

let keyLight = Ink(r: 1.000, g: 0.933, b: 0.784)
let deepVoid = Ink(r: 0.035, g: 0.031, b: 0.027)

func litBy(_ base: Ink, _ level: Double) -> Ink {
    let k = max(0.0, min(1.0, level))
    if k >= 0.50 { return base.mix(keyLight, (k - 0.50) * 1.36) }
    return base.mix(deepVoid, (0.50 - k) * 1.70)
}

func rimRuns(_ pts: [CGPoint], light: Double, threshold: Double = 0.10) -> [[CGPoint]] {
    guard pts.count > 3 else { return [] }
    var kept: [Int] = []
    for i in 0..<pts.count {
        let a = pts[i], b = pts[(i + 1) % pts.count]
        let ang = atan2(Double(b.y - a.y), Double(b.x - a.x))
        if cos(ang + .pi / 2 - light) > threshold { kept.append(i) }
    }
    guard !kept.isEmpty else { return [] }
    var runs: [[CGPoint]] = []
    var current: [CGPoint] = []
    var previous = -99
    for i in kept {
        if i == previous + 1 || current.isEmpty { current.append(pts[i]) }
        else { if current.count > 1 { runs.append(current) }; current = [pts[i]] }
        previous = i
    }
    if current.count > 1 { runs.append(current) }
    return runs
}

func moulded(_ p: Sheet, _ outline: [CGPoint], base: Ink, light: Double,
             hotAt: Double, seed: UInt64, bands: Int = 60, grain: Bool = true,
             along: Double = 0) {
    guard outline.count > 3 else { return }
    p.poly(outline, base.mix(deepVoid, 0.55))
    let body = pathOf(outline)
    p.clip(body) {
        let box = body.boundingBox
        for s in 0..<bands {
            let u0 = Double(s) / Double(bands)
            let u1 = Double(s + 1) / Double(bands)
            let mid = (u0 + u1) / 2
            let curve = cos((mid - hotAt) * 2.58)
            let level = max(0.0, min(1.0, 0.08 + max(0.0, curve) * 0.88))
            let x0 = Double(box.minX) + Double(box.width) * u0
            let x1 = Double(box.minX) + Double(box.width) * u1
            p.poly([pt(x0 - 1.2, Double(box.minY) - 4), pt(x1 + 1.2, Double(box.minY) - 4),
                    pt(x1 + 1.2, Double(box.maxY) + 4), pt(x0 - 1.2, Double(box.maxY) + 4)],
                   litBy(base, level))
        }
        if grain {
            var g = Quoin(seed &+ 71)
            for _ in 0..<Int(Double(box.width) * 1.4) {
                let x = Double(box.minX) + g.d() * Double(box.width)
                let y = Double(box.minY) + g.d() * Double(box.height)
                let dark = g.chance(0.5)
                let len = g.r(10, 48)
                pen(p, [pt(x, y), pt(x + cos(along) * len, y + sin(along) * len)],
                    weight: g.r(1.0, 3.2),
                    colour: (dark ? base.mix(deepVoid, g.r(0.18, 0.52))
                             : base.mix(keyLight, g.r(0.08, 0.34))).al(g.r(0.16, 0.46)),
                    wobble: 0.4, taper: true, seed: g.next())
            }
        }
    }
    for run in rimRuns(outline, light: light) {
        pen(p, run, weight: 7.0, colour: base.mix(keyLight, 0.70).al(0.76),
            wobble: 0.4, taper: true, seed: seed &+ 301)
    }
    for run in rimRuns(Array(outline.reversed()), light: light + .pi) {
        pen(p, run, weight: 4.4, colour: deepVoid.al(0.74),
            wobble: 0.4, taper: true, seed: seed &+ 303)
    }
}

func engraved(_ p: Sheet, _ a: CGPoint, _ b: CGPoint, weight: Double, light: Double, seed: UInt64) {
    let ang = atan2(Double(b.y - a.y), Double(b.x - a.x))
    let nx = -sin(ang), ny = cos(ang)
    let side = cos(ang + .pi / 2 - light) > 0 ? -1.0 : 1.0
    pen(p, [a, b], weight: weight, colour: deepVoid.al(0.82), wobble: 0.3, taper: false, seed: seed)
    pen(p, [pt(Double(a.x) + nx * weight * side, Double(a.y) + ny * weight * side),
            pt(Double(b.x) + nx * weight * side, Double(b.y) + ny * weight * side)],
        weight: weight * 0.72, colour: keyLight.al(0.54), wobble: 0.3, taper: false, seed: seed &+ 7)
}

func buildIcon(dir: String) {
    let held = sheetScale
    sheetScale = 1.0
    let p = Sheet(1024, 1024)
    p.fillAll(Ink(r: 0.047, g: 0.043, b: 0.039))
    p.flipTopDown()
    let light = 3.82
    var rng = Quoin(seedOf("composingstick-icon"))

    if let g = CGGradient(colorsSpace: shopSpace,
                          colors: [cg(Ink(r: 0.310, g: 0.259, b: 0.180)),
                                   cg(Ink(r: 0.106, g: 0.086, b: 0.063)),
                                   cg(Ink(r: 0.022, g: 0.018, b: 0.014))] as CFArray,
                          locations: [0, 0.44, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 220, y: 160), startRadius: 0,
                                 endCenter: CGPoint(x: 400, y: 430), endRadius: 990,
                                 options: [.drawsAfterEndLocation])
    }
    for _ in 0..<2200 {
        p.disc(rng.d() * 1024, rng.d() * 1024, rng.r(0.5, 2.0),
               Ink(r: 1, g: 0.94, b: 0.80).al(rng.r(0.005, 0.028)))
    }

    let ang = -0.315
    let dx = cos(ang), dy = sin(ang)
    let nx = -dy, ny = dx
    func axis(_ t: Double, _ u: Double) -> CGPoint {
        pt(-250 + dx * t + nx * u, 706 + dy * t + ny * u)
    }

    let stoneQuad = [pt(-80, 470), pt(1104, 190), pt(1104, 1104), pt(-80, 1104)]
    moulded(p, stoneQuad, base: Ink(r: 0.204, g: 0.188, b: 0.176), light: light,
            hotAt: 0.18, seed: 601, bands: 46, along: ang)

    let depth = 470.0
    var shadow: [CGPoint] = []
    for i in 0...24 {
        let q = axis(Double(i) / 24 * 1700, depth)
        shadow.append(pt(Double(q.x) + 66, Double(q.y) + 52 + rng.signed() * 12))
    }
    for i in stride(from: 24, through: 0, by: -1) {
        let q = axis(Double(i) / 24 * 1700, -60)
        shadow.append(pt(Double(q.x) + 96, Double(q.y) + 44 + rng.signed() * 9))
    }
    p.poly(shadow, Ink(r: 0.008, g: 0.006, b: 0.005).al(0.80))

    let brass = Ink(r: 0.729, g: 0.573, b: 0.239)
    let brassBack = Ink(r: 0.584, g: 0.443, b: 0.176)
    let steelBed = Ink(r: 0.361, g: 0.376, b: 0.392)

    let wallLift = 268.0
    let farA = axis(-200, 0), farB = axis(1760, 0)
    let wallTopA = pt(Double(farA.x) - 40, Double(farA.y) - wallLift)
    let wallTopB = pt(Double(farB.x) - 40, Double(farB.y) - wallLift)
    let backWall = [wallTopA, wallTopB, farB, farA]
    moulded(p, backWall, base: brassBack, light: light, hotAt: 0.22, seed: 701,
            bands: 72, along: ang)
    for _ in 0..<90 {
        let t = rng.r(-180, 1740)
        let a = pt(Double(axis(t, 0).x) - 40, Double(axis(t, 0).y) - rng.r(20, wallLift - 20))
        pen(p, [a, pt(Double(a.x) + rng.r(60, 260), Double(a.y) + rng.r(-18, 18))],
            weight: rng.r(1.6, 5.0), colour: keyLight.al(rng.r(0.04, 0.20)),
            wobble: 0.4, taper: true, seed: rng.next())
    }

    let bed = [farA, farB, axis(1760, depth), axis(-200, depth)]
    moulded(p, bed, base: steelBed, light: light, hotAt: 0.28, seed: 711, bands: 54, along: ang)

    let nearLift = 208.0
    let nearA = axis(-200, depth), nearB = axis(1760, depth)
    let railTopA = pt(Double(nearA.x) - 28, Double(nearA.y) - nearLift)
    let railTopB = pt(Double(nearB.x) - 28, Double(nearB.y) - nearLift)
    let railFace = [railTopA, railTopB, pt(Double(nearB.x) + 34, Double(nearB.y) + 150),
                    pt(Double(nearA.x) + 34, Double(nearA.y) + 150)]

    let rows = 3
    let bodyDepth = depth / Double(rows)
    let lift = 132.0
    for row in 0..<rows {
        let u0 = Double(row) * bodyDepth + 20
        let u1 = u0 + bodyDepth - 42
        p.poly([axis(-260, u0 - 20), axis(1780, u0 - 20), axis(1780, u0 + 2), axis(-260, u0 + 2)],
               deepVoid.al(0.72))
        var t = -230.0
        var k = 0
        while t < 1760 {
            let w = rng.r(118, 168)
            let sortTone = Ink(r: 0.216, g: 0.227, b: 0.247).dk(rng.r(0.0, 0.10))
            func up(_ q: CGPoint) -> CGPoint { pt(Double(q.x) - 34, Double(q.y) - lift) }
            let faceTop = [up(axis(t, u0)), up(axis(t + w, u0)), up(axis(t + w, u1)), up(axis(t, u1))]
            let front = [up(axis(t, u1)), up(axis(t + w, u1)), axis(t + w, u1), axis(t, u1)]
            moulded(p, front, base: sortTone, light: light, hotAt: 0.24,
                    seed: 800 + UInt64(row * 40 + k), bands: 90, grain: false, along: ang)
            let nickA = up(axis(t + 14, u1))
            let nickB = up(axis(t + w - 14, u1))
            engraved(p, pt(Double(nickA.x), Double(nickA.y) + 64),
                     pt(Double(nickB.x), Double(nickB.y) + 64),
                     weight: 11, light: light, seed: 900 + UInt64(row * 40 + k))
            moulded(p, faceTop, base: sortTone.lt(0.30), light: light, hotAt: 0.26,
                    seed: 1000 + UInt64(row * 40 + k), bands: 90, grain: false, along: ang)
            let letters = "ABCEGHKMNOPRSTUW"
            let idx = Int(rng.next() % UInt64(letters.count))
            let ch = String(Array(letters)[idx])
            let face = Foundry.face(row % 2 == 0 ? "clarendon" : "caslon")
            let glyphSize = min(w * 1.16, bodyDepth * 1.24)
            p.clip(pathOf(faceTop)) {
                _ = setSort(p, ch, face, size: glyphSize,
                            x: Double(up(axis(t + w * 0.16, (u0 + u1) * 0.5)).x),
                            y: Double(up(axis(t + w * 0.16, (u0 + u1) * 0.5)).y) + glyphSize * 0.30,
                            colour: deepVoid.al(0.90), counterTone: sortTone.mix(keyLight, 0.52),
                            coverage: 1.0, seed: rng.next())
            }
            for run in rimRuns(faceTop, light: light) {
                pen(p, run, weight: 6.0, colour: keyLight.al(0.50), wobble: 0.3,
                    taper: true, seed: rng.next())
            }
            for run in rimRuns(front, light: light) {
                pen(p, run, weight: 4.4, colour: keyLight.al(0.34), wobble: 0.3,
                    taper: true, seed: rng.next())
            }
            t += w + rng.r(5, 11)
            k += 1
        }
    }

    moulded(p, railFace, base: brass, light: light, hotAt: 0.20, seed: 1201,
            bands: 86, along: ang)
    for k in 0...26 {
        let t = -220 + Double(k) * 78
        let tall = k % 4 == 0 ? 92.0 : 52.0
        let a = pt(Double(axis(t, depth).x) - 28, Double(axis(t, depth).y) - nearLift + 26)
        engraved(p, a, pt(Double(a.x) + 6, Double(a.y) + tall), weight: 10, light: light,
                 seed: 1300 + UInt64(k))
    }
    for _ in 0..<110 {
        let t = rng.r(-200, 1740)
        let a = pt(Double(axis(t, depth).x) - 28, Double(axis(t, depth).y) - nearLift + rng.r(8, 170))
        pen(p, [a, pt(Double(a.x) + rng.r(70, 300), Double(a.y) + rng.r(-20, 20))],
            weight: rng.r(2.0, 6.0), colour: keyLight.al(rng.r(0.05, 0.26)),
            wobble: 0.4, taper: true, seed: rng.next())
    }

    let kneeT = 1080.0
    let knee = [pt(Double(axis(kneeT, -60).x) - 52, Double(axis(kneeT, -60).y) - wallLift - 60),
                pt(Double(axis(kneeT + 190, -60).x) - 52, Double(axis(kneeT + 190, -60).y) - wallLift - 60),
                pt(Double(axis(kneeT + 190, depth + 40).x) + 40, Double(axis(kneeT + 190, depth + 40).y) + 160),
                pt(Double(axis(kneeT, depth + 40).x) + 40, Double(axis(kneeT, depth + 40).y) + 160)]
    moulded(p, knee, base: brass.lt(0.08), light: light, hotAt: 0.18, seed: 1401,
            bands: 64, along: ang)

    let knobC = axis(kneeT + 96, 150)
    let knobX = min(896.0, Double(knobC.x) - 48), knobY = Double(knobC.y) - wallLift - 96
    var knobPts: [CGPoint] = []
    for i in 0..<40 {
        let a = Double(i) / 40 * 2 * .pi
        let notch = 1.0 + 0.07 * cos(a * 14)
        knobPts.append(pt(knobX + cos(a) * 168 * notch, knobY + sin(a) * 108 * notch))
    }
    moulded(p, knobPts, base: brass.lt(0.16), light: light, hotAt: 0.18, seed: 1501,
            bands: 74, along: ang)
    var innerKnob: [CGPoint] = []
    for i in 0..<30 {
        let a = Double(i) / 30 * 2 * .pi
        innerKnob.append(pt(knobX + cos(a) * 74, knobY + sin(a) * 48))
    }
    moulded(p, innerKnob, base: brass.lt(0.24), light: light, hotAt: 0.20,
            seed: 1503, bands: 44, grain: false, along: ang)
    for run in rimRuns(knobPts, light: light) {
        pen(p, run, weight: 13.0, colour: keyLight.al(0.86), wobble: 0.3, taper: true, seed: 1505)
    }
    var gleam: [CGPoint] = []
    for i in 0...16 {
        let a = -2.55 + Double(i) / 16 * 1.15
        gleam.append(pt(knobX + cos(a) * 132, knobY + sin(a) * 86))
    }
    pen(p, gleam, weight: 16, colour: keyLight.al(0.62), wobble: 0.4, taper: true, seed: 1521)

    for run in rimRuns(backWall, light: light) {
        pen(p, run, weight: 13.0, colour: keyLight.al(0.78), wobble: 0.3, taper: true, seed: 1601)
    }
    for run in rimRuns(railFace, light: light) {
        pen(p, run, weight: 12.0, colour: keyLight.al(0.72), wobble: 0.3, taper: true, seed: 1603)
    }

    if let g = CGGradient(colorsSpace: shopSpace,
                          colors: [cg(Ink(r: 1.0, g: 0.808, b: 0.416).al(0.24)),
                                   cg(Ink(r: 1.0, g: 0.7, b: 0.3).al(0))] as CFArray,
                          locations: [0, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 300, y: 400), startRadius: 0,
                                 endCenter: CGPoint(x: 300, y: 400), endRadius: 560, options: [])
    }
    if let g = CGGradient(colorsSpace: shopSpace,
                          colors: [cg(Ink(r: 0, g: 0, b: 0, a: 0)),
                                   cg(Ink(r: 0, g: 0, b: 0, a: 0.46))] as CFArray,
                          locations: [0.46, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 440, y: 430), startRadius: 0,
                                 endCenter: CGPoint(x: 440, y: 430), endRadius: 880,
                                 options: [.drawsAfterEndLocation])
    }
    p.writePNG(dir, "AppIcon-1024")
    sheetScale = held
}
