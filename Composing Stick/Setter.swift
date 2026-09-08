import Foundation

public enum Setter {
    public static let ladder: [String] = JobCase.boxes.filter { $0.kind == 3 }.map { $0.key }

    public static func rungs(_ size: Double, banned: Set<String>) -> [(String, Double)] {
        ladder.filter { !banned.contains($0) }
            .map { ($0, JobCase.spaceWidth($0, size)) }
            .filter { $0.1 > 0.0001 }
            .sorted { $0.1 > $1.1 }
    }

    public static func letters(_ text: String) -> [String] {
        Array(text).filter { $0 != " " }.map { String($0) }
    }

    public static func unavailable(_ text: String) -> [String] {
        var out: [String] = []
        for ch in letters(text) {
            if JobCase.box(ch) == nil { out.append(ch); continue }
            if Sorts.shape(ch) == nil { out.append(ch) }
        }
        return out
    }

    public static func naturalWidth(_ text: String, _ face: TypeFace, _ size: Double) -> Double {
        letters(text).reduce(0.0) { $0 + Measure.sortWidth($1, face, size) }
    }

    public static func spaceRun(_ points: Double, _ size: Double, banned: Set<String>) -> [String] {
        var out: [String] = []
        var left = points
        var pass = 0
        let rows = rungs(size, banned: banned)
        while left >= 0.45 && pass < 600 {
            pass += 1
            var placed = false
            for row in rows where row.1 <= left + 0.002 {
                out.append(row.0)
                left -= row.1
                placed = true
                break
            }
            if !placed { break }
        }
        return out
    }

    public static func residual(_ line: [SetSort], _ face: TypeFace, _ size: Double,
                                measurePicas: Double) -> Double {
        Measure.deficit(line, face, Double(size), measurePicas: measurePicas)
    }

    public static func fill(_ points: Double, _ size: Double,
                            banned: Set<String>) -> ([String], Double) {
        let keys = spaceRun(points, size, banned: banned)
        let total = keys.reduce(0.0) { $0 + JobCase.spaceWidth($1, size) }
        return (keys, total)
    }

    public static func compose(_ text: String, face: TypeFace, size: Double,
                               measurePicas: Double, banned: Set<String> = [],
                               turnAll: Bool = false) -> [SetSort]? {
        let goal = Measure.picasToPoints(measurePicas)
        let body = naturalWidth(text, face, size)
        if body > goal + 0.0001 { return nil }
        let chars = Array(text)
        var gapAt: Set<Int> = []
        for (i, ch) in chars.enumerated() where ch == " " {
            if i > 0 && i < chars.count - 1 { gapAt.insert(i) }
        }
        let slack = goal - body
        let gaps = gapAt.count
        var wordSpace = 0.0
        var lead = 0.0
        if gaps > 0 {
            let share = slack / Double(gaps)
            let roomy = size * 0.56
            wordSpace = share > roomy ? size * 0.38 : share
            let rest = slack - wordSpace * Double(gaps)
            if rest > size * 0.5 { lead = rest * 0.5 }
        } else if slack > size * 0.5 {
            lead = slack * 0.5
        }

        var out: [SetSort] = []
        if lead > 0.5 {
            let (keys, _) = fill(lead, size, banned: banned)
            for key in keys { out.append(SetSort(key: key)) }
        }
        var wanted = 0.0
        var spent = 0.0
        for (i, ch) in chars.enumerated() {
            let s = String(ch)
            if s == " " {
                guard gapAt.contains(i) else { continue }
                wanted += wordSpace
                let (keys, got) = fill(max(0, wanted - spent), size, banned: banned)
                for key in keys { out.append(SetSort(key: key)) }
                spent += got
                continue
            }
            out.append(SetSort(key: s, turned: turnAll))
        }
        let short = Measure.deficit(out, face, size, measurePicas: measurePicas)
        if short < -0.0001 { return nil }
        if short >= 0.5 {
            let (keys, _) = fill(short, size, banned: banned)
            for key in keys { out.append(SetSort(key: key)) }
        }
        let off = Measure.deficit(out, face, size, measurePicas: measurePicas)
        if abs(off) >= 0.5 { return nil }
        return out
    }

    public static func canSet(_ text: String, face: TypeFace, size: Double,
                              measurePicas: Double, banned: Set<String> = []) -> Bool {
        if !unavailable(text).isEmpty { return false }
        return compose(text, face: face, size: size, measurePicas: measurePicas, banned: banned) != nil
    }

    public static func fillForme(_ copy: [String], face: TypeFace, size: Double,
                                 measurePicas: Double, banned: Set<String> = [],
                                 turnAll: Bool = false) -> Forme {
        var forme = Forme()
        for line in copy {
            forme.lines.append(compose(line, face: face, size: size, measurePicas: measurePicas,
                                       banned: banned, turnAll: turnAll) ?? [])
        }
        return forme
    }
}
