import SwiftUI

struct OrderBookView: View {
    @EnvironmentObject var shop: ShopFloor
    @State private var chosen: Commission? = nil
    @State private var filter = 0

    private var listed: [Commission] {
        switch filter {
        case 1: return Orders.all.filter { shop.specimen($0.key) == nil }
        case 2: return Orders.all.filter { shop.specimen($0.key) != nil }
        default: return Orders.all
        }
    }

    var body: some View {
        ScrollView {
            Column(spacing: 12) {
                SheetCard {
                    VStack(alignment: .leading, spacing: 9) {
                        RuleHead(text: "The order book",
                                 trailing: "\(shop.ledger.book.count) of \(Orders.all.count) printed")
                        Text("Every job names a face, a size, a measure, a paper and a stock of ink. Some forbid a face and some want a second colour. Take any of them, in any order.")
                            .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        SegmentRow(titles: ["All", "Not yet", "In the book"], index: $filter)
                    }
                }
                ForEach(listed, id: \.key) { job in
                    Button(action: { Knock.light(); chosen = job }) {
                        OrderRow(job: job, sheet: shop.specimen(job.key),
                                 locked: job.rankNeeded > shop.rankIndex)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Press.gutter)
            .padding(.bottom, 26)
        }
        .background(Press.paper.ignoresSafeArea())
        .sheet(item: $chosen) { job in
            OrderPanel(job: job) { chosen = nil }.environmentObject(shop)
        }
    }
}

extension Commission: Identifiable {
    public var id: String { key }
}

struct OrderRow: View {
    var job: Commission
    var sheet: Specimen?
    var locked: Bool

    var body: some View {
        SheetCard(padding: 0) {
            HStack(spacing: 0) {
                PlateBox(name: "cm_" + job.key, height: 96, corner: 0)
                    .frame(width: 76)
                    .clipped()
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(job.name).font(Press.title(14)).foregroundColor(Press.ink)
                            .lineLimit(1).minimumScaleFactor(0.7)
                        Spacer(minLength: 2)
                        if let sheet = sheet {
                            StampTag(text: "\(Int(sheet.score * 100))",
                                     tone: sheet.score > 0.78 ? Press.good : Press.brass)
                        } else if locked {
                            StampTag(text: Standing.ranks[job.rankNeeded].1, tone: Press.inkFaint)
                        }
                    }
                    Text(job.client).font(Press.note(11.5)).foregroundColor(Press.inkFaint)
                        .lineLimit(1)
                    Text("\(Foundry.face(job.faceKey).name) \(job.size) pt, \(Int(job.measurePicas)) picas")
                        .font(Press.body(11)).foregroundColor(Press.inkSoft)
                        .lineLimit(1).minimumScaleFactor(0.7)
                    HStack(spacing: 5) {
                        Circle().fill(Press.inkColour(job.inkKey)).frame(width: 8, height: 8)
                            .overlay(Circle().stroke(Press.ink.opacity(0.2), lineWidth: 0.6))
                        if let second = job.secondInk {
                            Circle().fill(Press.inkColour(second)).frame(width: 8, height: 8)
                                .overlay(Circle().stroke(Press.ink.opacity(0.2), lineWidth: 0.6))
                        }
                        Text(Papers.find(job.paperKey).name).font(Press.body(10.5))
                            .foregroundColor(Press.inkFaint).lineLimit(1)
                    }
                }
                .padding(.horizontal, 11)
                .padding(.vertical, 9)
                Spacer(minLength: 0)
            }
        }
    }
}

struct OrderPanel: View {
    let job: Commission
    var onClose: () -> Void
    @EnvironmentObject var shop: ShopFloor
    @State private var compose = false

    var body: some View {
        ZStack {
            Press.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                PanelHead(title: job.name, subtitle: job.client, onClose: onClose)
                ScrollView {
                    VStack(spacing: 13) {
                        PlateBox(name: "cm_" + job.key, height: Press.isPad ? 420 : 300, mode: .fit)
                        SheetCard {
                            VStack(alignment: .leading, spacing: 9) {
                                RuleHead(text: "What is wanted")
                                Text(job.brief).font(Press.body(13.5)).foregroundColor(Press.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                                ForEach(Array(job.copy.enumerated()), id: \.offset) { i, line in
                                    HStack(alignment: .top, spacing: 7) {
                                        Text("\(i + 1)").font(Press.title(10))
                                            .foregroundColor(Press.card)
                                            .frame(width: 15, height: 15)
                                            .background(Circle().fill(Press.ink.opacity(0.6)))
                                        Text(line).font(Press.body(13)).foregroundColor(Press.ink)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                        SheetCard {
                            VStack(alignment: .leading, spacing: 7) {
                                RuleHead(text: "Specification")
                                PairRow(key: "Face", value: "\(Foundry.face(job.faceKey).name) \(job.size) point")
                                PairRow(key: "Measure", value: "\(Int(job.measurePicas)) picas")
                                PairRow(key: "Paper", value: Papers.find(job.paperKey).name)
                                PairRow(key: "Ink", value: Inks.find(job.inkKey).name)
                                if let second = job.secondInk {
                                    PairRow(key: "Second colour", value: Inks.find(second).name)
                                }
                                if let forbid = job.forbidFace {
                                    PairRow(key: "Not to be set in", value: Foundry.face(forbid).name)
                                }
                                PairRow(key: "Ornament", value: Ornaments.find(job.ornamentKey).name)
                                PairRow(key: "Wanted in", value: "\(job.days) days")
                            }
                        }
                        SheetCard {
                            VStack(alignment: .leading, spacing: 8) {
                                RuleHead(text: "About this kind of work")
                                Text(job.history).font(Press.body(13)).foregroundColor(Press.inkSoft)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        if let sheet = shop.specimen(job.key) {
                            SheetCard {
                                VStack(alignment: .leading, spacing: 9) {
                                    RuleHead(text: "In the book", trailing: sheet.grade)
                                    Text(sheet.note).font(Press.note(12.5))
                                        .foregroundColor(Press.inkFaint)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("A better pull replaces it.").font(Press.body(12))
                                        .foregroundColor(Press.inkSoft)
                                }
                            }
                        }
                        if job.rankNeeded > shop.rankIndex {
                            NoticeBar(text: "The foreman gives this one to a \(Standing.ranks[job.rankNeeded].1). You can still set it, and it will still be judged.",
                                      tone: Press.brass)
                        }
                        LeverButton(title: "Take the job", tone: Press.oak) { compose = true }
                    }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 26)
                }
            }
        }
        .fullScreenCover(isPresented: $compose) {
            ComposeView(spec: JobSpec.from(job)).environmentObject(shop)
        }
    }
}
