import SwiftUI

struct ShopView: View {
    @EnvironmentObject var shop: ShopFloor
    @State private var openJob = false
    @State private var now = Date()
    @State private var showHours = false
    private let clock = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var job: DayJob { Daily.job(shop.today) }
    private var hour: Double {
        let parts = Calendar.current.dateComponents([.hour, .minute], from: now)
        return Double(parts.hour ?? 12) + Double(parts.minute ?? 0) / 60
    }

    var body: some View {
        ScrollView {
            Column {
                sceneCard
                jobCard
                standingCard
                lastCard
                wordCard
            }
            .padding(.horizontal, Press.gutter)
            .padding(.bottom, 26)
        }
        .background(Press.paper.ignoresSafeArea())
        .onReceive(clock) { now = $0 }
        .fullScreenCover(isPresented: $openJob) {
            ComposeView(spec: JobSpec.from(job)).environmentObject(shop)
        }
        .sheet(isPresented: $showHours) {
            HoursPanel { showHours = false }
        }
    }

    private var sceneCard: some View {
        SheetCard(padding: 0) {
            VStack(spacing: 0) {
                ShopScene(hour: hour)
                    .frame(height: Press.isPad ? 260 : 190)
                    .clipped()
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(hourWords).font(Press.title(15)).foregroundColor(Press.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(String(format: "The shop at %02d:%02d", Int(hour), Int((hour - Double(Int(hour))) * 60)))
                            .font(Press.note(11)).foregroundColor(Press.inkFaint)
                    }
                    Spacer(minLength: 0)
                    Button(action: { Knock.light(); showHours = true }) {
                        Text("Seven hours").font(Press.title(10.5)).foregroundColor(Press.brass)
                            .padding(.horizontal, 8).padding(.vertical, 5)
                            .overlay(RoundedRectangle(cornerRadius: 4)
                                        .stroke(Press.brass.opacity(0.6), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
                .padding(13)
            }
        }
        .rising(0)
    }

    private var hourWords: String {
        switch Int(hour) {
        case 0..<5: return "The forme is locked and nothing moves"
        case 5..<8: return "The stove is lit and the gas is still on"
        case 8..<11: return "North light across the case, the best hour for small work"
        case 11..<14: return "The beam has crossed to the stone"
        case 14..<17: return "The light is going yellow and the long runs go on"
        case 17..<20: return "The gas is lit and the window has stopped being useful"
        default: return "One lamp over the stone and the rest in the dark"
        }
    }

    private var jobCard: some View {
        let done = shop.workedToday()
        let record = shop.ledger.days.first { $0.day == shop.today }
        return SheetCard {
            VStack(alignment: .leading, spacing: 11) {
                HStack {
                    RuleHead(text: "Job of the day")
                    if let record = record {
                        StampTag(text: "\(Int(record.score * 100))",
                                 tone: record.score > 0.78 ? Press.good : Press.brass)
                    }
                }
                Text(job.line).font(Press.title(20)).foregroundColor(Press.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text("From \(job.client).").font(Press.note(13)).foregroundColor(Press.inkSoft)
                HStack(spacing: 7) {
                    FigureBox(value: Foundry.face(job.faceKey).name.components(separatedBy: " ").first ?? "",
                              label: "face")
                    FigureBox(value: "\(job.size) pt", label: "size")
                    FigureBox(value: "\(Int(job.measurePicas))", label: "picas")
                }
                if job.constraint != 0 {
                    NoticeBar(text: job.constraintNote, tone: Press.vermilion)
                }
                Text("On \(Papers.find(job.paperKey).name.lowercased()), in \(Inks.find(job.inkKey).name.lowercased()).")
                    .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                LeverButton(title: done ? "Set it again" : "Go to the stick",
                            tone: done ? Press.inkSoft : Press.oak, filled: !done) {
                    openJob = true
                }
            }
        }
        .rising(1)
    }

    private var standingCard: some View {
        let (name, note, marks, ceiling, _) = shop.rank
        let progress = ceiling > marks ? Double(marks) / Double(max(1, ceiling)) : 1
        return SheetCard {
            VStack(alignment: .leading, spacing: 10) {
                RuleHead(text: "Standing")
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(name).font(Press.title(19)).foregroundColor(Press.ink)
                        Text(note).font(Press.note(11.5)).foregroundColor(Press.inkFaint)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 8)
                    VStack(spacing: 1) {
                        Text("\(shop.liveStreak)").font(Press.title(22)).foregroundColor(Press.brass)
                        Text("DAYS").font(Press.body(8.5)).tracking(1).foregroundColor(Press.inkFaint)
                    }
                }
                MeterBar(label: ceiling > marks ? "To \(Standing.ranks[min(Standing.ranks.count - 1, shop.rankIndex + 1)].1)" : "At the top of the trade",
                         value: progress, tone: Press.oak,
                         caption: ceiling > marks ? "\(marks) of \(ceiling) marks" : "\(marks) marks")
                HStack(spacing: 7) {
                    FigureBox(value: "\(shop.ledger.book.count)", label: "in the book")
                    FigureBox(value: "\(shop.finePulls)", label: "fine pulls")
                    FigureBox(value: "\(shop.ledger.bestStreak)", label: "best run")
                }
            }
        }
        .rising(2)
    }

    private var lastCard: some View {
        Group {
            if let last = shop.ledger.book.max(by: { $0.day < $1.day }) {
                SheetCard(padding: 0) {
                    VStack(spacing: 0) {
                        PrintedSheet(forme: last.forme, face: Foundry.face(last.faceKey),
                                     size: Double(last.size), measurePicas: last.measurePicas,
                                     paperKey: last.paperKey, inkKey: last.inkKey,
                                     secondInk: last.secondInk, pull: last.pull,
                                     ornamentKey: last.ornamentKey)
                            .frame(height: Press.isPad ? 260 : 180)
                            .clipped()
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Last off the rack").font(Press.note(11))
                                    .foregroundColor(Press.inkFaint)
                                Text(last.title).font(Press.title(15)).foregroundColor(Press.ink)
                            }
                            Spacer()
                            StampTag(text: last.grade,
                                     tone: last.score > 0.78 ? Press.good : Press.brass)
                        }
                        .padding(13)
                    }
                }
                .rising(3)
            } else {
                SheetCard {
                    VStack(alignment: .leading, spacing: 9) {
                        RuleHead(text: "The rack is empty")
                        Text("Nothing has been pulled yet. Take a job from the order book, set it, lock it up and print it, and the sheet is bound into the specimen book.")
                            .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        PlateBox(name: "ob_3", height: Press.isPad ? 240 : 170)
                    }
                }
                .rising(3)
            }
        }
    }

