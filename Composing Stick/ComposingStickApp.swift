import SwiftUI

enum Bench10 {
    static let env = ProcessInfo.processInfo.environment
    static var tab: Int { Int(env["CS_TAB"] ?? "") ?? 0 }
    static var skipIntro: Bool { env["CS_SKIP"] == "1" }
    static var intro: Int? { Int(env["CS_INTRO"] ?? "") }
    static var hour: Double? { Double(env["CS_HOUR"] ?? "") }
    static var job: String? { env["CS_JOB"] }
    static var stage: Int { Int(env["CS_STAGE"] ?? "") ?? 0 }
    static var fill: Bool { env["CS_FILL"] == "1" }
    static var seed: Bool { env["CS_SEED"] == "1" }

    static func plant(_ shop: ShopFloor) {
        guard seed, shop.ledger.book.isEmpty else { return }
        var ledger = ShopLedger()
        ledger.seenIntro = true
        ledger.hintLevel = 2
        shop.ledger = ledger
        let wanted = ["wedding", "broadside", "bookplate", "concert", "apothecary"]
        for key in wanted {
            guard let job = Orders.all.first(where: { $0.key == key }) else { continue }
            let face = Foundry.face(job.faceKey)
            let paper = Papers.find(job.paperKey)
            let ink = Inks.find(job.inkKey)
            var forme = Setter.fillForme(job.copy, face: face, size: Double(job.size),
                                         measurePicas: job.measurePicas)
            if key == "concert", var last = forme.lines.last, let spot = last.indices.last {
                last[spot].turned = true
                forme.lines[forme.lines.count - 1] = last
            }
            let pull = Pull(quoin: 0.66 + (1 - paper.softness) * 0.05,
                            inking: key == "broadside" ? 0.78 : 0.60,
                            depth: 0.52, registerOffset: job.secondInk == nil ? 0 : 0.03,
                            makeready: 0.7)
            let verdict = Judge.read(forme, copy: job.copy, face: face, size: Double(job.size),
                                     measurePicas: job.measurePicas, paper: paper, ink: ink,
                                     pull: pull, secondColour: job.secondInk != nil)
            let sheet = Specimen(jobKey: job.key, title: job.name, faceKey: job.faceKey,
                                 size: job.size, measurePicas: job.measurePicas,
                                 paperKey: job.paperKey, inkKey: job.inkKey,
                                 secondInk: job.secondInk, ornamentKey: job.ornamentKey,
                                 forme: forme, pull: pull, score: verdict.total,
                                 accuracy: verdict.accuracy, spacing: verdict.spacing,
                                 lockup: verdict.lockup, inking: verdict.inking,
                                 impression: verdict.impression, register: verdict.register,
                                 day: shop.today, note: job.brief)
            _ = shop.hang(sheet)
        }
        let today = shop.today
        for back in 0..<6 {
            let day = today - back
            let score = 0.72 + Double((day * 7) % 20) / 100
            shop.ledger.days.append(DayRecord(day: day, score: score,
                                              faceKey: Foundry.faces[back % Foundry.faces.count].key,
                                              line: Daily.job(day).line))
        }
        shop.ledger.days.sort { $0.day > $1.day }
        shop.ledger.streak = 6
        shop.ledger.bestStreak = 9
        shop.ledger.lastDay = today
        shop.ledger.marks = 1_180
        shop.ledger.pulls = 14
        shop.ledger.wasted = 2
        shop.ledger.readLessons = Bench.all.prefix(7).map { $0.key }
        shop.ledger.readFaces = Foundry.faces.prefix(5).map { $0.key }
    }
}

@main
struct ComposingStickApp: App {
    @StateObject private var shop = ShopFloor()

    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }

    var body: some Scene {
        WindowGroup {
            PressHouse()
                .environmentObject(shop)
                .preferredColorScheme(.light)
        }
    }
}

struct PressHouse: View {
    @EnvironmentObject var shop: ShopFloor
    @State private var page = 0
    @State private var started = false

    private var needsIntro: Bool {
        if Bench10.skipIntro { return false }
        if Bench10.intro != nil { return true }
        return !(shop.ledger.seenIntro ?? false)
    }

    var body: some View {
        ZStack {
            if needsIntro && !started {
                OpeningPages(page: $page) {
                    shop.ledger.seenIntro = true
                    withAnimation(.easeOut(duration: 0.3)) { started = true }
                }
                .transition(.opacity)
            } else {
                ShopFront()
            }
        }
        .onAppear {
            Bench10.plant(shop)
            if let forced = Bench10.intro { page = max(0, min(3, forced)) }
        }
    }
}

