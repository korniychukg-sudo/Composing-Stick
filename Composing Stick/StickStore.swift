import Foundation
import SwiftUI

struct Specimen: Codable, Hashable, Identifiable {
    var id: String { jobKey }
    var jobKey: String
    var title: String
    var faceKey: String
    var size: Int
    var measurePicas: Double
    var paperKey: String
    var inkKey: String
    var secondInk: String?
    var ornamentKey: String
    var forme: Forme
    var pull: Pull
    var score: Double
    var accuracy: Double
    var spacing: Double
    var lockup: Double
    var inking: Double
    var impression: Double
    var register: Double
    var day: Int
    var note: String

    var grade: String {
        switch score {
        case 0.90...: return "Fine pull"
        case 0.78..<0.90: return "Good"
        case 0.62..<0.78: return "Passable"
        case 0.42..<0.62: return "Rough"
        default: return "Waste"
        }
    }
}

struct DayRecord: Codable, Hashable, Identifiable {
    var id: Int { day }
    var day: Int
    var score: Double
    var faceKey: String
    var line: String
}

struct ShopLedger: Codable {
    var days: [DayRecord] = []
    var book: [Specimen] = []
    var streak: Int = 0
    var bestStreak: Int = 0
    var lastDay: Int = -1
    var marks: Int = 0
    var seenIntro: Bool? = nil
    var hintLevel: Int? = nil
    var readTerms: [String]? = nil
    var readLessons: [String]? = nil
    var readFaces: [String]? = nil
    var readOrnaments: [String]? = nil
    var pulls: Int? = nil
    var wasted: Int? = nil
}

final class ShopFloor: ObservableObject {
    @Published var ledger: ShopLedger { didSet { save() } }
    private let key = "composing.stick.ledger.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(ShopLedger.self, from: data) {
            ledger = decoded
        } else {
            ledger = ShopLedger()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(ledger) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static let epoch: Double = 1_767_225_600
    var today: Int { max(0, Int((Date().timeIntervalSince1970 - ShopFloor.epoch) / 86_400)) }

    var liveStreak: Int {
        guard ledger.lastDay == today || ledger.lastDay == today - 1 else { return 0 }
        return ledger.streak
    }

    var hint: Int {
        get { ledger.hintLevel ?? 2 }
        set { ledger.hintLevel = max(0, min(2, newValue)) }
    }

    var rank: (String, String, Int, Int, Int) { Standing.rank(ledger.marks) }

    var rankIndex: Int { rank.4 }

    func award(_ n: Int) { ledger.marks += n }

    func workedToday() -> Bool { ledger.days.contains { $0.day == today } }

    func record(_ record: DayRecord) {
        ledger.days.removeAll { $0.day == record.day }
        ledger.days.append(record)
        ledger.days.sort { $0.day > $1.day }
        if ledger.days.count > 240 { ledger.days.removeLast(ledger.days.count - 240) }
        if ledger.lastDay != record.day {
            if ledger.lastDay == record.day - 1 { ledger.streak += 1 } else { ledger.streak = 1 }
            ledger.lastDay = record.day
            ledger.bestStreak = max(ledger.bestStreak, ledger.streak)
        }
        award(14 + Int(record.score * 52))
    }

    func hang(_ sheet: Specimen) -> String {
        ledger.pulls = (ledger.pulls ?? 0) + 1
        if sheet.score < 0.42 { ledger.wasted = (ledger.wasted ?? 0) + 1 }
        if let existing = ledger.book.first(where: { $0.jobKey == sheet.jobKey }) {
            if sheet.score > existing.score {
                ledger.book.removeAll { $0.jobKey == sheet.jobKey }
                ledger.book.append(sheet)
                sortBook()
                award(20)
                return "A better pull. It replaces the one in the book."
            }
            award(5)
            return "Not as good as the sheet already in the book, so that one stays."
        }
        ledger.book.append(sheet)
        sortBook()
        award(34)
        return "Hung on the rack to dry, and bound into the book."
    }

    private func sortBook() {
        ledger.book.sort { a, b in
            let ai = Orders.all.firstIndex { $0.key == a.jobKey } ?? 999
            let bi = Orders.all.firstIndex { $0.key == b.jobKey } ?? 999
            return ai < bi
        }
    }

    func specimen(_ jobKey: String) -> Specimen? { ledger.book.first { $0.jobKey == jobKey } }

    func markRead(_ kind: Int, _ key: String) {
        func bump(_ list: [String]?) -> [String]? {
            var seen = list ?? []
            if !seen.contains(key) { seen.append(key); award(3) }
            return seen
        }
        switch kind {
        case 0: ledger.readTerms = bump(ledger.readTerms)
        case 1: ledger.readLessons = bump(ledger.readLessons)
        case 2: ledger.readFaces = bump(ledger.readFaces)
        default: ledger.readOrnaments = bump(ledger.readOrnaments)
        }
    }

    var bestScore: Double { ledger.book.map { $0.score }.max() ?? 0 }
    var finePulls: Int { ledger.book.filter { $0.score >= 0.90 }.count }
}
