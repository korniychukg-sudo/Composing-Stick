import SwiftUI

struct JobSpec {
    var key: String
    var title: String
    var client: String
    var brief: String
    var copy: [String]
    var faceKey: String
    var size: Int
    var measurePicas: Double
    var paperKey: String
    var inkKey: String
    var secondInk: String?
    var ornamentKey: String
    var constraint: Int
    var constraintName: String
    var constraintNote: String
    var isDaily: Bool

    static func from(_ c: Commission) -> JobSpec {
        JobSpec(key: c.key, title: c.name, client: c.client, brief: c.brief, copy: c.copy,
                faceKey: c.faceKey, size: c.size, measurePicas: c.measurePicas,
                paperKey: c.paperKey, inkKey: c.inkKey, secondInk: c.secondInk,
                ornamentKey: c.ornamentKey, constraint: 0, constraintName: "",
                constraintNote: "", isDaily: false)
    }

    static func from(_ j: DayJob) -> JobSpec {
        JobSpec(key: "day\(j.day)", title: "Job of the day", client: j.client,
                brief: j.constraintNote, copy: [j.line], faceKey: j.faceKey, size: j.size,
                measurePicas: j.measurePicas, paperKey: j.paperKey, inkKey: j.inkKey,
                secondInk: j.constraint == 5 ? "vermilion" : nil, ornamentKey: j.ornamentKey,
                constraint: j.constraint, constraintName: j.constraintName,
                constraintNote: j.constraintNote, isDaily: true)
    }
}

struct StickFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { value = nextValue() }
}

struct ComposeView: View {
    let spec: JobSpec
    @EnvironmentObject var shop: ShopFloor
    @Environment(\.presentationMode) private var presentation

    init(spec: JobSpec) {
        self.spec = spec
        _forme = State(initialValue: Forme(lines: Array(repeating: [], count: spec.copy.count)))
    }

    @State private var stage = 0
    @State private var forme: Forme
    @State private var activeLine = 0
    @State private var stickRect: CGRect = .zero
    @State private var furniture = [false, false, false, false]
    @State private var quoin: Double = 0
    @State private var quoinLocked = false
    @State private var squeezing = false
    @State private var brayerCharge: Double = 0
    @State private var inkLaid: Double = 0
    @State private var depth: Double = 0
    @State private var depthLocked = false
    @State private var pulling = false
    @State private var makeready = 0
    @State private var registerOffset: Double = 0.4
    @State private var verdict: Verdict? = nil
    @State private var hangNote: String? = nil
    @State private var showBrief = false
    @State private var flash: String? = nil
    private let ticker = Timer.publish(every: 0.04, on: .main, in: .common).autoconnect()

    private var face: TypeFace { Foundry.face(spec.faceKey) }
    private var paper: Stock { Papers.find(spec.paperKey) }
    private var ink: Colour { Inks.find(spec.inkKey) }
    private var hint: Int { shop.hint }
    private var blind: Bool { spec.constraint == 4 }
    private var effectiveHint: Int { blind ? 0 : hint }

    private var dimmedBoxes: Set<String> {
        var out: Set<String> = []
        if spec.constraint == 1 { out.insert("e") }
        if spec.constraint == 2 { out.insert("3em") }
        return out
    }