struct ShopFront: View {
    @EnvironmentObject var shop: ShopFloor
    @State private var tab = 0
    @State private var routed = false
    @State private var showJob = false

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch tab {
                case 1:
                    NavigationView {
                        OrderBookView()
                            .navigationTitle("The Order Book")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                case 2:
                    NavigationView {
                        CaseRoomView()
                            .navigationTitle("The Case Room")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                case 3:
                    NavigationView {
                        ManualView()
                            .navigationTitle("The Manual")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                case 4:
                    NavigationView {
                        SpecimenBookView()
                            .navigationTitle("The Specimen Book")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                default:
                    NavigationView {
                        ShopView()
                            .navigationTitle("Composing Stick")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            benchBar
        }
        .background(Press.paper.ignoresSafeArea())
        .fullScreenCover(isPresented: $showJob) {
            if let job = Orders.all.first(where: { $0.key == Bench10.job }) {
                ComposeView(spec: JobSpec.from(job)).environmentObject(shop)
            }
        }
        .onAppear {
            guard !routed else { return }
            routed = true
            let wanted = Bench10.tab
            DispatchQueue.main.async {
                if wanted > 0 && wanted < 5 { tab = wanted }
                if Bench10.job != nil { showJob = true }
            }
        }
    }

    private var benchBar: some View {
        HStack(spacing: 0) {
            benchButton(0, "Shop", AnyView(SortMark(size: 21, color: colour(0))))
            benchButton(1, "Orders", AnyView(OrderMark(size: 21, color: colour(1))))
            benchButton(2, "Case", AnyView(CaseMark(size: 21, color: colour(2))))
            benchButton(3, "Manual", AnyView(GaugeMark(size: 21, color: colour(3))))
            benchButton(4, "Book", AnyView(BookMark(size: 21, color: colour(4))))
        }
        .padding(.top, 7)
        .padding(.bottom, 3)
        .background(
            Press.card
                .overlay(Rectangle().fill(Press.ink.opacity(0.13)).frame(height: 0.8),
                         alignment: .top)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func colour(_ index: Int) -> Color {
        tab == index ? Press.oakDark : Press.inkFaint.opacity(0.75)
    }

    private func benchButton(_ index: Int, _ label: String, _ icon: AnyView) -> some View {
        Button(action: {
            if tab != index { Knock.light() }
            tab = index
        }) {
            VStack(spacing: 3) {
                icon.frame(height: 23)
                Text(label)
                    .font(Press.title(9.5))
                    .tracking(0.4)
                    .foregroundColor(colour(index))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 3)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct OpeningPages: View {
    @Binding var page: Int
    var onDone: () -> Void

    private let plates = ["ob_0", "ob_1", "ob_2", "ob_3"]
    private let heads = ["A shop with the gas still on",
                         "The letter goes in backwards",
                         "A line has to be exactly the measure",
                         "Ink it, pull it, hang it up"]
    private let bodies = ["This is a jobbing printing house some time after 1870. There is a case of type in a frame by the window, a stone to make the forme up on, and a press that does nothing at all until somebody sets a line of metal by hand. That somebody is you.",
                          "A sort comes out of its box, goes into the composing stick face up and nick up, and lands there mirrored and standing on its head. That is not a bug. It is why the nick is cast on the front of the body: your thumb finds it and you know the letter is the right way up without being able to read it.",
                          "Metal does not stretch. A line that is a hair short falls out of the forme when it is lifted, so you fill it with quads and spaces until it is exactly the measure and not a point over. The whole trade turns on that one piece of arithmetic.",
                          "Pack the chase with furniture, drive the quoins, roll the brayer until the film is even, and hold the lever down. Whatever you actually did shows up on the sheet: a turned letter really is upside down, a flooded forme really has filled counters. The best pull of each job is bound into your specimen book."]

    var body: some View {
        ZStack {
            Press.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    if page > 0 {
                        Button(action: { Knock.light(); withAnimation(.easeOut(duration: 0.22)) { page -= 1 } }) {
                            HStack(spacing: 5) {
                                BackChev(size: 13, color: Press.inkSoft)
                                Text("Back").font(Press.title(12.5)).foregroundColor(Press.inkSoft)
                            }
                            .padding(.horizontal, 10).padding(.vertical, 7)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer(minLength: 0)
                    Button(action: { Knock.light(); onDone() }) {
                        Text("Skip").font(Press.title(12.5)).foregroundColor(Press.inkFaint)
                            .padding(.horizontal, 12).padding(.vertical, 7)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, Press.gutter - 6)
                .padding(.top, 8)

                ScrollView {
                    VStack(spacing: 16) {
                        PlateBox(name: plates[page], height: Press.isPad ? 380 : 250)
                        VStack(alignment: .leading, spacing: 11) {
                            Text("\(page + 1) of 4".uppercased())
                                .font(Press.body(9.5)).tracking(1.4)
                                .foregroundColor(Press.brassDeep)
                            Text(heads[page])
                                .font(Press.title(23)).foregroundColor(Press.ink)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(bodies[page])
                                .font(Press.body(14)).foregroundColor(Press.inkSoft)
                                .lineSpacing(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, Press.gutter)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .frame(maxWidth: Press.isPad ? 700 : .infinity)
                    .frame(maxWidth: .infinity)
                }

                VStack(spacing: 12) {
                    HStack(spacing: 6) {
                        ForEach(0..<4, id: \.self) { i in
                            Capsule()
                                .fill(i == page ? Press.oakDark : Press.ink.opacity(0.16))
                                .frame(width: i == page ? 18 : 6, height: 6)
                        }
                    }
                    LeverButton(title: page == 3 ? "Take the stick" : "Go on",
                                tone: Press.oak) {
                        if page == 3 {
                            onDone()
                        } else {
                            withAnimation(.easeOut(duration: 0.22)) { page += 1 }
                        }
                    }
                    .frame(maxWidth: Press.isPad ? 420 : .infinity)
                }
                .padding(.horizontal, Press.gutter)
                .padding(.bottom, 18)
            }
        }
    }
}