    private var wordCard: some View {
        let term = Glossary.all[shop.today % max(1, Glossary.all.count)]
        return SheetCard {
            VStack(alignment: .leading, spacing: 8) {
                RuleHead(text: "A word from the trade", trailing: term.group)
                Text(term.word).font(Press.title(18)).foregroundColor(Press.ink)
                Text(term.meaning).font(Press.body(13)).foregroundColor(Press.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .rising(4)
    }
}

struct HoursPanel: View {
    var onClose: () -> Void
    private let keys = ["sh_h0", "sh_h1", "sh_h2", "sh_h3", "sh_h4", "sh_h5", "sh_h6"]
    private let captions = [
        "Three in the morning. The forme is locked and nothing moves.",
        "Six. The devil has the stove going and the gas is still on.",
        "Nine. North light across the case, the best hour for setting small.",
        "Noon. The beam has crossed to the stone and the shop is at full work.",
        "Three. The light is going yellow and the long jobs go on the press.",
        "Six in the evening. The gas is lit and the window has stopped being useful.",
        "Nine at night. One lamp over the stone and the rest of the shop in the dark."
    ]

    var body: some View {
        ZStack {
            Press.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                PanelHead(title: "The composing room",
                          subtitle: "Seven hours of one working day", onClose: onClose)
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(Array(keys.enumerated()), id: \.offset) { i, key in
                            SheetCard(padding: 0) {
                                VStack(spacing: 0) {
                                    PlateBox(name: key, height: Press.isPad ? 280 : 190, corner: 0)
                                    Text(captions[i]).font(Press.body(12.5))
                                        .foregroundColor(Press.inkSoft)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 24)
                }
                LeverButton(title: "Close", tone: Press.oak) { onClose() }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 16)
            }
        }
    }
}
