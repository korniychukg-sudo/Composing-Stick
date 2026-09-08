import SwiftUI

struct ManualView: View {
    @EnvironmentObject var shop: ShopFloor
    @State private var section = 0
    @State private var lesson: Lesson? = nil
    @State private var search = ""
    @State private var group = 0
    @State private var table = 0

    var body: some View {
        VStack(spacing: 0) {
            SegmentRow(titles: ["Bench", "Words", "Tables", "Test"], index: $section)
                .padding(.horizontal, Press.gutter)
                .padding(.top, 10)
                .padding(.bottom, 8)
            ScrollView {
                Column(spacing: 12) {
                    switch section {
                    case 1: wordList
                    case 2: tableList
                    case 3: ProofQuiz()
                    default: lessonList
                    }
                }
                .padding(.horizontal, Press.gutter)
                .padding(.bottom, 26)
            }
        }
        .background(Press.paper.ignoresSafeArea())
        .sheet(item: $lesson) { l in
            LessonPanel(lesson: l) { lesson = nil }.environmentObject(shop)
        }
    }

    private var readLessons: Int { (shop.ledger.readLessons ?? []).count }

    private var lessonList: some View {
        Group {
            SheetCard {
                VStack(alignment: .leading, spacing: 8) {
                    RuleHead(text: "The apprentice's bench",
                             trailing: "\(readLessons) of \(Bench.all.count)")
                    Text("Twelve short lessons on how the trade actually worked, in the order an apprentice met them. Read one before a job and the stick makes more sense.")
                        .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            ForEach(Array(Bench.all.enumerated()), id: \.element.key) { index, l in
                Button(action: { Knock.light(); lesson = l }) {
                    SheetCard(padding: 0) {
                        HStack(spacing: 0) {
                            PlateBox(name: l.plate, height: 84, corner: 0).frame(width: 84)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(l.title).font(Press.title(14.5)).foregroundColor(Press.ink)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(l.body.first ?? "")
                                    .font(Press.body(11.5)).foregroundColor(Press.inkFaint)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal, 11)
                            Spacer(minLength: 0)
                            if (shop.ledger.readLessons ?? []).contains(l.key) {
                                TickMark(size: 13, color: Press.good).padding(.trailing, 12)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
                .rising(min(index, 6))
            }
        }
    }

    private var shownTerms: [Term] {
        let base = group == 0 ? Glossary.all : Glossary.all.filter { $0.group == Glossary.groups[group - 1] }
        let needle = search.trimmingCharacters(in: .whitespaces).lowercased()
        if needle.isEmpty { return base }
        return base.filter { $0.word.lowercased().contains(needle) || $0.meaning.lowercased().contains(needle) }
    }

    private var wordList: some View {
        Group {
            SheetCard {
                VStack(alignment: .leading, spacing: 9) {
                    RuleHead(text: "The trade's own words", trailing: "\(Glossary.all.count)")
                    HStack(spacing: 8) {
                        SearchMark(size: 14, color: Press.inkFaint)
                        TextField("Look one up", text: $search)
                            .font(Press.body(13))
                            .foregroundColor(Press.ink)
                            .disableAutocorrection(true)
                        if !search.isEmpty {
                            Button(action: { Knock.light(); search = "" }) {
                                CrossMark(size: 12, color: Press.inkFaint)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 10).padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Press.ink.opacity(0.05)))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(0..<(Glossary.groups.count + 1), id: \.self) { i in
                                Button(action: { Knock.light(); group = i }) {
                                    Text(i == 0 ? "All" : Glossary.groups[i - 1])
                                        .font(Press.title(11))
                                        .foregroundColor(group == i ? Press.card : Press.inkSoft)
                                        .padding(.horizontal, 10).padding(.vertical, 6)
                                        .background(RoundedRectangle(cornerRadius: 4)
                                                        .fill(group == i ? Press.ink : Press.ink.opacity(0.06)))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            if shownTerms.isEmpty {
                SheetCard {
                    Text("No entry carries that word. The case is deep but it is not endless.")
                        .font(Press.note(13)).foregroundColor(Press.inkFaint)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            ForEach(shownTerms, id: \.word) { t in
                SheetCard {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(t.word).font(Press.title(15)).foregroundColor(Press.ink)
                            Spacer(minLength: 8)
                            Text(t.group.uppercased())
                                .font(Press.body(8.5)).tracking(1.1).foregroundColor(Press.inkFaint)
                        }
                        Text(t.meaning).font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private var tableList: some View {
        Group {
            SheetCard {
                VStack(alignment: .leading, spacing: 9) {
                    RuleHead(text: "Tables kept by the stone")
                    SegmentRow(titles: ["Spaces", "Sizes", "A sort"], index: $table)
                }
            }
            switch table {
            case 1: sizeTable
            case 2: anatomyTable
            default: spaceTable
            }
        }
    }

    private var spaceTable: some View {
        Group {
            SheetCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Every blank in a line is a real piece of metal, cast below printing height so it takes no ink. Their widths are fractions of the em, which is a square of the body.")
                        .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    ForEach(Tables.spaces, id: \.name) { row in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(alignment: .center, spacing: 10) {
                                Text(row.name).font(Press.title(13)).foregroundColor(Press.ink)
                                Spacer(minLength: 6)
                                Rectangle().fill(Press.lead)
                                    .frame(width: max(3, CGFloat(row.ems) * 26), height: 15)
                                    .cornerRadius(1)
                                Text(String(format: "%.2f em", row.ems))
                                    .font(Press.body(11)).foregroundColor(Press.inkFaint)
                                    .frame(width: 58, alignment: .trailing)
                            }
                            Text(row.use).font(Press.note(11.5)).foregroundColor(Press.inkSoft)
                                .fixedSize(horizontal: false, vertical: true)
                            Rectangle().fill(Press.ink.opacity(0.08)).frame(height: 0.7)
                        }
                    }
                }
            }
        }
    }

    private var sizeTable: some View {
        SheetCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("Before the point system every size had a name, and the names survived it. A shop still called ten point long primer long after it stopped being a size of its own.")
                    .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                ForEach(Tables.sizes, id: \.0) { row in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text("\(row.0)").font(Press.title(15)).foregroundColor(Press.brassDeep)
                                .frame(width: 32, alignment: .leading)
                            Text(row.1).font(Press.title(13)).foregroundColor(Press.ink)
                            Spacer(minLength: 0)
                        }
                        Text(row.2).font(Press.note(11.5)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        Rectangle().fill(Press.ink.opacity(0.08)).frame(height: 0.7)
                    }
                }
            }
        }
    }

    private var anatomyTable: some View {
        Group {
            SheetCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("One piece of type, named part by part. Everything below the face exists to hold the face at exactly the right height in exactly the right place.")
                        .font(Press.body(12.5)).foregroundColor(Press.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    PlateBox(name: "dg_anatomy", height: Press.isPad ? 340 : 240, mode: .fit)
                    ForEach(Tables.anatomy, id: \.0) { row in
                        VStack(alignment: .leading, spacing: 3) {
                            Text(row.0).font(Press.title(13)).foregroundColor(Press.ink)
                            Text(row.1).font(Press.body(12)).foregroundColor(Press.inkSoft)
                                .fixedSize(horizontal: false, vertical: true)
                            Rectangle().fill(Press.ink.opacity(0.08)).frame(height: 0.7)
                        }
                    }
                }
            }
        }
    }
}

extension Lesson: Identifiable { public var id: String { key } }

struct LessonPanel: View {
    let lesson: Lesson
    @EnvironmentObject var shop: ShopFloor
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            PanelHead(title: lesson.title, subtitle: "From the bench", onClose: onClose)
            ScrollView {
                Column(spacing: 13) {
                    PlateBox(name: lesson.plate, height: Press.isPad ? 420 : 300, mode: .fit)
                    ForEach(Array(lesson.body.enumerated()), id: \.offset) { _, para in
                        Text(para).font(Press.body(14)).foregroundColor(Press.ink)
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    LeverButton(title: "Back to the bench", tone: Press.oak, filled: false, action: onClose)
                }
                .padding(.horizontal, Press.gutter)
                .padding(.bottom, 28)
            }
        }
        .background(Press.paper.ignoresSafeArea())
        .onAppear { shop.markRead(1, lesson.key) }
    }
}

struct ProofQuiz: View {
    @EnvironmentObject var shop: ShopFloor
    @State private var round: [QuizItem] = []
    @State private var index = 0
    @State private var picked: Int? = nil
    @State private var right = 0

    var body: some View {
        Group {
            if round.isEmpty {
                SheetCard {
                    VStack(alignment: .leading, spacing: 11) {
                        RuleHead(text: "Proof reading")
                        Text("Eight questions drawn fresh from the manual each time, on the words, the sizes, the spaces and the trade. Nothing is lost by getting one wrong.")
                            .font(Press.body(13)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        LeverButton(title: "Pull a proof", tone: Press.oak) { start() }
                    }
                }
            } else if index >= round.count {
                SheetCard {
                    VStack(alignment: .leading, spacing: 11) {
                        RuleHead(text: "Corrected")
                        Text("\(right) of \(round.count) right.")
                            .font(Press.title(23)).foregroundColor(Press.ink)
                        Text(closing).font(Press.body(13)).foregroundColor(Press.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        LeverButton(title: "Set another", tone: Press.oak) { start() }
                        LeverButton(title: "Put it down", tone: Press.inkSoft, filled: false) {
                            round = []; index = 0; picked = nil; right = 0
                        }
                    }
                }
            } else {
                questionCard(round[index])
            }
        }
    }

    private var closing: String {
        switch Double(right) / Double(max(1, round.count)) {
        case 1: return "A clean proof. The reader found nothing to mark."
        case 0.7...: return "A few marks in the margin, and the forme goes back on the stone."
        case 0.4...: return "The reader has been busy. Read the bench lessons again."
        default: return "This one gets set again from the beginning."
        }
    }

    private func questionCard(_ item: QuizItem) -> some View {
        SheetCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    RuleHead(text: "Question \(index + 1) of \(round.count)")
                    StampTag(text: "\(right)", tone: Press.good)
                }
                Text(item.ask).font(Press.title(16)).foregroundColor(Press.ink)
                    .fixedSize(horizontal: false, vertical: true)
                ForEach(Array(item.options.enumerated()), id: \.offset) { i, option in
                    Button(action: { choose(i, item) }) {
                        HStack(alignment: .top, spacing: 9) {
                            Text(option).font(Press.body(13.5)).foregroundColor(tone(i, item))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if picked != nil && i == item.answer {
                                TickMark(size: 13, color: Press.good)
                            } else if picked == i {
                                CrossMark(size: 12, color: Press.alarm)
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 5)
                                        .fill(picked == nil ? Press.ink.opacity(0.04) : shade(i, item)))
                    }
                    .buttonStyle(.plain)
                    .disabled(picked != nil)
                }
                if picked != nil {
                    Text(item.note).font(Press.note(12)).foregroundColor(Press.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    LeverButton(title: index + 1 >= round.count ? "See the marks" : "Next",
                                tone: Press.oak) {
                        picked = nil
                        index += 1
                    }
                }
            }
        }
    }

    private func tone(_ i: Int, _ item: QuizItem) -> Color {
        guard picked != nil else { return Press.ink }
        if i == item.answer { return Press.good }
        if picked == i { return Press.alarm }
        return Press.inkFaint
    }

    private func shade(_ i: Int, _ item: QuizItem) -> Color {
        if i == item.answer { return Press.good.opacity(0.12) }
        if picked == i { return Press.alarm.opacity(0.12) }
        return Press.ink.opacity(0.04)
    }

    private func choose(_ i: Int, _ item: QuizItem) {
        guard picked == nil else { return }
        Knock.light()
        picked = i
        if i == item.answer { right += 1; shop.award(4) }
    }

    private func start() {
        round = QuizMaker.round(8)
        index = 0
        picked = nil
        right = 0
    }
}

struct QuizItem {
    let ask: String
    let options: [String]
    let answer: Int
    let note: String
}

enum QuizMaker {
    static func round(_ count: Int) -> [QuizItem] {
        var out: [QuizItem] = []
        var spins = 0
        var asked: Set<String> = []
        while out.count < count && spins < 200 {
            spins += 1
            let item: QuizItem?
            switch spins % 4 {
            case 1: item = termItem()
            case 2: item = sizeItem()
            case 3: item = spaceItem()
            default: item = faceItem()
            }
            if let item = item, !asked.contains(item.ask) {
                asked.insert(item.ask)
                out.append(item)
            }
        }
        return out
    }

    private static func termItem() -> QuizItem? {
        guard let term = Glossary.all.randomElement() else { return nil }
        var wrong = Glossary.all.filter { $0.word != term.word }.shuffled().prefix(3).map { $0.word }
        wrong.append(term.word)
        let options = wrong.shuffled()
        guard let answer = options.firstIndex(of: term.word) else { return nil }
        let clipped = term.meaning.components(separatedBy: ". ").first ?? term.meaning
        return QuizItem(ask: "Which word means this? " + clipped + ".",
                        options: options, answer: answer,
                        note: term.word + ". " + term.meaning)
    }

    private static func sizeItem() -> QuizItem? {
        guard let row = Tables.sizes.randomElement() else { return nil }
        var wrong = Tables.sizes.filter { $0.0 != row.0 }.shuffled().prefix(3).map { "\($0.0) point" }
        wrong.append("\(row.0) point")
        let options = wrong.shuffled()
        guard let answer = options.firstIndex(of: "\(row.0) point") else { return nil }
        return QuizItem(ask: "How large is the size the trade called " + row.1 + "?",
                        options: options, answer: answer, note: row.2)
    }

    private static func spaceItem() -> QuizItem? {
        guard let row = Tables.spaces.randomElement() else { return nil }
        var wrong = Tables.spaces.filter { $0.name != row.name }.shuffled().prefix(3).map { $0.name }
        wrong.append(row.name)
        let options = wrong.shuffled()
        guard let answer = options.firstIndex(of: row.name) else { return nil }
        return QuizItem(ask: String(format: "Which space is %.2f of an em wide?", row.ems),
                        options: options, answer: answer, note: row.name + ". " + row.use)
    }

    private static func faceItem() -> QuizItem? {
        guard let face = Foundry.faces.randomElement() else { return nil }
        var wrong = Foundry.faces.filter { $0.key != face.key }.shuffled().prefix(3).map { $0.name }
        wrong.append(face.name)
        let options = wrong.shuffled()
        guard let answer = options.firstIndex(of: face.name) else { return nil }
        return QuizItem(ask: "Which fount is this? " + face.cut,
                        options: options, answer: answer, note: face.name + ". " + face.colourNote)
    }
}
