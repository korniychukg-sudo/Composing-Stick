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
        while left >= 0.5 && pass < 600 {
            pass += 1
            var placed = false
            for row in rows where row.1 <= left + 0.0001 {
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

    public static func compose(_ text: String, face: TypeFace, size: Double,
                               measurePicas: Double, banned: Set<String> = [],
                               turnAll: Bool = false) -> [SetSort]? {
        let goal = Measure.picasToPoints(measurePicas)
        let body = naturalWidth(text, face, size)
        if body > goal + 0.0001 { return nil }
        let chars = Array(text)
        var gaps = 0
        for (i, ch) in chars.enumerated() where ch == " " {
            if i > 0 && i < chars.count - 1 { gaps += 1 }
        }
        var slack = goal - body
        var perGap: [String] = []
        if gaps > 0 {
            let share = slack / Double(gaps)
            for row in rungs(size, banned: banned) where row.0 != "quad" {
                if row.1 <= share + 0.0001 { perGap = [row.0]; break }
            }
        }
        let gapWidth = perGap.reduce(0.0) { $0 + JobCase.spaceWidth($1, size) }
        var out: [SetSort] = []
        for ch in chars {
            let s = String(ch)
            if s == " " {
                if !out.isEmpty && !perGap.isEmpty {
                    for key in perGap { out.append(SetSort(key: key)) }
                    slack -= gapWidth
                }
                continue
            }
            out.append(SetSort(key: s, turned: turnAll))
        }
        if slack < -0.0001 { return nil }
        for key in spaceRun(slack, size, banned: banned) { out.append(SetSort(key: key)) }
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
