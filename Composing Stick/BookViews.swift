import SwiftUI

struct SpecimenBookView: View {
    @EnvironmentObject var shop: ShopFloor
    @State private var mode = 0
    @State private var opened: Specimen? = nil

    var body: some View {
        VStack(spacing: 0) {
            SegmentRow(titles: ["The rack", "The book"], index: $mode)
                .padding(.horizontal, Press.gutter)
                .padding(.top, 10)
                .padding(.bottom, 8)
            if shop.ledger.book.isEmpty {
                emptyState
            } else if mode == 0 {
                rackView
            } else {
                bookView
            }
        }
        .background(Press.paper.ignoresSafeArea())
        .sheet(item: $opened) { sheet in
            SpecimenPanel(sheet: sheet) { opened = nil }
        }
    }

    private var emptyState: some View {
        ScrollView {
            Column {
                SheetCard {
                    VStack(alignment: .leading, spacing: 10) {
                        RuleHead(text: "Nothing hung up yet")
                        Text("Every finished job is pulled onto a sheet and hung on the drying rack, then bound into the specimen book with the grade written on the tissue guard opposite. Only the best pull of each job is kept, and a better one replaces it.")
                            .font(Press.body(13)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        PlateBox(name: "ob_3", height: Press.isPad ? 300 : 210)
                    }
                }
            }
            .padding(.horizontal, Press.gutter)
            .padding(.bottom, 26)
        }
    }

    private var rackView: some View {
        ScrollView {
            Column(spacing: 14) {
                SheetCard {
                    VStack(alignment: .leading, spacing: 7) {
                        RuleHead(text: "The drying rack",
                                 trailing: "\(shop.ledger.book.count) of \(Orders.all.count)")
                        Text("Sheets hang here until the ink is dry enough to pile. Tap one to read it.")
                            .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                    }
                }
                let columns = Press.isPad ? 4 : 2
                let rows = stride(from: 0, to: shop.ledger.book.count, by: columns).map {
                    Array(shop.ledger.book[$0..<min($0 + columns, shop.ledger.book.count)])
                }
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    VStack(spacing: 0) {
                        Rectangle().fill(Press.oakDark).frame(height: 4)
                            .shadow(color: Press.ink.opacity(0.2), radius: 2, y: 2)
                        HStack(alignment: .top, spacing: 10) {
                            ForEach(row, id: \.jobKey) { sheet in
                                Button(action: { Knock.light(); opened = sheet }) {
                                    VStack(spacing: 0) {
                                        Rectangle().fill(Press.brass).frame(width: 12, height: 8)
                                        PrintedSheet(forme: sheet.forme,
                                                     face: Foundry.face(sheet.faceKey),
                                                     size: Double(sheet.size),
                                                     measurePicas: sheet.measurePicas,
                                                     paperKey: sheet.paperKey,
                                                     inkKey: sheet.inkKey,
                                                     secondInk: sheet.secondInk,
                                                     pull: sheet.pull,
                                                     ornamentKey: sheet.ornamentKey)
                                            .frame(height: Press.isPad ? 200 : 150)
                                            .clipped()
                                            .overlay(Rectangle().stroke(Press.ink.opacity(0.16), lineWidth: 0.8))
                                            .rotationEffect(.degrees(Double((index * 7 + sheet.jobKey.count) % 5) - 2),
                                                            anchor: .top)
                                        Text(sheet.title).font(Press.body(10)).foregroundColor(Press.inkSoft)
                                            .lineLimit(1).minimumScaleFactor(0.6)
                                            .padding(.top, 6)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            if row.count < columns {
                                ForEach(0..<(columns - row.count), id: \.self) { _ in
                                    Color.clear.frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.top, 2)
                    }
                }
            }
            .padding(.horizontal, Press.gutter)
            .padding(.bottom, 26)
        }
    }

    private var bookView: some View {
        ScrollView {
            Column(spacing: 14) {
                SheetCard {
                    VStack(alignment: .leading, spacing: 7) {
                        RuleHead(text: "The specimen book", trailing: gradeSummary)
                        Text("Each sheet is bound with a tissue guard opposite, and the grade is written on the tissue.")
                            .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                    }
                }
                ForEach(shop.ledger.book, id: \.jobKey) { sheet in
                    Button(action: { Knock.light(); opened = sheet }) {
                        BookSpread(sheet: sheet)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Press.gutter)
            .padding(.bottom, 26)
        }
    }

    private var gradeSummary: String {
        let fine = shop.finePulls
        return fine > 0 ? "\(fine) fine" : "\(shop.ledger.book.count) bound"
    }
}

struct BookSpread: View {
    var sheet: Specimen

    var body: some View {
        SheetCard(padding: 0) {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 7) {
                    Text(sheet.title.uppercased()).font(Press.title(11))
                        .tracking(1.1).foregroundColor(Press.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    Rectangle().fill(Press.ink.opacity(0.16)).frame(height: 0.7)
                    Text(sheet.grade).font(Press.title(15)).foregroundColor(Press.ink)
                    guardRow("register", sheet.register)
                    guardRow("impression", sheet.impression)
                    guardRow("inking", sheet.inking)
                    guardRow("spacing", sheet.spacing)
                    guardRow("accuracy", sheet.accuracy)
                    Text(sheet.note).font(Press.note(10.5)).foregroundColor(Press.inkFaint)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(11)
                .frame(width: 128)
                .background(Press.paperDeep.opacity(0.55))
                Rectangle().fill(Press.ink.opacity(0.12)).frame(width: 1)
                PrintedSheet(forme: sheet.forme, face: Foundry.face(sheet.faceKey),
                             size: Double(sheet.size), measurePicas: sheet.measurePicas,
                             paperKey: sheet.paperKey, inkKey: sheet.inkKey,
                             secondInk: sheet.secondInk, pull: sheet.pull,
                             ornamentKey: sheet.ornamentKey)
                    .frame(height: Press.isPad ? 300 : 210)
                    .clipped()
            }
        }
    }

    private func guardRow(_ label: String, _ value: Double) -> some View {
        HStack(spacing: 5) {
            Text(label).font(Press.body(9.5)).foregroundColor(Press.inkFaint)
            Spacer(minLength: 2)
            ZStack(alignment: .leading) {
                Capsule().fill(Press.ink.opacity(0.09)).frame(width: 34, height: 3.5)
                Capsule().fill(value > 0.8 ? Press.good : Press.brass)
                    .frame(width: max(2, 34 * CGFloat(value)), height: 3.5)
            }
        }
    }
}

struct SpecimenPanel: View {
    let sheet: Specimen
    var onClose: () -> Void

    var body: some View {
        ZStack {
            Press.paper.ignoresSafeArea()
            VStack(spacing: 0) {
                PanelHead(title: sheet.title,
                          subtitle: "\(Foundry.face(sheet.faceKey).name) \(sheet.size) point on \(Papers.find(sheet.paperKey).name)",
                          onClose: onClose)
                ScrollView {
                    VStack(spacing: 13) {
                        SheetCard(padding: 8) {
                            PrintedSheet(forme: sheet.forme, face: Foundry.face(sheet.faceKey),
                                         size: Double(sheet.size), measurePicas: sheet.measurePicas,
                                         paperKey: sheet.paperKey, inkKey: sheet.inkKey,
                                         secondInk: sheet.secondInk, pull: sheet.pull,
                                         ornamentKey: sheet.ornamentKey)
                                .frame(height: Press.isPad ? 560 : 400)
                                .clipped()
                        }
                        SheetCard {
                            VStack(alignment: .leading, spacing: 9) {
                                RuleHead(text: "On the tissue guard", trailing: sheet.grade)
                                MeterBar(label: "Accuracy", value: sheet.accuracy, tone: Press.ink)
                                MeterBar(label: "Spacing", value: sheet.spacing, tone: Press.brass)
                                MeterBar(label: "Lock up", value: sheet.lockup, tone: Press.oak)
                                MeterBar(label: "Inking", value: sheet.inking,
                                         tone: Press.inkColour(sheet.inkKey))
                                MeterBar(label: "Impression", value: sheet.impression,
                                         tone: Press.vermilion)
                                if sheet.secondInk != nil {
                                    MeterBar(label: "Register", value: sheet.register, tone: Press.good)
                                }
                                Text(sheet.note).font(Press.note(12.5)).foregroundColor(Press.inkFaint)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        SheetCard {
                            VStack(alignment: .leading, spacing: 8) {
                                RuleHead(text: "The forme it came from")
                                StickBed(lines: sheet.forme.lines,
                                         face: Foundry.face(sheet.faceKey),
                                         size: Double(sheet.size),
                                         measurePicas: sheet.measurePicas,
                                         activeLine: -1, showNicks: true)
                                    .frame(height: CGFloat(sheet.forme.lines.count) * 40 + 12)
                                Text("The sheet is printed from exactly this, so any sort standing on its head is on the page.")
                                    .font(Press.note(11.5)).foregroundColor(Press.inkFaint)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.horizontal, Press.gutter)
                    .padding(.bottom, 26)
                }
            }
        }
    }
}