    var body: some View {
        ZStack {
            Press.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                header
                Divider().opacity(0.4)
                stageContent
            }
            if let flash = flash {
                VStack {
                    Spacer()
                    Text(flash)
                        .font(Press.body(13))
                        .foregroundColor(Press.card)
                        .padding(.horizontal, 14).padding(.vertical, 9)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Press.ink.opacity(0.90)))
                        .padding(.bottom, 90)
                }
                .transition(.opacity)
                .allowsHitTesting(false)
            }
            if showBrief { briefOverlay }
        }
        .coordinateSpace(name: "shop")
        .onAppear(perform: startJob)
        .onReceive(ticker) { _ in tick() }
    }

    private func startJob() {
        guard forme.lines.allSatisfy({ $0.isEmpty }) else { return }
        if forme.lines.count != spec.copy.count {
            forme.lines = Array(repeating: [], count: spec.copy.count)
        }
        registerOffset = spec.secondInk == nil ? 0 : 0.4
    }

    private func tick() {
        if squeezing && !quoinLocked {
            quoin = min(1.0, quoin + 0.014)
        }
        if pulling && !depthLocked {
            depth = min(1.0, depth + 0.017)
        }
        if brayerCharge > 0 && stage != 2 { brayerCharge = max(0, brayerCharge - 0.01) }
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(spec.title).font(Press.title(16)).foregroundColor(Press.ink)
                        .lineLimit(1).minimumScaleFactor(0.7)
                    Text("\(face.name) \(spec.size) pt, \(Int(spec.measurePicas)) picas, \(paper.name)")
                        .font(Press.note(11)).foregroundColor(Press.inkFaint)
                        .lineLimit(1).minimumScaleFactor(0.6)
                }
                Spacer(minLength: 4)
                Button(action: { Knock.light(); showBrief = true }) {
                    Text("Brief").font(Press.title(11.5)).foregroundColor(Press.brass)
                        .padding(.horizontal, 9).padding(.vertical, 6)
                        .overlay(RoundedRectangle(cornerRadius: 4)
                                    .stroke(Press.brass.opacity(0.6), lineWidth: 1))
                }
                .buttonStyle(.plain)
                Button(action: { Knock.light(); presentation.wrappedValue.dismiss() }) {
                    CrossMark(size: 15, color: Press.inkSoft)
                        .padding(8)
                        .background(Circle().fill(Press.ink.opacity(0.07)))
                }
                .buttonStyle(.plain)
            }
            SegmentRow(titles: ["Set", "Lock up", "Ink", "Pull"], index: Binding(
                get: { stage }, set: { moveTo($0) }))
        }
        .padding(.horizontal, Press.gutter)
        .padding(.top, 12)
        .padding(.bottom, 9)
        .background(Press.card)
    }

    private func moveTo(_ next: Int) {
        if next > stage {
            if stage == 0 && !allLinesFull { note("Every line has to be set and justified first."); return }
            if stage == 1 && !quoinLocked { note("Lock the forme before it goes on the press."); return }
            if stage == 2 && inkLaid < 0.05 { note("The forme has no ink on it at all."); return }
        }
        withAnimation(.easeOut(duration: 0.22)) { stage = max(0, min(3, next)) }
    }

    private func note(_ text: String) {
        Knock.firm()
        withAnimation { flash = text }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation { if flash == text { flash = nil } }
        }
    }

    private var allLinesFull: Bool {
        for (i, wanted) in spec.copy.enumerated() {
            let set = i < forme.lines.count ? forme.lines[i] : []
            if set.isEmpty { return false }
            let letters = set.filter { !JobCase.spaceKeys.contains($0.key) }
            let want = Array(wanted).filter { $0 != " " }
            if letters.count < want.count { return false }
            if abs(Measure.deficit(set, face, Double(spec.size), measurePicas: spec.measurePicas)) > 6 {
                return false
            }
        }
        return true
    }

    @ViewBuilder private var stageContent: some View {
        switch stage {
        case 0: settingStage
        case 1: lockupStage
        case 2: inkingStage
        default: pullStage
        }
    }

    private var deficit: Double {
        let line = activeLine < forme.lines.count ? forme.lines[activeLine] : []
        return Measure.deficit(line, face, Double(spec.size), measurePicas: spec.measurePicas)
    }

    private var settingStage: some View {
        GeometryReader { geo in
            let perLine: CGFloat = Press.isPad ? 116 : 64
            let stickH = min(geo.size.height * (Press.isPad ? 0.44 : 0.46),
                             perLine * CGFloat(max(1, spec.copy.count)) + 30)
            let trayH = min(geo.size.height * 0.34,
                            (geo.size.width - 12) / CGFloat(Frame.unitsWide) * CGFloat(Frame.unitsTall))
            VStack(spacing: 0) {
                copyStrip
                stickPanel(height: stickH)
                measureStrip
                Spacer(minLength: 0)
                benchNote
                Spacer(minLength: 0)
                CaseTray(face: face, hint: effectiveHint,
                         highlight: nextWanted, dimmed: dimmedBoxes) { key, point in
                    place(key, at: point)
                }
                .frame(maxWidth: .infinity)
                .frame(height: trayH)
                .padding(.horizontal, 6)
                .padding(.bottom, 8)
            }
        }
    }

    private var benchNote: some View {
        Group {
            if spec.constraint != 0 {
                NoticeBar(text: spec.constraintNote, tone: Press.vermilion)
            } else {
                NoticeBar(text: benchWords, tone: Press.brass)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, Press.gutter)
        .padding(.vertical, 6)
    }

    private var benchWords: String {
        if let wanted = nextWanted {
            return "The next sort in line \(activeLine + 1) is \(JobCase.display(wanted)). Its box is lit in the case."
        }
        let off = deficit
        if abs(off) < 0.5 {
            return "Line \(activeLine + 1) stands exactly to the measure. Pick another line, or take the forme to the stone."
        }
        if off > 0 {
            return "Line \(activeLine + 1) is short of the measure. Fill it out with quads and spaces until it is exact."
        }
        return "Line \(activeLine + 1) is over the measure. Lift a sort or use finer spaces."
    }

    private var nextWanted: String? {
        guard effectiveHint >= 2 else { return nil }
        guard activeLine < spec.copy.count else { return nil }
        let want = Array(spec.copy[activeLine]).map { String($0) }
        guard activeLine < forme.lines.count else { return nil }
        let set = forme.lines[activeLine].filter { !JobCase.spaceKeys.contains($0.key) }
        var index = 0
        for ch in want {
            if ch == " " { continue }
            if index < set.count { index += 1; continue }
            return ch
        }
        return nil
    }

    private var copyStrip: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 6) {
                Text("COPY").font(Press.title(9.5)).tracking(1.2).foregroundColor(Press.inkFaint)
                Spacer()
                if spec.constraint != 0 && spec.isDaily {
                    Text(spec.constraintName).font(Press.note(10.5)).foregroundColor(Press.vermilion)
                        .lineLimit(1).minimumScaleFactor(0.7)
                }
            }
            ForEach(Array(spec.copy.enumerated()), id: \.offset) { i, line in
                Button(action: { Knock.light(); activeLine = i }) {
                    HStack(spacing: 6) {
                        Text("\(i + 1)").font(Press.title(10))
                            .foregroundColor(i == activeLine ? Press.card : Press.inkFaint)
                            .frame(width: 15, height: 15)
                            .background(Circle().fill(i == activeLine ? Press.ink : Press.ink.opacity(0.09)))
                        Text(line).font(Press.body(12.5))
                            .foregroundColor(i == activeLine ? Press.ink : Press.inkSoft)
                            .lineLimit(1).minimumScaleFactor(0.55)
                        Spacer(minLength: 0)
                        Text(setCount(i)).font(Press.note(10)).foregroundColor(Press.inkFaint)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Press.gutter)
        .padding(.vertical, 8)
    }

    private func setCount(_ i: Int) -> String {
        let want = Array(spec.copy[i]).filter { $0 != " " }.count
        let have = i < forme.lines.count
            ? forme.lines[i].filter { !JobCase.spaceKeys.contains($0.key) }.count : 0
        return "\(have)/\(want)"
    }

    private func stickPanel(height: CGFloat) -> some View {
        StickBed(lines: forme.lines, face: face, size: Double(spec.size),
                 measurePicas: spec.measurePicas, activeLine: activeLine, showNicks: true)
            .frame(height: height)
            .background(
                GeometryReader { g in
                    Color.clear.preference(key: StickFrameKey.self,
                                           value: g.frame(in: .named("shop")))
                }
            )
            .onPreferenceChange(StickFrameKey.self) { stickRect = $0 }
            .overlay(
                Color.clear.contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0).onEnded { value in
                        turnAt(value.startLocation, height: height)
                    })
            )
            .padding(.horizontal, Press.gutter)
            .overlay(
                RoundedRectangle(cornerRadius: 3).stroke(Press.brassDeep, lineWidth: 1.4)
                    .padding(.horizontal, Press.gutter)
            )
    }

    private func turnAt(_ point: CGPoint, height: CGFloat) {
        let rows = max(1, forme.lines.count)
        let rowH = min(height / CGFloat(rows) - 5, CGFloat(spec.size) * (stickRect.width - 34)
                        / CGFloat(Measure.picasToPoints(spec.measurePicas)) * 1.75)
        let index = Int(point.y / max(1, rowH + 4))
        guard index >= 0 && index < forme.lines.count else { return }
        let scale = (stickRect.width - 34) / CGFloat(Measure.picasToPoints(spec.measurePicas))
        var cursor: CGFloat = 15
        for (j, sort) in forme.lines[index].enumerated() {
            let w = Metalwork.width(sort.key, face, size: CGFloat(spec.size)) * scale
            if point.x >= cursor && point.x < cursor + w {
                if JobCase.spaceKeys.contains(sort.key) { return }
                Knock.metal()
                forme.lines[index][j].turned.toggle()
                activeLine = index
                return
            }
            cursor += w
        }
        activeLine = index
    }

    private func place(_ key: String, at point: CGPoint) {
        guard activeLine < forme.lines.count else { return }
        if dimmedBoxes.contains(key) {
            note(key == "e" ? "The e box is empty today." : "The three to em spaces have run out.")
            return
        }
        if key == "lead" || key == "slug" {
            forme.leadingKeys.append(key)
            Knock.light()
            note("A \(key == "lead" ? "two point lead" : "six point slug") laid under the line.")
            return
        }
        guard stickRect.contains(point) else {
            note("Dropped on the floor. Bring the sort down into the stick.")
            return
        }
        let turned = spec.constraint == 3 ? true : (point.y < stickRect.minY + 6)
        Knock.metal()
        forme.lines[activeLine].append(SetSort(key: key, turned: turned))
    }

    private var measureStrip: some View {
        let off = deficit
        let exact = abs(off) < 0.5
        return HStack(spacing: 8) {
            Button(action: liftLast) {
                Text("Lift").font(Press.title(11.5)).foregroundColor(Press.inkSoft)
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .overlay(RoundedRectangle(cornerRadius: 4)
                                .stroke(Press.inkSoft.opacity(0.5), lineWidth: 1))
            }
            .buttonStyle(.plain)
            Button(action: turnLast) {
                HStack(spacing: 4) {
                    TurnMark(size: 12, color: Press.inkSoft)
                    Text("Turn").font(Press.title(11.5)).foregroundColor(Press.inkSoft)
                }
                .padding(.horizontal, 9).padding(.vertical, 6)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Press.inkSoft.opacity(0.5), lineWidth: 1))
            }
            .buttonStyle(.plain)
            Spacer(minLength: 4)
            VStack(alignment: .trailing, spacing: 1) {
                Text(effectiveHint >= 2 ? Measure.spellDeficit(off)
                     : (effectiveHint == 1 ? Measure.looseWord(off) : (exact ? "sits" : "not yet")))
                    .font(Press.title(13))
                    .foregroundColor(exact ? Press.good : (off < 0 ? Press.alarm : Press.brass))
                    .lineLimit(1).minimumScaleFactor(0.7)
                Text("line \(activeLine + 1) against the measure")
                    .font(Press.note(9.5)).foregroundColor(Press.inkFaint)
            }
        }
        .padding(.horizontal, Press.gutter)
        .padding(.vertical, 7)
    }

    private func liftLast() {
        guard activeLine < forme.lines.count, !forme.lines[activeLine].isEmpty else { return }
        Knock.light()
        forme.lines[activeLine].removeLast()
    }

    private func turnLast() {
        guard activeLine < forme.lines.count, !forme.lines[activeLine].isEmpty else { return }
        Knock.metal()
        forme.lines[activeLine][forme.lines[activeLine].count - 1].turned.toggle()
    }

    private var lockupStage: some View {
        ScrollView {
            Column(spacing: 13) {
                SheetCard {
                    VStack(alignment: .leading, spacing: 10) {
                        RuleHead(text: "Furniture")
                        Text("Pack the four sides so the quoins have something to push against.")
                            .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        ChaseDiagram(furniture: furniture, quoin: quoin, locked: quoinLocked) { side in
                            Knock.light()
                            furniture[side].toggle()
                        }
                        .frame(height: Press.isPad ? 300 : 210)
                    }
                }
                SheetCard {
                    VStack(alignment: .leading, spacing: 10) {
                        RuleHead(text: "The quoins")
                        MeterBar(label: "Pressure", value: quoin,
                                 tone: quoinLocked ? Press.good : Press.brass,
                                 caption: hint >= 1
                                 ? "The band for \(paper.name) is around \(Int((0.62 + (1 - paper.softness) * 0.06) * 100)). Loose and it pies, tight and it springs."
                                 : "Judge it by the feel of the forme.")
                        if hint >= 1 {
                            QuoinBand(ideal: 0.62 + (1 - paper.softness) * 0.06, value: quoin)
                                .frame(height: 16)
                        }
                        Text(quoinLocked ? "Locked. Lift a corner and nothing drops."
                             : "Press and hold to drive the quoins. Let go when it feels right.")
                            .font(Press.note(12)).foregroundColor(Press.inkFaint)
                            .fixedSize(horizontal: false, vertical: true)
                        HoldPad(title: quoinLocked ? "Slacken off" : "Hold to tighten",
                                tone: quoinLocked ? Press.inkSoft : Press.oak,
                                onDown: {
                                    if quoinLocked { quoinLocked = false; quoin = 0; return }
                                    guard furniture.allSatisfy({ $0 }) else {
                                        note("Furniture on all four sides first."); return
                                    }
                                    squeezing = true
                                },
                                onUp: {
                                    if squeezing {
                                        squeezing = false
                                        quoinLocked = true
                                        Knock.hard()
                                    }
                                })
                    }
                }
                LeverButton(title: "On to the ink", tone: Press.oak, enabled: quoinLocked) {
                    moveTo(2)
                }
            }
            .padding(.horizontal, Press.gutter)
            .padding(.vertical, 14)
        }
    }

    private var inkingStage: some View {
        ScrollView {
            Column(spacing: 13) {
                SheetCard {
                    VStack(alignment: .leading, spacing: 10) {
                        RuleHead(text: "The slab")
                        Text("Drag the brayer back and forth on the slab until it carries an even film, then roll it over the forme.")
                            .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        InkSlab(charge: brayerCharge, tone: Press.inkColour(spec.inkKey)) { distance in
                            brayerCharge = min(1.0, brayerCharge + distance / 900)
                        }
                        .frame(height: 106)
                        MeterBar(label: "On the brayer", value: brayerCharge,
                                 tone: Press.inkColour(spec.inkKey))
                    }
                }
                SheetCard {
                    VStack(alignment: .leading, spacing: 10) {
                        RuleHead(text: "The forme")
                        FormeInker(lines: forme.lines, face: face, size: Double(spec.size),
                                   measurePicas: spec.measurePicas, coverage: inkLaid,
                                   tone: Press.inkColour(spec.inkKey)) { distance in
                            guard brayerCharge > 0.02 else { return }
                            let given = min(brayerCharge, distance / 700)
                            brayerCharge -= given
                            inkLaid = min(1.3, inkLaid + given)
                        }
                        .frame(height: Press.isPad ? 210 : 152)
                        MeterBar(label: "On the forme", value: min(1, inkLaid),
                                 tone: inkTooMuch ? Press.alarm : Press.inkColour(spec.inkKey),
                                 caption: hint >= 1 ? inkAdvice : "Look at the coverage, not the number.")
                    }
                }
                if hint >= 1 {
                    NoticeBar(text: inkAdvice, tone: inkTooMuch ? Press.alarm : Press.brass)
                }
                LeverButton(title: "To the press", tone: Press.oak, enabled: inkLaid > 0.05) {
                    moveTo(3)
                }
            }
            .padding(.horizontal, Press.gutter)
            .padding(.vertical, 14)
        }
    }

    private var inkIdeal: Double { 0.44 + paper.absorbency * 0.24 }
    private var inkTooMuch: Bool { inkLaid > inkIdeal + 0.16 }
    private var inkAdvice: String {
        if inkLaid < inkIdeal - 0.16 { return "Still grey. \(paper.name) wants more than that." }
        if inkTooMuch { return "That is too much for \(paper.name). The counters will close." }
        return "About right for \(paper.name)."
    }

    private var pullStage: some View {
        ScrollView {
            Column(spacing: 13) {
                if let verdict = verdict {
                    resultCard(verdict)
                } else {
                    SheetCard {
                        VStack(alignment: .leading, spacing: 10) {
                            RuleHead(text: "Makeready")
                            Text("Paste tissue behind the light areas. It costs nothing but time and it is the difference between a proof and a piece of printing.")
                                .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                                .fixedSize(horizontal: false, vertical: true)
                            HStack(spacing: 8) {
                                ForEach(0..<4, id: \.self) { k in
                                    Button(action: { Knock.light(); makeready = k }) {
                                        VStack(spacing: 3) {
                                            Text("\(k)").font(Press.title(15))
                                                .foregroundColor(makeready == k ? Press.card : Press.inkSoft)
                                            Text(k == 0 ? "none" : "sheets").font(Press.body(8.5))
                                                .foregroundColor(makeready == k ? Press.card.opacity(0.8) : Press.inkFaint)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(RoundedRectangle(cornerRadius: 5)
                                                        .fill(makeready == k ? Press.oak : Press.ink.opacity(0.06)))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    if spec.secondInk != nil {
                        SheetCard {
                            VStack(alignment: .leading, spacing: 10) {
                                RuleHead(text: "Register")
                                Text("The second forme has to land exactly over the first. Set the lays.")
                                    .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                                RegisterDial(offset: $registerOffset)
                                    .frame(height: 66)
                                Text(String(format: "%.1f points out", registerOffset))
                                    .font(Press.title(13))
                                    .foregroundColor(registerOffset < 0.6 ? Press.good : Press.brass)
                            }
                        }
                    }
                    SheetCard {
                        VStack(alignment: .leading, spacing: 10) {
                            RuleHead(text: "The pull")
                            MeterBar(label: "Impression", value: depth,
                                     tone: depthLocked ? Press.good : Press.oak,
                                     caption: hint >= 1
                                     ? "\(paper.name) is happiest around \(Int(paper.bestDepth * 100)). Its window is narrow."
                                     : "A kiss, or a bite. The paper decides.")
                            if hint >= 1 {
                                QuoinBand(ideal: paper.bestDepth, value: depth)
                                    .frame(height: 16)
                            }
                            HoldPad(title: depthLocked ? "Ease the lever back" : "Hold the lever",
                                    tone: depthLocked ? Press.inkSoft : Press.vermilion,
                                    onDown: {
                                        if depthLocked { depthLocked = false; depth = 0; return }
                                        pulling = true
                                    },
                                    onUp: {
                                        if pulling {
                                            pulling = false
                                            depthLocked = true
                                            Knock.hard()
                                        }
                                    })
                            LeverButton(title: "Take the sheet off", tone: Press.oak,
                                        enabled: depthLocked) { judge() }
                        }
                    }
                }
            }
            .padding(.horizontal, Press.gutter)
            .padding(.vertical, 14)
        }
    }

    private func judge() {
        let pull = Pull(quoin: quoin, inking: inkLaid, depth: depth,
                        registerOffset: spec.secondInk == nil ? 0 : registerOffset,
                        makeready: Double(makeready) / 3)
        let result = Judge.read(forme, copy: spec.copy, face: face, size: Double(spec.size),
                                measurePicas: spec.measurePicas, paper: paper, ink: ink,
                                pull: pull, secondColour: spec.secondInk != nil)
        Knock.hard()
        withAnimation { verdict = result }
        if spec.isDaily {
            shop.record(DayRecord(day: shop.today, score: result.total,
                                  faceKey: spec.faceKey, line: spec.copy.first ?? ""))
        } else {
            shop.award(6 + Int(result.total * 20))
        }
    }

    private func resultCard(_ v: Verdict) -> some View {
        VStack(spacing: 13) {
            SheetCard(padding: 0) {
                VStack(spacing: 0) {
                    PrintedSheet(forme: forme, face: face, size: Double(spec.size),
                                 measurePicas: spec.measurePicas, paperKey: spec.paperKey,
                                 inkKey: spec.inkKey, secondInk: spec.secondInk,
                                 pull: Pull(quoin: quoin, inking: inkLaid, depth: depth,
                                            registerOffset: spec.secondInk == nil ? 0 : registerOffset,
                                            makeready: Double(makeready) / 3),
                                 ornamentKey: spec.ornamentKey)
                        .frame(height: Press.isPad ? 420 : 300)
                        .clipped()
                    HStack {
                        Text(v.grade).font(Press.title(17)).foregroundColor(Press.ink)
                        Spacer()
                        StampTag(text: "\(Int(v.total * 100))",
                                 tone: v.total > 0.78 ? Press.good : Press.brass)
                    }
                    .padding(13)
                }
            }
            SheetCard {
                VStack(alignment: .leading, spacing: 9) {
                    RuleHead(text: "The reading")
                    MeterBar(label: "Accuracy", value: v.accuracy, tone: Press.ink)
                    MeterBar(label: "Spacing", value: v.spacing, tone: Press.brass)
                    MeterBar(label: "Lock up", value: v.lockup, tone: Press.oak)
                    MeterBar(label: "Inking", value: v.inking, tone: Press.inkColour(spec.inkKey))
                    MeterBar(label: "Impression", value: v.impression, tone: Press.vermilion)
                    if spec.secondInk != nil {
                        MeterBar(label: "Register", value: v.register, tone: Press.good)
                    }
                }
            }
            if !v.faults.isEmpty {
                SheetCard {
                    VStack(alignment: .leading, spacing: 8) {
                        RuleHead(text: "Faults")
                        ForEach(Array(v.faults.enumerated()), id: \.offset) { _, fault in
                            HStack(alignment: .top, spacing: 7) {
                                Circle().fill(Press.alarm).frame(width: 4, height: 4).padding(.top, 6)
                                Text(fault).font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
            if let hangNote = hangNote {
                NoticeBar(text: hangNote, tone: Press.good)
            }
            if !spec.isDaily && hangNote == nil {
                LeverButton(title: "Hang it on the rack", tone: Press.oak) {
                    let sheet = Specimen(jobKey: spec.key, title: spec.title, faceKey: spec.faceKey,
                                         size: spec.size, measurePicas: spec.measurePicas,
                                         paperKey: spec.paperKey, inkKey: spec.inkKey,
                                         secondInk: spec.secondInk, ornamentKey: spec.ornamentKey,
                                         forme: forme,
                                         pull: Pull(quoin: quoin, inking: inkLaid, depth: depth,
                                                    registerOffset: spec.secondInk == nil ? 0 : registerOffset,
                                                    makeready: Double(makeready) / 3),
                                         score: v.total, accuracy: v.accuracy, spacing: v.spacing,
                                         lockup: v.lockup, inking: v.inking, impression: v.impression,
                                         register: v.register, day: shop.today,
                                         note: v.faults.first ?? "Nothing to answer for.")
                    withAnimation { hangNote = shop.hang(sheet) }
                }
            }
            HStack(spacing: 9) {
                LeverButton(title: "Pull another", tone: Press.inkSoft, filled: false) {
                    withAnimation {
                        verdict = nil
                        hangNote = nil
                        depth = 0
                        depthLocked = false
                    }
                }
                LeverButton(title: "Done", tone: Press.oak) {
                    presentation.wrappedValue.dismiss()
                }
            }
        }
    }

    private var briefOverlay: some View {
        ZStack {
            DimBackdrop { showBrief = false }
            VStack(spacing: 0) {
                PanelHead(title: spec.title, subtitle: spec.client) { showBrief = false }
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(spec.brief).font(Press.body(14)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        if spec.constraint != 0 && spec.isDaily {
                            NoticeBar(text: spec.constraintNote, tone: Press.vermilion)
                        }
                        RuleHead(text: "Copy")
                        ForEach(Array(spec.copy.enumerated()), id: \.offset) { i, line in
                            Text("\(i + 1).  \(line)").font(Press.body(14))
                                .foregroundColor(Press.ink)
                        }
                        RuleHead(text: "Specification")
                        PairRow(key: "Face", value: "\(face.name) \(spec.size) point")
                        PairRow(key: "Measure", value: "\(Int(spec.measurePicas)) picas")
                        PairRow(key: "Paper", value: paper.name)
                        PairRow(key: "Ink", value: ink.name)
                        if let second = spec.secondInk {
                            PairRow(key: "Second colour", value: Inks.find(second).name)
                        }
                        RuleHead(text: "Hints")
                        SegmentRow(titles: ["Blind", "By feel", "Full"], index: Binding(
                            get: { shop.hint }, set: { shop.hint = $0 }))
                        Text("Blind hides the box labels and the point figure. Full names the sort you want next and tells you how far off the measure you are.")
                            .font(Press.note(12)).foregroundColor(Press.inkFaint)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 20)
                }
                LeverButton(title: "Back to the stick", tone: Press.oak) { showBrief = false }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 16)
            }
            .background(Press.paper)
            .cornerRadius(10)
            .padding(.horizontal, Press.isPad ? 90 : 14)
            .padding(.vertical, 44)
        }
    }
}

struct HoldPad: View {
    var title: String
    var tone: Color
    var onDown: () -> Void
    var onUp: () -> Void
    @State private var down = false

    var body: some View {
        Text(title)
            .font(Press.title(15))
            .foregroundColor(Press.card)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(RoundedRectangle(cornerRadius: 5).fill(down ? tone.opacity(0.72) : tone))
            .scaleEffect(down ? 0.985 : 1)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !down { down = true; Knock.firm(); onDown() }
                    }
                    .onEnded { _ in
                        down = false
                        onUp()
                    }
            )
    }
}

struct QuoinBand: View {
    var ideal: Double
    var value: Double
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Press.ink.opacity(0.08))
                Capsule().fill(Press.good.opacity(0.34))
                    .frame(width: geo.size.width * 0.18)
                    .offset(x: geo.size.width * CGFloat(max(0, min(0.82, ideal - 0.09))))
                Rectangle().fill(Press.ink)
                    .frame(width: 2)
                    .offset(x: geo.size.width * CGFloat(min(0.99, max(0, value))))
            }
        }
    }
}

struct ChaseDiagram: View {
    var furniture: [Bool]
    var quoin: Double
    var locked: Bool
    var onTap: (Int) -> Void

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let inset: CGFloat = 12
            ZStack {
                Canvas { ctx, area in
                    ctx.fill(Path(CGRect(origin: .zero, size: area)),
                             with: .color(Color(red: 0.176, green: 0.176, blue: 0.188)))
                    ctx.fill(Path(CGRect(x: inset, y: inset,
                                         width: area.width - inset * 2,
                                         height: area.height - inset * 2)),
                             with: .color(Press.stone.opacity(0.42)))
                    let fx = area.width * 0.30, fy = area.height * 0.30
                    let fw = area.width * 0.40, fh = area.height * 0.40
                    ctx.fill(Path(CGRect(x: fx, y: fy, width: fw, height: fh)),
                             with: .color(Press.lead))
                    for k in 0..<4 {
                        let y = fy + fh * (0.18 + CGFloat(k) * 0.22)
                        ctx.fill(Path(CGRect(x: fx + fw * 0.10, y: y, width: fw * 0.80, height: fh * 0.09)),
                                 with: .color(Press.leadDark))
                    }
                    let slots: [CGRect] = [
                        CGRect(x: fx, y: inset + 4, width: fw, height: fy - inset - 8),
                        CGRect(x: fx, y: fy + fh + 4, width: fw, height: area.height - fy - fh - inset - 8),
                        CGRect(x: inset + 4, y: fy, width: fx - inset - 8, height: fh),
                        CGRect(x: fx + fw + 4, y: fy, width: area.width - fx - fw - inset - 8, height: fh)
                    ]
                    for (i, slot) in slots.enumerated() {
                        if furniture[i] {
                            ctx.fill(Path(slot), with: .color(Press.oak))
                            var grain = Path()
                            let steps = Int(max(slot.width, slot.height) / 8)
                            for g in 0..<max(1, steps) {
                                if slot.width > slot.height {
                                    let x = slot.minX + CGFloat(g) * 8
                                    grain.move(to: CGPoint(x: x, y: slot.minY + 2))
                                    grain.addLine(to: CGPoint(x: x, y: slot.maxY - 2))
                                } else {
                                    let y = slot.minY + CGFloat(g) * 8
                                    grain.move(to: CGPoint(x: slot.minX + 2, y: y))
                                    grain.addLine(to: CGPoint(x: slot.maxX - 2, y: y))
                                }
                            }
                            ctx.stroke(grain, with: .color(Press.oakDark.opacity(0.45)), lineWidth: 0.8)
                        } else {
                            ctx.stroke(Path(slot), with: .color(Press.card.opacity(0.35)),
                                       style: StrokeStyle(lineWidth: 1.2, dash: [4, 3]))
                        }
                    }
                    if furniture[3] {
                        let q = CGRect(x: area.width - inset - 22, y: fy + fh * 0.2,
                                       width: 16, height: fh * 0.26)
                        ctx.fill(Path(q), with: .color(Press.leadLight))
                        ctx.fill(Path(q.offsetBy(dx: 0, dy: fh * 0.36)), with: .color(Press.leadLight))
                        let push = CGFloat(quoin) * 6
                        ctx.fill(Path(q.offsetBy(dx: -push, dy: 0)), with: .color(locked ? Press.good : Press.brass))
                        ctx.fill(Path(q.offsetBy(dx: -push, dy: fh * 0.36)), with: .color(locked ? Press.good : Press.brass))
                    }
                }
                VStack(spacing: 0) {
                    Button(action: { onTap(0) }) { Color.clear }
                        .frame(height: h * 0.28)
                    HStack(spacing: 0) {
                        Button(action: { onTap(2) }) { Color.clear }.frame(width: w * 0.28)
                        Color.clear.frame(width: w * 0.44)
                        Button(action: { onTap(3) }) { Color.clear }.frame(width: w * 0.28)
                    }
                    .frame(height: h * 0.44)
                    Button(action: { onTap(1) }) { Color.clear }
                        .frame(height: h * 0.28)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
            .frame(width: w, height: h)
        }
    }
}

struct InkSlab: View {
    var charge: Double
    var tone: Color
    var onDrag: (CGFloat) -> Void
    @State private var last: CGPoint? = nil
    @State private var trail: [CGPoint] = []

    var body: some View {
        Canvas { ctx, area in
            ctx.fill(Path(CGRect(origin: .zero, size: area)),
                     with: .color(Press.stone.opacity(0.55)))
            for (i, p) in trail.enumerated() {
                let alpha = Double(i) / Double(max(1, trail.count)) * 0.7 + 0.2
                ctx.fill(Path(ellipseIn: CGRect(x: p.x - 13, y: p.y - 7, width: 26, height: 14)),
                         with: .color(tone.opacity(alpha * min(1, charge + 0.25))))
            }
            ctx.stroke(Path(CGRect(origin: .zero, size: area).insetBy(dx: 1, dy: 1)),
                       with: .color(Press.ink.opacity(0.25)), lineWidth: 1.2)
            if trail.isEmpty {
                ctx.draw(Text(verbatim: "drag here to work the ink out")
                            .font(Press.note(12)).foregroundColor(Press.card.opacity(0.8)),
                         at: CGPoint(x: area.width / 2, y: area.height / 2))
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if let l = last {
                        let d = hypot(value.location.x - l.x, value.location.y - l.y)
                        if d > 2 {
                            onDrag(d)
                            trail.append(value.location)
                            if trail.count > 90 { trail.removeFirst() }
                        }
                    }
                    last = value.location
                }
                .onEnded { _ in last = nil }
        )
    }
}

struct FormeInker: View {
    var lines: [[SetSort]]
    var face: TypeFace
    var size: Double
    var measurePicas: Double
    var coverage: Double
    var tone: Color
    var onRoll: (CGFloat) -> Void
    @State private var last: CGPoint? = nil

    var body: some View {
        ZStack {
            StickBed(lines: lines, face: face, size: size, measurePicas: measurePicas,
                     activeLine: -1, showNicks: false)
            Rectangle()
                .fill(tone.opacity(min(0.86, coverage * 0.72)))
                .blendMode(.multiply)
                .allowsHitTesting(false)
            if coverage > 1.05 {
                Rectangle().fill(tone.opacity(0.4)).allowsHitTesting(false)
            }
            if coverage < 0.05 {
                Text("roll the brayer across")
                    .font(Press.note(12)).foregroundColor(Press.card)
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if let l = last {
                        let d = hypot(value.location.x - l.x, value.location.y - l.y)
                        if d > 2 { onRoll(d) }
                    }
                    last = value.location
                }
                .onEnded { _ in last = nil }
        )
    }
}

struct RegisterDial: View {
    @Binding var offset: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4).fill(Press.ink.opacity(0.07))
                RoundedRectangle(cornerRadius: 4).fill(Press.good.opacity(0.28))
                    .frame(width: geo.size.width * 0.16)
                Canvas { ctx, area in
                    let x = area.width * CGFloat(min(1, offset / 3.0))
                    ctx.fill(Path(CGRect(x: max(0, x - 6), y: 6, width: 12, height: area.height - 12)),
                             with: .color(Press.brass))
                    ctx.stroke(Path(CGRect(x: max(0, x - 6), y: 6, width: 12, height: area.height - 12)),
                               with: .color(Press.brassDeep), lineWidth: 1.2)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        offset = max(0, min(3.0, Double(value.location.x / max(1, geo.size.width)) * 3.0))
                    }
            )
        }
    }
}
