import SwiftUI

struct CaseMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            ctx.stroke(Path(CGRect(x: w * 0.10, y: h * 0.20, width: w * 0.80, height: h * 0.60)),
                       with: .color(color), lineWidth: w * 0.075)
            var grid = Path()
            for k in 1..<4 {
                let x = w * (0.10 + 0.80 * Double(k) / 4)
                grid.move(to: CGPoint(x: x, y: h * 0.20))
                grid.addLine(to: CGPoint(x: x, y: h * 0.80))
            }
            grid.move(to: CGPoint(x: w * 0.10, y: h * 0.50))
            grid.addLine(to: CGPoint(x: w * 0.90, y: h * 0.50))
            ctx.stroke(grid, with: .color(color.opacity(0.72)), lineWidth: w * 0.045)
            ctx.fill(Path(CGRect(x: w * 0.32, y: h * 0.24, width: w * 0.16, height: h * 0.22)),
                     with: .color(color.opacity(0.85)))
        }
        .frame(width: size, height: size)
    }
}

struct OrderMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            var sheet = Path()
            sheet.move(to: CGPoint(x: w * 0.20, y: h * 0.12))
            sheet.addLine(to: CGPoint(x: w * 0.64, y: h * 0.12))
            sheet.addLine(to: CGPoint(x: w * 0.82, y: h * 0.32))
            sheet.addLine(to: CGPoint(x: w * 0.82, y: h * 0.88))
            sheet.addLine(to: CGPoint(x: w * 0.20, y: h * 0.88))
            sheet.closeSubpath()
            ctx.stroke(sheet, with: .color(color), style: StrokeStyle(lineWidth: w * 0.075, lineJoin: .round))
            var fold = Path()
            fold.move(to: CGPoint(x: w * 0.64, y: h * 0.12))
            fold.addLine(to: CGPoint(x: w * 0.64, y: h * 0.32))
            fold.addLine(to: CGPoint(x: w * 0.82, y: h * 0.32))
            ctx.stroke(fold, with: .color(color.opacity(0.7)), lineWidth: w * 0.05)
            for k in 0..<3 {
                let y = h * (0.48 + Double(k) * 0.14)
                ctx.fill(Path(CGRect(x: w * 0.31, y: y, width: w * (k == 2 ? 0.24 : 0.40), height: h * 0.055)),
                         with: .color(color.opacity(0.75)))
            }
        }
        .frame(width: size, height: size)
    }
}

struct SortMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            var body = Path()
            body.move(to: CGPoint(x: w * 0.24, y: h * 0.26))
            body.addLine(to: CGPoint(x: w * 0.70, y: h * 0.14))
            body.addLine(to: CGPoint(x: w * 0.82, y: h * 0.76))
            body.addLine(to: CGPoint(x: w * 0.34, y: h * 0.90))
            body.closeSubpath()
            ctx.stroke(body, with: .color(color), style: StrokeStyle(lineWidth: w * 0.07, lineJoin: .round))
            var top = Path()
            top.move(to: CGPoint(x: w * 0.24, y: h * 0.26))
            top.addLine(to: CGPoint(x: w * 0.14, y: h * 0.14))
            top.addLine(to: CGPoint(x: w * 0.60, y: h * 0.04))
            top.addLine(to: CGPoint(x: w * 0.70, y: h * 0.14))
            top.closeSubpath()
            ctx.fill(top, with: .color(color.opacity(0.55)))
            ctx.fill(Path(CGRect(x: w * 0.30, y: h * 0.56, width: w * 0.44, height: h * 0.07)),
                     with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

struct BookMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            ctx.stroke(Path(CGRect(x: w * 0.22, y: h * 0.12, width: w * 0.60, height: h * 0.76)),
                       with: .color(color), lineWidth: w * 0.07)
            ctx.fill(Path(CGRect(x: w * 0.14, y: h * 0.12, width: w * 0.08, height: h * 0.76)),
                     with: .color(color))
            for k in 0..<3 {
                let y = h * (0.30 + Double(k) * 0.18)
                ctx.fill(Path(CGRect(x: w * 0.32, y: y, width: w * (k == 1 ? 0.28 : 0.40), height: h * 0.055)),
                         with: .color(color.opacity(0.7)))
            }
        }
        .frame(width: size, height: size)
    }
}

struct GaugeMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            ctx.stroke(Path(CGRect(x: w * 0.08, y: h * 0.34, width: w * 0.84, height: h * 0.32)),
                       with: .color(color), lineWidth: w * 0.07)
            for k in 0..<7 {
                let x = w * (0.16 + Double(k) * 0.115)
                let tall = k % 2 == 0 ? 0.18 : 0.10
                var tick = Path()
                tick.move(to: CGPoint(x: x, y: h * 0.66))
                tick.addLine(to: CGPoint(x: x, y: h * (0.66 - tall)))
                ctx.stroke(tick, with: .color(color.opacity(0.85)), lineWidth: w * 0.045)
            }
        }
        .frame(width: size, height: size)
    }
}

struct BackChev: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            var path = Path()
            path.move(to: CGPoint(x: w * 0.64, y: h * 0.16))
            path.addLine(to: CGPoint(x: w * 0.32, y: h * 0.50))
            path.addLine(to: CGPoint(x: w * 0.64, y: h * 0.84))
            ctx.stroke(path, with: .color(color),
                       style: StrokeStyle(lineWidth: w * 0.13, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct CrossMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            var path = Path()
            path.move(to: CGPoint(x: w * 0.22, y: h * 0.22))
            path.addLine(to: CGPoint(x: w * 0.78, y: h * 0.78))
            path.move(to: CGPoint(x: w * 0.78, y: h * 0.22))
            path.addLine(to: CGPoint(x: w * 0.22, y: h * 0.78))
            ctx.stroke(path, with: .color(color),
                       style: StrokeStyle(lineWidth: w * 0.12, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct TickMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            var path = Path()
            path.move(to: CGPoint(x: w * 0.18, y: h * 0.54))
            path.addLine(to: CGPoint(x: w * 0.42, y: h * 0.76))
            path.addLine(to: CGPoint(x: w * 0.84, y: h * 0.24))
            ctx.stroke(path, with: .color(color),
                       style: StrokeStyle(lineWidth: w * 0.13, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct TurnMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            var arc = Path()
            arc.addArc(center: CGPoint(x: w * 0.5, y: h * 0.52), radius: w * 0.30,
                       startAngle: .degrees(30), endAngle: .degrees(290), clockwise: false)
            ctx.stroke(arc, with: .color(color), style: StrokeStyle(lineWidth: w * 0.11, lineCap: .round))
            var head = Path()
            head.move(to: CGPoint(x: w * 0.72, y: h * 0.60))
            head.addLine(to: CGPoint(x: w * 0.86, y: h * 0.74))
            head.addLine(to: CGPoint(x: w * 0.66, y: h * 0.82))
            head.closeSubpath()
            ctx.fill(head, with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

struct SearchMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, area in
            let w = Double(area.width), h = Double(area.height)
            ctx.stroke(Path(ellipseIn: CGRect(x: w * 0.16, y: h * 0.14, width: w * 0.52, height: h * 0.52)),
                       with: .color(color), lineWidth: w * 0.11)
            var stem = Path()
            stem.move(to: CGPoint(x: w * 0.62, y: h * 0.62))
            stem.addLine(to: CGPoint(x: w * 0.86, y: h * 0.86))
            ctx.stroke(stem, with: .color(color), style: StrokeStyle(lineWidth: w * 0.13, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}
