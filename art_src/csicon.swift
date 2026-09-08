import Foundation
import CoreGraphics

let keyLight = Ink(r: 1.000, g: 0.945, b: 0.812)
let deepVoid = Ink(r: 0.031, g: 0.027, b: 0.024)

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
    var runs: [[Int]] = []
    var current: [Int] = []
    var previous = -99
    for i in kept {
        if i == previous + 1 || current.isEmpty { current.append(i) }
        else { runs.append(current); current = [i] }
        previous = i
    }
    runs.append(current)
    if runs.count > 1, let head = runs.first?.first, let tail = runs.last?.last,
       head == 0, tail == pts.count - 1 {
        let first = runs.removeFirst()
        runs[runs.count - 1].append(contentsOf: first)
    }
    return runs.filter { $0.count > 1 }.map { $0.map { pts[$0] } }
}

func moulded(_ p: Sheet, _ outline: [CGPoint], base: Ink, light: Double,
             hotAt: Double, seed: UInt64, bands: Int = 60, grain: Bool = true,
             along: Double = 0, grainRate: Double = 1.4) {
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
            for _ in 0..<Int(Double(box.width) * grainRate) {
                let x = Double(box.minX) + g.d() * Double(box.width)
                let y = Double(box.minY) + g.d() * Double(box.height)
                let dark = g.chance(0.5)
                let len = g.r(9, 44)
                pen(p, [pt(x, y), pt(x + cos(along) * len, y + sin(along) * len)],
                    weight: g.r(1.0, 3.0),
                    colour: (dark ? base.mix(deepVoid, g.r(0.18, 0.52))
                             : base.mix(keyLight, g.r(0.08, 0.34))).al(g.r(0.16, 0.44)),
                    wobble: 0.4, taper: true, seed: g.next())
            }
        }
    }
    for run in rimRuns(outline, light: light) {
        pen(p, run, weight: 7.0, colour: base.mix(keyLight, 0.72).al(0.74),
            wobble: 0.4, taper: true, seed: seed &+ 301)
    }
    for run in rimRuns(Array(outline.reversed()), light: light + .pi) {
        pen(p, run, weight: 4.4, colour: deepVoid.al(0.72),
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

func blend(_ a: CGPoint, _ b: CGPoint, _ t: Double) -> CGPoint {
    pt(Double(a.x) + (Double(b.x) - Double(a.x)) * t,
       Double(a.y) + (Double(b.y) - Double(a.y)) * t)
}

func quadAt(_ q: [CGPoint], _ u: Double, _ v: Double) -> CGPoint {
    blend(blend(q[0], q[1], u), blend(q[3], q[2], u), v)
}

func shifted(_ pts: [CGPoint], _ dx: Double, _ dy: Double) -> [CGPoint] {
    pts.map { pt(Double($0.x) + dx, Double($0.y) + dy) }
}

func glyphRings(_ ch: String, _ f: TypeFace) -> ([[CGPoint]], [[CGPoint]], CGRect) {
    guard let m = Forge.metal(ch, f) else { return ([], [], .zero) }
    var minX = 1e9, maxX = -1e9, minY = 1e9, maxY = -1e9
    for ring in m.ink {
        for q in ring {
            minX = min(minX, Double(q.x)); maxX = max(maxX, Double(q.x))
            minY = min(minY, Double(q.y)); maxY = max(maxY, Double(q.y))
        }
    }
    guard maxX > minX, maxY > minY else { return ([], [], .zero) }
    return (m.ink, m.counters, CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY))
}

func reliefLetter(_ p: Sheet, _ ch: String, _ face: TypeFace, quad: [CGPoint],
                  body: Ink, light: Double, inset: Double, seed: UInt64) {
    let (ink, counters, box) = glyphRings(ch, face)
    guard !ink.isEmpty, box.width > 0 else { return }
    let span = 1 - inset * 2
    func map(_ q: CGPoint) -> CGPoint {
        let gx = (Double(q.x) - Double(box.minX)) / Double(box.width)
        let gy = (Double(q.y) - Double(box.minY)) / Double(box.height)
        return quadAt(quad, inset + (1 - gx) * span, inset + (1 - gy) * span)
    }
    let inkRings = ink.map { $0.map(map) }
    let holeRings = counters.map { $0.map(map) }
    let reach = 13.0
    let lx = cos(light) * reach, ly = sin(light) * reach
    let wet = Ink(r: 0.078, g: 0.070, b: 0.066)

    for ring in inkRings where ring.count > 2 { p.poly(shifted(ring, -lx, -ly), deepVoid) }
    for ring in holeRings where ring.count > 2 { p.poly(shifted(ring, -lx, -ly), body.mix(deepVoid, 0.26)) }
    for ring in inkRings where ring.count > 2 { p.poly(shifted(ring, lx * 0.78, ly * 0.78), body.mix(keyLight, 0.62)) }
    for ring in holeRings where ring.count > 2 { p.poly(shifted(ring, lx * 0.78, ly * 0.78), body.mix(deepVoid, 0.16)) }

    let letterPath = CGMutablePath()
    for ring in inkRings where ring.count > 2 { letterPath.addPath(pathOf(ring)) }
    let hot = quadAt(quad, 0.28, 0.24)
    p.clip(letterPath) {
        let bounds = letterPath.boundingBox
        if let g = CGGradient(colorsSpace: shopSpace,
                              colors: [cg(wet.mix(keyLight, 0.20)),
                                       cg(wet),
                                       cg(wet.mix(deepVoid, 0.60))] as CFArray,
                              locations: [0, 0.52, 1]) {
            p.ctx.drawRadialGradient(g, startCenter: hot, startRadius: 0,
                                     endCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                     endRadius: Double(max(bounds.width, bounds.height)) * 1.05,
                                     options: [.drawsAfterEndLocation])
        }
        var g = Quoin(seed &+ 909)
        for _ in 0..<Int(Double(bounds.width) * 0.9) {
            let x = Double(bounds.minX) + g.d() * Double(bounds.width)
            let y = Double(bounds.minY) + g.d() * Double(bounds.height)
            pen(p, [pt(x, y), pt(x + g.r(10, 40), y + g.r(-6, 6))], weight: g.r(0.9, 2.6),
                colour: keyLight.al(g.r(0.04, 0.16)),
                wobble: 0.3, taper: true, seed: g.next())
        }
    }
    for ring in inkRings where ring.count > 2 {
        for run in rimRuns(ring, light: light) {
            pen(p, run, weight: 3.0, colour: keyLight.al(0.34), wobble: 0.3, taper: true, seed: seed &+ 41)
        }
    }
    for ring in holeRings where ring.count > 2 {
        p.poly(ring, body.mix(deepVoid, 0.04))
        for run in rimRuns(Array(ring.reversed()), light: light) {
            pen(p, run, weight: 3.4, colour: deepVoid.al(0.70), wobble: 0.3, taper: true, seed: seed &+ 43)
        }
    }
}

func buildIcon(dir: String) {
    let held = sheetScale
    sheetScale = 1.0
    let p = Sheet(1024, 1024)
    p.fillAll(Ink(r: 0.043, g: 0.039, b: 0.035))
    p.flipTopDown()
    let light = 3.85
    var rng = Quoin(seedOf("composingstick-icon-stick"))

    if let g = CGGradient(colorsSpace: shopSpace,
                          colors: [cg(Ink(r: 0.318, g: 0.263, b: 0.180)),
                                   cg(Ink(r: 0.114, g: 0.090, b: 0.063)),
                                   cg(Ink(r: 0.024, g: 0.020, b: 0.016))] as CFArray,
                          locations: [0, 0.42, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 226, y: 168), startRadius: 0,
                                 endCenter: CGPoint(x: 420, y: 430), endRadius: 1010,
                                 options: [.drawsAfterEndLocation])
    }
    for _ in 0..<2400 {
        p.disc(rng.d() * 1024, rng.d() * 1024, rng.r(0.5, 2.0),
               Ink(r: 1, g: 0.94, b: 0.80).al(rng.r(0.005, 0.026)))
    }

    let stick = [pt(-70, 300), pt(1330, 140), pt(1392, 694), pt(-8, 1246)]
    func at(_ s: Double, _ v: Double) -> CGPoint { quadAt(stick, s, v) }
    func scaleAt(_ s: Double) -> Double { 1.06 - 0.40 * s }
    func lift(_ q: CGPoint, _ s: Double) -> CGPoint {
        let k = scaleAt(s)
        return pt(Double(q.x) - 52 * k, Double(q.y) - 268 * k)
    }

    let brass = Ink(r: 0.741, g: 0.580, b: 0.243)
    let brassBack = Ink(r: 0.573, g: 0.435, b: 0.169)
    let brassLip = Ink(r: 0.804, g: 0.643, b: 0.294)
    let metal = Ink(r: 0.318, g: 0.325, b: 0.345)

    var cast: [CGPoint] = []
    for i in 0...16 {
        let s = -0.16 + Double(i) / 16 * 1.32
        let q = at(s, 0.02)
        cast.append(pt(Double(q.x) + 96, Double(q.y) + 92 + rng.signed() * 10))
    }
    for i in stride(from: 16, through: 0, by: -1) {
        let s = -0.16 + Double(i) / 16 * 1.32
        let q = at(s, 1.12)
        cast.append(pt(Double(q.x) + 132, Double(q.y) + 110 + rng.signed() * 12))
    }
    for k in 0..<4 {
        let grow = Double(k) * 16
        p.poly(shifted(cast, grow * 0.5, grow), deepVoid.al(0.26))
    }

    let wallTopA = pt(Double(at(-0.20, 0.0).x) - 74, Double(at(-0.20, 0.0).y) - 348)
    let wallTopB = pt(Double(at(1.24, 0.0).x) - 34, Double(at(1.24, 0.0).y) - 218)
    let backWall = [wallTopA, wallTopB, at(1.24, 0.10), at(-0.20, 0.10)]
    moulded(p, backWall, base: brassBack, light: light, hotAt: 0.24, seed: 701,
            bands: 76, along: -0.16, grainRate: 1.1)
    for _ in 0..<120 {
        let s = rng.r(-0.18, 1.22)
        let base = at(s, 0.06)
        let a = pt(Double(base.x) - rng.r(20, 62), Double(base.y) - rng.r(24, 320))
        pen(p, [a, pt(Double(a.x) + rng.r(70, 300), Double(a.y) - rng.r(6, 34))],
            weight: rng.r(1.6, 5.2), colour: keyLight.al(rng.r(0.04, 0.20)),
            wobble: 0.4, taper: true, seed: rng.next())
    }

    let bed = [at(-0.20, 0.10), at(1.24, 0.10), at(1.24, 0.86), at(-0.20, 0.86)]
    moulded(p, bed, base: metal.dk(0.24), light: light, hotAt: 0.30, seed: 711,
            bands: 54, along: -0.16, grainRate: 0.8)

    let sorts: [(Double, Double, String)] = [(-0.14, 0.15, "T"), (0.18, 0.47, "E"), (0.50, 0.79, "S")]
    let face = Foundry.face("caslon")
    var slot: UInt64 = 0
    for (s0, s1, ch) in sorts {
        slot += 1
        let vB = 0.19, vF = 0.80
        let footBL = at(s0, vB), footBR = at(s1, vB)
        let footFR = at(s1, vF), footFL = at(s0, vF)
        let topBL = lift(footBL, s0), topBR = lift(footBR, s1)
        let topFR = lift(footFR, s1), topFL = lift(footFL, s0)
        let tone = metal.dk(Double(slot % 3) * 0.02)

        moulded(p, [topBR, footBR, footFR, topFR], base: tone.dk(0.30), light: light,
                hotAt: 0.86, seed: 800 + slot, bands: 40, grain: false, along: -0.16)
        moulded(p, [topBL, footBL, footFL, topFL], base: tone.lt(0.10), light: light,
                hotAt: 0.14, seed: 810 + slot, bands: 40, grain: false, along: -0.16)
        let front = [topFL, topFR, footFR, footFL]
        moulded(p, front, base: tone, light: light, hotAt: 0.22, seed: 820 + slot,
                bands: 72, along: -0.16, grainRate: 1.0)
        let nickA = blend(topFL, footFL, 0.46)
        let nickB = blend(topFR, footFR, 0.46)
        engraved(p, blend(nickA, nickB, 0.06), blend(nickA, nickB, 0.94),
                 weight: 15, light: light, seed: 830 + slot)

        let top = [topBL, topBR, topFR, topFL]
        moulded(p, top, base: tone.lt(0.30), light: light, hotAt: 0.26, seed: 840 + slot,
                bands: 74, along: -0.16, grainRate: 1.2)
        reliefLetter(p, ch, face, quad: top, body: tone.lt(0.34), light: light,
                     inset: 0.11, seed: 900 + slot)
        for run in rimRuns(top, light: light) {
            pen(p, run, weight: 6.6, colour: keyLight.al(0.56), wobble: 0.3, taper: true,
                seed: 950 + slot)
        }
        for run in rimRuns(front, light: light) {
            pen(p, run, weight: 4.6, colour: keyLight.al(0.34), wobble: 0.3, taper: true,
                seed: 960 + slot)
        }
    }

    let kneeTop = [pt(Double(lift(at(0.84, 0.02), 0.84).x), Double(lift(at(0.84, 0.02), 0.84).y) - 180),
                   pt(Double(lift(at(1.20, 0.02), 1.20).x), Double(lift(at(1.20, 0.02), 1.20).y) - 156),
                   at(1.20, 0.94), at(0.84, 0.94)]
    moulded(p, kneeTop, base: brass.lt(0.06), light: light, hotAt: 0.20, seed: 1401,
            bands: 70, along: -0.16, grainRate: 1.3)
    for k in 0..<7 {
        let u = 0.10 + Double(k) * 0.13
        let a = blend(kneeTop[0], kneeTop[3], u)
        let b = blend(kneeTop[1], kneeTop[2], u)
        engraved(p, blend(a, b, 0.10), blend(a, b, 0.62), weight: 8, light: light,
                 seed: 1410 + UInt64(k))
    }

    let lipA = at(-0.20, 0.86), lipB = at(1.24, 0.86)
    let railTop = [pt(Double(lipA.x) - 30, Double(lipA.y) - 148),
                   pt(Double(lipB.x) - 16, Double(lipB.y) - 96), lipB, lipA]
    moulded(p, railTop, base: brassLip, light: light, hotAt: 0.18, seed: 1201,
            bands: 86, along: -0.16, grainRate: 1.5)
    let railFace = [lipA, lipB, at(1.24, 1.30), at(-0.20, 1.30)]
    moulded(p, railFace, base: brass, light: light, hotAt: 0.30, seed: 1211,
            bands: 86, along: -0.16, grainRate: 1.5)
    for k in 0...30 {
        let s = -0.18 + Double(k) * 0.047
        let tall = k % 4 == 0 ? 118.0 : 66.0
        let a = at(s, 0.90)
        engraved(p, pt(Double(a.x), Double(a.y) + 16),
                 pt(Double(a.x) + 5, Double(a.y) + 16 + tall * scaleAt(s)),
                 weight: 11, light: light, seed: 1300 + UInt64(k))
    }
    for _ in 0..<150 {
        let s = rng.r(-0.18, 1.22)
        let a = at(s, rng.r(0.88, 1.24))
        pen(p, [a, pt(Double(a.x) + rng.r(80, 330), Double(a.y) - rng.r(4, 40))],
            weight: rng.r(2.0, 6.4), colour: keyLight.al(rng.r(0.05, 0.24)),
            wobble: 0.4, taper: true, seed: rng.next())
    }
    for run in rimRuns(railTop, light: light) {
        pen(p, run, weight: 13.0, colour: keyLight.al(0.80), wobble: 0.3, taper: true, seed: 1603)
    }
    for run in rimRuns(backWall, light: light) {
        pen(p, run, weight: 12.0, colour: keyLight.al(0.72), wobble: 0.3, taper: true, seed: 1601)
    }

    if let g = CGGradient(colorsSpace: shopSpace,
                          colors: [cg(Ink(r: 1.0, g: 0.824, b: 0.427).al(0.22)),
                                   cg(Ink(r: 1.0, g: 0.7, b: 0.3).al(0))] as CFArray,
                          locations: [0, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 250, y: 300), startRadius: 0,
                                 endCenter: CGPoint(x: 250, y: 300), endRadius: 620, options: [])
    }
    if let g = CGGradient(colorsSpace: shopSpace,
                          colors: [cg(Ink(r: 0, g: 0, b: 0, a: 0)),
                                   cg(Ink(r: 0, g: 0, b: 0, a: 0.50))] as CFArray,
                          locations: [0.44, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 440, y: 430), startRadius: 0,
                                 endCenter: CGPoint(x: 440, y: 430), endRadius: 880,
                                 options: [.drawsAfterEndLocation])
    }
    p.writePNG(dir, "AppIcon-1024")
    sheetScale = held
}
