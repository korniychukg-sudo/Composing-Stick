import Foundation

let artDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "../Composing Stick/Art"
var failures: [String] = []
var checks = 0

func check(_ ok: Bool, _ message: @autoclosure () -> String) {
    checks += 1
    if !ok { failures.append(message()) }
}

func plateExists(_ name: String) -> Bool {
    FileManager.default.fileExists(atPath: artDir + "/" + name + ".jpg")
}

func duplicates(_ keys: [String]) -> [String] {
    var seen: Set<String> = []
    var dupes: [String] = []
    for k in keys {
        if seen.contains(k) { dupes.append(k) }
        seen.insert(k)
    }
    return dupes
}

@main
struct Validator {
    static func main() {
        print("Composing Stick offline validation")
        print("art from \(artDir)")

        check(duplicates(Orders.all.map { $0.key }).isEmpty, "duplicate commission keys: \(duplicates(Orders.all.map { $0.key }))")
        check(duplicates(Foundry.faces.map { $0.key }).isEmpty, "duplicate face keys")
        check(duplicates(Papers.all.map { $0.key }).isEmpty, "duplicate paper keys")
        check(duplicates(Inks.all.map { $0.key }).isEmpty, "duplicate ink keys")
        check(duplicates(Ornaments.all.map { $0.key }).isEmpty, "duplicate ornament keys")
        check(duplicates(Bench.all.map { $0.key }).isEmpty, "duplicate lesson keys")
        check(duplicates(Glossary.all.map { $0.word }).isEmpty, "duplicate glossary words: \(duplicates(Glossary.all.map { $0.word }))")
        check(duplicates(JobCase.boxes.map { $0.key }).isEmpty, "duplicate case boxes: \(duplicates(JobCase.boxes.map { $0.key }))")

        for c in Orders.all { check(plateExists("cm_" + c.key), "missing plate cm_\(c.key)") }
        for f in Foundry.faces {
            check(plateExists("fa_" + f.key), "missing plate fa_\(f.key)")
            check(plateExists("fd_" + f.key), "missing plate fd_\(f.key)")
        }
        for o in Ornaments.all { check(plateExists("or_" + o.key), "missing plate or_\(o.key)") }
        for s in Papers.all { check(plateExists("pa_" + s.key), "missing plate pa_\(s.key)") }
        for c in Inks.all { check(plateExists("in_" + c.key), "missing plate in_\(c.key)") }
        for l in Bench.all { check(plateExists(l.plate), "missing plate \(l.plate)") }
        for h in 0..<7 { check(plateExists("sh_h\(h)"), "missing plate sh_h\(h)") }
        for p in 0..<4 { check(plateExists("ob_\(p)"), "missing plate ob_\(p)") }

        for c in Orders.all {
            let face = Foundry.face(c.faceKey)
            check(face.key == c.faceKey, "\(c.key) names a face that is not in the foundry: \(c.faceKey)")
            check(Papers.find(c.paperKey).key == c.paperKey, "\(c.key) names an unknown paper \(c.paperKey)")
            check(Inks.find(c.inkKey).key == c.inkKey, "\(c.key) names an unknown ink \(c.inkKey)")
            check(Ornaments.find(c.ornamentKey).key == c.ornamentKey, "\(c.key) names an unknown ornament")
            if let second = c.secondInk {
                check(Inks.find(second).key == second, "\(c.key) names an unknown second ink \(second)")
            }
            if let forbidden = c.forbidFace {
                check(Foundry.faces.contains { $0.key == forbidden }, "\(c.key) forbids a face that does not exist")
                check(forbidden != c.faceKey, "\(c.key) forbids the face it asks for")
            }
            check(!c.copy.isEmpty, "\(c.key) has no copy")
            check(c.rankNeeded >= 0 && c.rankNeeded < Standing.ranks.count, "\(c.key) needs a rank that does not exist")
            check(c.measurePicas >= 8, "\(c.key) has a measure under eight picas")
            for line in c.copy {
                let short = Setter.unavailable(line)
                check(short.isEmpty, "\(c.key) asks for sorts the case does not hold: \(short)")
                let solved = Setter.compose(line, face: face, size: Double(c.size),
                                            measurePicas: c.measurePicas)
                check(solved != nil, "\(c.key) cannot be justified to \(Int(c.measurePicas)) picas: \(line)")
                if let solved = solved {
                    let off = Measure.deficit(solved, face, Double(c.size), measurePicas: c.measurePicas)
                    check(abs(off) < 0.5, "\(c.key) line lands \(off) points off the measure")
                    let letters = solved.filter { !JobCase.spaceKeys.contains($0.key) }
                    check(letters.count == Setter.letters(line).count, "\(c.key) line lost a sort in composition")
                    check(!solved.contains { $0.turned }, "\(c.key) line came out turned")
                }
            }
        }

        var constraintSeen = Array(repeating: 0, count: Daily.constraints.count)
        var dailyFailures = 0
        let seeds = 4000
        for day in 0..<seeds {
            let job = Daily.job(day)
            let face = Foundry.face(job.faceKey)
            constraintSeen[job.constraint] += 1
            check(face.key == job.faceKey, "day \(day) names an unknown face")
            check(Papers.find(job.paperKey).key == job.paperKey, "day \(day) names an unknown paper")
            check(Inks.find(job.inkKey).key == job.inkKey, "day \(day) names an unknown ink")
            check(Ornaments.find(job.ornamentKey).key == job.ornamentKey, "day \(day) names an unknown ornament")
            check(!job.constraintNote.isEmpty, "day \(day) has a constraint with no note")
            check(face.sizes.contains(job.size), "day \(day) asks a size the fount is not cast in")
            if job.constraint == 1 {
                check(!job.line.lowercased().contains("e"), "day \(day) is an empty e box day with an e in the line")
            }
            let banned: Set<String> = job.constraint == 2 ? ["3em"] : []
            let short = Setter.unavailable(job.line)
            check(short.isEmpty, "day \(day) asks for sorts the case does not hold: \(short)")
            let solved = Setter.compose(job.line, face: face, size: Double(job.size),
                                        measurePicas: job.measurePicas, banned: banned)
            if solved == nil { dailyFailures += 1 }
            check(solved != nil, "day \(day) has no exact justification: \(job.line) at \(Int(job.measurePicas)) picas")
            if let solved = solved {
                let off = Measure.deficit(solved, face, Double(job.size), measurePicas: job.measurePicas)
                check(abs(off) < 0.5, "day \(day) lands \(off) points off the measure")
                if job.constraint == 2 {
                    check(!solved.contains { $0.key == "3em" }, "day \(day) used a three to em space that has run out")
                }
            }
        }

        var lastCeiling = -1
        for step in Standing.ranks {
            check(step.0 > lastCeiling, "ranks are not in ascending order")
            lastCeiling = step.0
        }
        check(Standing.rank(0).0 == "Devil", "the first rank is not Devil")
        check(Standing.rank(9_000).0 == "Master Printer", "the last rank is not Master Printer")
        check(Standing.rank(9_000).4 == Standing.ranks.count - 1, "the top rank index is wrong")

        for term in Glossary.all {
            check(Glossary.groups.contains(term.group), "\(term.word) sits in a group that is not listed")
            check(term.meaning.count > 40, "\(term.word) has a meaning too short to be useful")
        }
        for lesson in Bench.all {
            check(lesson.body.count >= 3, "\(lesson.key) has fewer than three paragraphs")
            check(!lesson.title.isEmpty, "a lesson has no title")
        }
        check(Tables.spaces.allSatisfy { $0.ems > 0 }, "a space in the table has no width")
        check(Tables.sizes.allSatisfy { $0.0 > 0 }, "a size in the table is not a size")

        for face in Foundry.faces {
            check(!face.sizes.isEmpty, "\(face.key) is cast in no sizes")
            check(face.sizes.sorted() == face.sizes, "\(face.key) lists its sizes out of order")
        }
        for box in JobCase.boxes where box.kind != 3 && box.kind != 5 {
            if JobCase.isLigature(box.key) {
                for ch in box.key {
                    check(Sorts.shape(String(ch)) != nil,
                          "the \(box.key) ligature needs a \(ch) that is not drawn")
                }
            } else {
                check(Sorts.shape(box.key) != nil, "no glyph is drawn for the \(box.key) box")
            }
        }
        for key in Setter.ladder {
            check(JobCase.box(key) != nil, "the setter reaches for a \(key) that is not a box in the case")
            check(JobCase.spaceKeys.contains(key), "the setter treats \(key) as a space and the app does not")
        }

        let plateFiles = (try? FileManager.default.contentsOfDirectory(atPath: artDir))?.filter { $0.hasSuffix(".jpg") } ?? []

        print("")
        print("commissions      \(Orders.all.count)")
        print("founts           \(Foundry.faces.count)")
        print("ornaments        \(Ornaments.all.count)")
        print("papers           \(Papers.all.count)")
        print("inks             \(Inks.all.count)")
        print("case boxes       \(JobCase.boxes.count)")
        print("glossary terms   \(Glossary.all.count)")
        print("bench lessons    \(Bench.all.count)")
        print("daily seeds      \(seeds), unjustifiable \(dailyFailures)")
        print("constraint spread \(constraintSeen)")
        print("plates on disk   \(plateFiles.count)")
        print("checks run       \(checks)")

        if failures.isEmpty {
            print("")
            print("ALL CHECKS PASSED")
        } else {
            print("")
            print("FAILURES: \(failures.count)")
            for f in failures.prefix(40) { print("  " + f) }
            exit(1)
        }
    }
}
