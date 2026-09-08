import Foundation

public struct CaseBox: Hashable {
    public let key: String
    public let label: String
    public let x: Double
    public let y: Double
    public let w: Double
    public let h: Double
    public let kind: Int
    public let note: String
}

public enum Frame {
    public static let unitsWide = 36.0
    public static let unitsTall = 8.0
    public static let leftWide = 22.0
}

public enum JobCase {
    private static let rowA: [(String, Double, Int, String)] = [
        ("ffi", 1.0, 4, "The three letter ligature. One sort, cast as one piece."),
        ("fl", 1.0, 4, "Ligature. Kept here because the f kerns over the l."),
        ("5em", 1.0, 3, "Five to em space, a fifth of the body. The finest of the ordinary spaces."),
        ("ffl", 1.0, 4, "Ligature, the rarest of the four."),
        ("ff", 1.0, 4, "Ligature. Two f sorts side by side would foul each other's kerns."),
        ("k", 1.1, 0, "Low frequency, so a small box in the top corner."),
        ("1", 1.0, 1, "Figures run along the top of the case."),
        ("2", 1.0, 1, "Figures run along the top of the case."),
        ("3", 1.0, 1, "Figures run along the top of the case."),
        ("4", 1.0, 1, "Figures run along the top of the case."),
        ("5", 1.0, 1, "Figures run along the top of the case."),
        ("6", 1.0, 1, "Figures run along the top of the case."),
        ("7", 1.0, 1, "Figures run along the top of the case."),
        ("8", 1.0, 1, "Figures run along the top of the case.")
    ]

    private static let rowB: [(String, Double, Int, String)] = [
        ("j", 1.00, 0, "Rare, and a late arrival in the alphabet."),
        ("b", 1.15, 0, "Mirror of d. Reaching into the wrong one is the classic error."),
        ("c", 1.35, 0, "Common enough to earn a wide box."),
        ("d", 1.40, 0, "Mirror of b. Read the nick, not the letter."),
        ("e", 2.30, 0, "The largest box in the case, because e is the commonest letter in English."),
        ("i", 1.50, 0, "Common, and narrow, so the box holds a great many."),
        ("s", 1.50, 0, "Common."),
        ("f", 1.15, 0, "Kerns over the next sort, which is why the ligatures exist."),
        ("g", 1.10, 0, "Has a descender, so the body is deeper than the face."),
        ("9", 0.85, 1, "Figures."),
        ("0", 0.85, 1, "Figures.")
    ]

    private static let rowC: [(String, Double, Int, String)] = [
        ("?", 0.85, 2, "Point of interrogation. Set with a thin space before it in English work."),
        ("l", 1.15, 0, "Reads as a one and as a capital I to the unwary."),
        ("m", 1.20, 0, "The widest of the lowercase, and the origin of the em."),
        ("n", 1.60, 0, "Rotation of u. Turned in the stick it prints as a u."),
        ("h", 1.35, 0, "Common."),
        ("o", 1.70, 0, "Common and symmetrical, so the nick is the only guide to which way up it goes."),
        ("y", 1.00, 0, "Descender."),
        ("p", 1.00, 0, "Mirror of q. Where the phrase mind your p's and q's is said to come from."),
        ("w", 1.05, 0, "Wide, and slow to set."),
        (",", 0.95, 2, "Comma. Sits on the body low, under the baseline."),
        ("en", 1.00, 3, "En quad, half the body square. Used after a full point in old work."),
        ("em", 1.10, 3, "Em quad, the body square. The unit the whole system is named for.")
    ]

    private static let rowD: [(String, Double, Int, String)] = [
        ("z", 0.80, 0, "The smallest box in the case, and it is still rarely empty."),
        ("v", 0.90, 0, "Rare."),
        ("u", 1.30, 0, "Rotation of n. If the nick is down it prints as an n."),
        ("t", 1.70, 0, "Second commonest letter."),
        ("3em", 2.40, 3, "Three to em space, a third of the body. The ordinary word space, and the box is large because nothing is used more."),
        ("a", 2.00, 0, "Third commonest letter, and a wide box."),
        ("r", 1.50, 0, "Common."),
        (";", 0.80, 2, "Semicolon."),
        (":", 0.80, 2, "Colon."),
        (".", 0.95, 2, "Full point."),
        ("quad", 1.30, 3, "Two em quad, for indenting and for filling out a short last line.")
    ]

    private static let rowE: [(String, Double, Int, String)] = [
        ("x", 0.85, 0, "Rare."),
        ("q", 0.85, 0, "Mirror of p, and the other half of the old warning."),
        ("4em", 1.40, 3, "Four to em space, a quarter of the body."),
        ("hair", 1.20, 3, "Hair space, about a twelfth of the body. Used to tease a stubborn line into its measure."),
        ("-", 1.00, 2, "Hyphen."),
        ("'", 0.90, 2, "Apostrophe."),
        ("!", 0.85, 2, "Point of admiration."),
        ("(", 0.80, 2, "Parenthesis."),
        (")", 0.80, 2, "Parenthesis."),
        ("*", 0.80, 2, "Asterisk."),
        ("/", 0.80, 2, "Solidus."),
        ("brass", 1.10, 3, "Brass thin space, exactly one point wide whatever the body. Kept in a separate box because it is not made of type metal."),
        ("copper", 1.10, 3, "Copper thin space, half a point. The last resort when a line will not come exactly to the measure."),
        ("lead", 1.40, 5, "Leads, two point strips of soft type metal laid between lines. The origin of the word leading."),
        ("slug", 1.40, 5, "Slugs, six point strips, for wider white between lines.")
    ]

    private static let capRows: [[String]] = [
        ["A", "B", "C", "D", "E", "F", "G"],
        ["H", "I", "K", "L", "M", "N", "O"],
        ["P", "Q", "R", "S", "T", "V", "W"],
        ["X", "Y", "Z", "J", "U", "&", "\u{2014}"]
    ]

    public static let boxes: [CaseBox] = build()

    private static func build() -> [CaseBox] {
        var out: [CaseBox] = []
        let rows: [([(String, Double, Int, String)], Double, Double)] = [
            (rowA, 0.00, 1.40), (rowB, 1.40, 1.62), (rowC, 3.02, 1.62),
            (rowD, 4.64, 1.68), (rowE, 6.32, 1.68)
        ]
        for (row, top, height) in rows {
            let total = row.reduce(0.0) { $0 + $1.1 }
            var x = 0.0
            for entry in row {
                let w = entry.1 / total * Frame.leftWide
                out.append(CaseBox(key: entry.0, label: display(entry.0), x: x, y: top,
                                   w: w, h: height, kind: entry.2, note: entry.3))
                x += w
            }
        }
        let capW = (Frame.unitsWide - Frame.leftWide) / 7
        let capH = Frame.unitsTall / 4
        for (r, row) in capRows.enumerated() {
            for (c, key) in row.enumerated() {
                out.append(CaseBox(key: key, label: display(key),
                                   x: Frame.leftWide + Double(c) * capW,
                                   y: Double(r) * capH, w: capW, h: capH,
                                   kind: key == "&" || key == "\u{2014}" ? 2 : 0,
                                   note: capNote(key)))
            }
        }
        return out
    }

    private static func capNote(_ key: String) -> String {
        switch key {
        case "J": return "J sits after Z because it was not a separate letter when the case was laid out, and nobody wanted to move everything along."
        case "U": return "U keeps company with J after Z for the same reason."
        case "&": return "The ampersand, a ligature of e and t that outlived its own alphabet."
        case "\u{2014}": return "Em rule, the length of the body."
        case "I": return "There is no separate box for a capital J between I and K in the old order."
        default: return "Capitals sit in the right hand third of the case in alphabetical order, in boxes all the same size."
        }
    }

    public static func display(_ key: String) -> String {
        switch key {
        case "em": return "em quad"
        case "en": return "en quad"
        case "3em": return "3 to em"
        case "4em": return "4 to em"
        case "5em": return "5 to em"
        case "hair": return "hair"
        case "quad": return "2 em"
        case "brass": return "brass"
        case "copper": return "copper"
        case "lead": return "leads"
        case "slug": return "slugs"
        default: return key
        }
    }

    public static func box(_ key: String) -> CaseBox? { boxes.first { $0.key == key } }

    public static let spaceKeys = ["quad", "em", "en", "3em", "4em", "5em", "hair", "brass", "copper"]

    public static func spaceEms(_ key: String) -> Double {
        switch key {
        case "em": return 1.0
        case "en": return 0.5
        case "3em": return 1.0 / 3.0
        case "4em": return 0.25
        case "5em": return 0.2
        case "hair": return 1.0 / 12.0
        case "quad": return 2.0
        default: return 0
        }
    }

    public static func spaceWidth(_ key: String, _ size: Double) -> Double {
        switch key {
        case "brass": return 1.0
        case "copper": return 0.5
        default: return spaceEms(key) * size
        }
    }

    public static func isLigature(_ key: String) -> Bool {
        key == "ffi" || key == "fl" || key == "ffl" || key == "ff"
    }

    public static func ligatureText(_ key: String) -> String { key }

    public static let confusables: [String: String] = [
        "b": "d", "d": "b", "p": "q", "q": "p", "n": "u", "u": "n"
    ]

    public static func boxFor(_ ch: String) -> CaseBox? {
        if let hit = box(ch) { return hit }
        return nil
    }
}

public struct Stock: Hashable {
    public let key: String
    public let name: String
    public let thickness: Double
    public let absorbency: Double
    public let smoothness: Double
    public let softness: Double
    public let tone: Int
    public let note: String
    public let bestDepth: Double
    public let depthWindow: Double
}

public enum Papers {
    private static let batchOne: [Stock] = [
        Stock(key: "laid", name: "Laid Book", thickness: 0.42, absorbency: 0.52, smoothness: 0.54,
              softness: 0.46, tone: 0,
              note: "The chain and laid lines are the marks of the mould's wires and show through the print. Ordinary, forgiving, and what most jobbing work was printed on.",
              bestDepth: 0.42, depthWindow: 0.26),
        Stock(key: "wove", name: "Wove Writing", thickness: 0.38, absorbency: 0.44, smoothness: 0.76,
              softness: 0.34, tone: 1,
              note: "A woven wire mould gives an even sheet with no laid lines. Smooth enough for a modern face, hard enough that a deep impression will show on the back.",
              bestDepth: 0.34, depthWindow: 0.22),
        Stock(key: "rag", name: "Cotton Rag", thickness: 0.86, absorbency: 0.58, smoothness: 0.60,
              softness: 0.88, tone: 2,
              note: "Thick, soft and made from cloth rather than wood. Takes a deep bite without breaking, which is why every modern letterpress shop uses it.",
              bestDepth: 0.72, depthWindow: 0.34),
        Stock(key: "news", name: "Newsprint", thickness: 0.24, absorbency: 0.88, smoothness: 0.36,
              softness: 0.52, tone: 3,
              note: "Cheap, absorbent groundwood. Ink spreads into it, so the counters close and the hairlines thicken. Yellows within the year.",
              bestDepth: 0.30, depthWindow: 0.24),
        Stock(key: "blotter", name: "Blotting Paper", thickness: 0.74, absorbency: 0.96, smoothness: 0.22,
              softness: 0.82, tone: 4,
              note: "Unsized, so it drinks. Used under the tympan and as a novelty stock. Anything fine printed on it turns to a smudge.",
              bestDepth: 0.56, depthWindow: 0.40),
        Stock(key: "cover", name: "Coloured Cover", thickness: 0.78, absorbency: 0.40, smoothness: 0.62,
              softness: 0.60, tone: 5,
              note: "Dyed in the pulp and heavier than text stock. Black on it looks weak, which is what opaque white ink is for.",
              bestDepth: 0.58, depthWindow: 0.28)
    ]

    private static let batchTwo: [Stock] = [
        Stock(key: "deckle", name: "Handmade Deckle", thickness: 0.92, absorbency: 0.64, smoothness: 0.42,
              softness: 0.94, tone: 6,
              note: "Made a sheet at a time in a mould, with the ragged deckle edge where the pulp met the frame. Very soft, so it takes an impression you can read with your thumb.",
              bestDepth: 0.80, depthWindow: 0.32),
        Stock(key: "bristol", name: "Bristol Board", thickness: 0.66, absorbency: 0.22, smoothness: 0.92,
              softness: 0.16, tone: 1,
              note: "Several thin sheets pasted together and calendered hard. Nothing sinks in, so it holds the finest hairline, and nothing gives, so a deep impression cracks the surface.",
              bestDepth: 0.24, depthWindow: 0.18),
        Stock(key: "kraft", name: "Kraft Wrapping", thickness: 0.58, absorbency: 0.70, smoothness: 0.28,
              softness: 0.66, tone: 7,
              note: "Coarse unbleached fibre with visible shive. Small sizes break up on it, which is why it suits wood letter and nothing else.",
              bestDepth: 0.54, depthWindow: 0.30),
        Stock(key: "india", name: "India Paper", thickness: 0.14, absorbency: 0.50, smoothness: 0.80,
              softness: 0.30, tone: 1,
              note: "Bible paper, opaque out of all proportion to its thickness. A heavy impression punches straight through it.",
              bestDepth: 0.20, depthWindow: 0.14),
        Stock(key: "enamel", name: "Coated Enamel", thickness: 0.52, absorbency: 0.12, smoothness: 0.98,
              softness: 0.20, tone: 1,
              note: "Clay coated and glazed. The ink sits on the surface and takes a day to dry, so the sheets set off on each other in the pile.",
              bestDepth: 0.22, depthWindow: 0.16),
        Stock(key: "gampi", name: "Thin Gampi", thickness: 0.10, absorbency: 0.34, smoothness: 0.70,
              softness: 0.72, tone: 8,
              note: "A Japanese bast fibre, translucent and astonishingly strong for its weight. It will take a fine impression and show it on both sides at once.",
              bestDepth: 0.26, depthWindow: 0.18)
    ]

    public static let all: [Stock] = batchOne + batchTwo

    public static func find(_ key: String) -> Stock { all.first { $0.key == key } ?? all[0] }
}

public struct Colour: Hashable {
    public let key: String
    public let name: String
    public let tack: Double
    public let opacity: Double
    public let overprints: Bool
    public let note: String
    public let tone: Int
}

public enum Inks {
    private static let batchOne: [Colour] = [
        Colour(key: "black", name: "Letterpress Black", tack: 0.62, opacity: 0.96, overprints: false,
               note: "Rubber based, slow to skin over, and the ink a shop actually lives on. Dries by absorption, so the stock decides how dense it ends up.", tone: 0),
        Colour(key: "denseblack", name: "Dense Oil Black", tack: 0.82, opacity: 1.00, overprints: false,
               note: "Stiffer and blacker, milled with more pigment. High tack, so it will pick the surface off a soft sheet if the impression is heavy.", tone: 1),
        Colour(key: "vermilion", name: "Vermilion", tack: 0.58, opacity: 0.88, overprints: false,
               note: "The traditional second colour, used for rubrics and initial letters since long before printing. Warm, slightly transparent, and it goes muddy over black.", tone: 2),
        Colour(key: "crimson", name: "Transparent Crimson", tack: 0.44, opacity: 0.46, overprints: true,
               note: "Made to print over another colour. Laid over prussian blue in register it gives a true violet, which is the whole point of a two colour job.", tone: 3),
        Colour(key: "prussian", name: "Transparent Prussian", tack: 0.46, opacity: 0.48, overprints: true,
               note: "The other half of the overprinting pair. Very strong tinting, so a trace of it kills a warm colour.", tone: 4)
    ]

    private static let batchTwo: [Colour] = [
        Colour(key: "green", name: "Bottle Green", tack: 0.60, opacity: 0.90, overprints: false,
               note: "Deep and cool. Reads almost black at small sizes, which is a good reason to keep it for rules and ornament.", tone: 5),
        Colour(key: "ochre", name: "Yellow Ochre", tack: 0.54, opacity: 0.78, overprints: false,
               note: "An earth pigment, gentle and slightly chalky. Weak on white stock and lovely on buff.", tone: 6),
        Colour(key: "warmgrey", name: "Warm Grey", tack: 0.50, opacity: 0.84, overprints: false,
               note: "Black let down with white and a little umber. Used for a second impression that must not compete with the first.", tone: 7),
        Colour(key: "white", name: "Opaque White", tack: 0.74, opacity: 0.94, overprints: false,
               note: "Titanium white, thick and short. The only way to get a light line onto a dark cover stock, and it wants two passes.", tone: 8),
        Colour(key: "mauve", name: "Mauve", tack: 0.52, opacity: 0.82, overprints: false,
               note: "The first aniline colour, and a nineteenth century craze. Fades in daylight, which is why so few surviving sheets still show it.", tone: 9)
    ]

    public static let all: [Colour] = batchOne + batchTwo

    public static func find(_ key: String) -> Colour { all.first { $0.key == key } ?? all[0] }
}

public struct Flower: Hashable {
    public let key: String
    public let name: String
    public let family: String
    public let kind: Int
    public let note: String
}

public enum Ornaments {
    private static let setOne: [Flower] = [
        Flower(key: "acorn", name: "Acorn", family: "Printer's flowers", kind: 0,
               note: "A cast ornament on a type body, so it sets in the line with the letters and locks up with them."),
        Flower(key: "oakleaf", name: "Oak Leaf", family: "Printer's flowers", kind: 0,
               note: "Flowers were cast in matching sets so a compositor could build a border out of one repeated sort."),
        Flower(key: "rosette", name: "Rosette", family: "Printer's flowers", kind: 0,
               note: "Four fold symmetry, so it reads the same whichever way up it goes into the stick."),
        Flower(key: "fleuron", name: "Fleuron", family: "Printer's flowers", kind: 0,
               note: "The aldine leaf, the oldest printer's flower still in use, and the origin of the whole family."),
        Flower(key: "vine", name: "Vine Sprig", family: "Printer's flowers", kind: 0,
               note: "Cast left handed and right handed so a run of them curls both ways."),
        Flower(key: "thistle", name: "Thistle", family: "Printer's flowers", kind: 0,
               note: "A national emblem sort, kept by Scottish shops for obvious work."),
        Flower(key: "ivy", name: "Ivy Leaf", family: "Printer's flowers", kind: 0,
               note: "The hedera, used as a paragraph mark in manuscripts long before it was cast in metal."),
        Flower(key: "tulip", name: "Tulip", family: "Printer's flowers", kind: 0,
               note: "A Dutch flower from a Dutch foundry, and it dates a sheet as surely as a watermark.")
    ]

    private static let setTwo: [Flower] = [
        Flower(key: "laurel", name: "Laurel Spray", family: "Printer's flowers", kind: 0,
               note: "Cast in pairs to face one another around a name."),
        Flower(key: "wreath", name: "Wreath", family: "Printer's flowers", kind: 0,
               note: "A single large sort, usually on a body of two or three ems."),
        Flower(key: "palmette", name: "Palmette", family: "Printer's flowers", kind: 0,
               note: "Greek ornament by way of the architects, and a favourite of the nineteenth century founders."),
        Flower(key: "anthemion", name: "Anthemion", family: "Printer's flowers", kind: 0,
               note: "Honeysuckle, alternating with the palmette in a classical band."),
        Flower(key: "arabesque", name: "Arabesque", family: "Printer's flowers", kind: 0,
               note: "The interlacing kind, which only works if every sort in the run is the same way up."),
        Flower(key: "shell", name: "Scallop Shell", family: "Printer's flowers", kind: 0,
               note: "A pilgrim badge and a rococo motif, and a good corner piece."),
        Flower(key: "scroll", name: "Scroll", family: "Printer's flowers", kind: 0,
               note: "Cast to butt against its own mirror image."),
        Flower(key: "cartouche", name: "Cartouche", family: "Printer's flowers", kind: 0,
               note: "A frame sort with a blank centre, meant to have a small letter set into it.")
    ]

    private static let setThree: [Flower] = [
        Flower(key: "star6", name: "Six Point Star", family: "Devices", kind: 1,
               note: "A jobbing sort, used as a separator and to fill a short line."),
        Flower(key: "sunburst", name: "Sunburst", family: "Devices", kind: 1,
               note: "Rays cast on a square body, the fastest way to make a bill look loud."),
        Flower(key: "lozenge", name: "Lozenge", family: "Devices", kind: 1,
               note: "A plain diamond, and the least tiring ornament in the case."),
        Flower(key: "quatrefoil", name: "Quatrefoil", family: "Devices", kind: 1,
               note: "Four lobes, from the mason's tracery."),
        Flower(key: "trefoil", name: "Trefoil", family: "Devices", kind: 1,
               note: "Three lobes, and it has a right way up, so watch the nick."),
        Flower(key: "crown", name: "Crown", family: "Devices", kind: 1,
               note: "Kept by shops that did official work, and not to be used lightly."),
        Flower(key: "anchor", name: "Anchor", family: "Devices", kind: 1,
               note: "A port town shop's sort, for shipping notices and sailing bills."),
        Flower(key: "bee", name: "Bee", family: "Devices", kind: 1,
               note: "A private press device, and the sort of thing a shop cut for itself.")
    ]

    private static let setFour: [Flower] = [
        Flower(key: "fist", name: "Fist", family: "Marks", kind: 2,
               note: "The manicule, a pointing hand. It survives from the margins of medieval manuscripts and it means look here."),
        Flower(key: "pilcrow", name: "Pilcrow", family: "Marks", kind: 2,
               note: "The paragraph mark, originally rubricated by hand after the black was printed."),
        Flower(key: "dagger", name: "Dagger", family: "Marks", kind: 2,
               note: "The obelus, second in the order of reference marks after the asterisk."),
        Flower(key: "doubledagger", name: "Double Dagger", family: "Marks", kind: 2,
               note: "Third in the order. After it come the section mark, the parallel and the paragraph."),
        Flower(key: "asterism", name: "Asterism", family: "Marks", kind: 2,
               note: "Three asterisks in a triangle, set between sections. Almost extinct by 1900."),
        Flower(key: "section", name: "Section Mark", family: "Marks", kind: 2,
               note: "Two S shapes overlaid, for divisions of a legal text."),
        Flower(key: "torch", name: "Torch", family: "Marks", kind: 2,
               note: "An emblem sort for title pages and prize certificates."),
        Flower(key: "lyre", name: "Lyre", family: "Marks", kind: 2,
               note: "The musician's device, kept for concert bills and hymn sheets.")
    ]

    private static let setFive: [Flower] = [
        Flower(key: "ruleplain", name: "Plain Rule", family: "Rules and borders", kind: 3,
               note: "Brass rule, cut to length with a rule cutter. Type high, and it prints a line."),
        Flower(key: "ruledouble", name: "Double Rule", family: "Rules and borders", kind: 3,
               note: "Two lines cast on one body, so they cannot get out of parallel."),
        Flower(key: "rulewave", name: "Wave Rule", family: "Rules and borders", kind: 3,
               note: "A swelled and waved brass, and the mark of a shop showing off."),
        Flower(key: "ruledotted", name: "Dotted Rule", family: "Rules and borders", kind: 3,
               note: "For a leader, running the eye from a name to a price."),
        Flower(key: "ruleswelled", name: "Swelled Rule", family: "Rules and borders", kind: 3,
               note: "Thick in the middle, tapering to nothing at each end. The Victorian sub heading."),
        Flower(key: "borderchain", name: "Chain Border", family: "Rules and borders", kind: 3,
               note: "A border sort with corner pieces cast to match, so the mitre is exact."),
        Flower(key: "bordergreek", name: "Greek Key Border", family: "Rules and borders", kind: 3,
               note: "The meander, and it will not turn a corner without its own corner sort."),
        Flower(key: "borderleaf", name: "Leaf Border", family: "Rules and borders", kind: 3,
               note: "The commonest border in a jobbing case, and the reason so many bills look alike.")
    ]

    public static let all: [Flower] = setOne + setTwo + setThree + setFour + setFive

    public static func find(_ key: String) -> Flower { all.first { $0.key == key } ?? all[0] }
}

public struct SetSort: Codable, Hashable {
    public var key: String
    public var turned: Bool
    public var wrong: Bool

    public init(key: String, turned: Bool = false, wrong: Bool = false) {
        self.key = key
        self.turned = turned
        self.wrong = wrong
    }
}

public struct Forme: Codable, Hashable {
    public var lines: [[SetSort]] = []
    public var leadingKeys: [String] = []

    public init(lines: [[SetSort]] = [], leadingKeys: [String] = []) {
        self.lines = lines
        self.leadingKeys = leadingKeys
    }
}

public enum Measure {
    public static let pointsPerPica = 12.0

    public static func picasToPoints(_ picas: Double) -> Double { picas * pointsPerPica }

    public static func sortWidth(_ key: String, _ face: TypeFace, _ size: Double) -> Double {
        if JobCase.spaceKeys.contains(key) { return JobCase.spaceWidth(key, size) }
        if key == "lead" || key == "slug" { return 0 }
        if JobCase.isLigature(key) {
            var total = 0.0
            for ch in key { total += Forge.setWidth(String(ch), face) / EmBox.unit * size }
            return total * 0.86
        }
        return Forge.setWidth(key, face) / EmBox.unit * size
    }

    public static func lineWidth(_ line: [SetSort], _ face: TypeFace, _ size: Double) -> Double {
        line.reduce(0.0) { $0 + sortWidth($1.key, face, size) }
    }

    public static func deficit(_ line: [SetSort], _ face: TypeFace, _ size: Double,
                               measurePicas: Double) -> Double {
        picasToPoints(measurePicas) - lineWidth(line, face, size)
    }

    public static func spellDeficit(_ points: Double) -> String {
        if abs(points) < 0.5 { return "exact" }
        if points > 0 {
            return String(format: "%.1f pt loose", points)
        }
        return String(format: "%.1f pt over", -points)
    }

    public static func looseWord(_ points: Double) -> String {
        let a = abs(points)
        if a < 0.5 { return "exact" }
        if a < 2 { return points > 0 ? "a shade loose" : "a shade tight" }
        if a < 6 { return points > 0 ? "loose" : "tight" }
        return points > 0 ? "far too loose" : "far too tight"
    }
}

public struct Pull: Codable, Hashable {
    public var quoin: Double
    public var inking: Double
    public var depth: Double
    public var registerOffset: Double
    public var makeready: Double

    public init(quoin: Double = 0.5, inking: Double = 0.5, depth: Double = 0.5,
                registerOffset: Double = 0, makeready: Double = 0) {
        self.quoin = quoin
        self.inking = inking
        self.depth = depth
        self.registerOffset = registerOffset
        self.makeready = makeready
    }
}

public struct Verdict: Codable, Hashable {
    public var accuracy: Double
    public var spacing: Double
    public var lockup: Double
    public var inking: Double
    public var impression: Double
    public var register: Double
    public var total: Double
    public var faults: [String]

    public var grade: String {
        switch total {
        case 0.90...: return "Fine pull"
        case 0.78..<0.90: return "Good"
        case 0.62..<0.78: return "Passable"
        case 0.42..<0.62: return "Rough"
        default: return "Waste"
        }
    }
}

public enum Judge {
    public static func read(_ forme: Forme, copy: [String], face: TypeFace, size: Double,
                            measurePicas: Double, paper: Stock, ink: Colour,
                            pull: Pull, secondColour: Bool) -> Verdict {
        var faults: [String] = []

        var right = 0
        var total = 0
        for (i, wanted) in copy.enumerated() {
            let set = i < forme.lines.count ? forme.lines[i] : []
            let letters = set.filter { !JobCase.spaceKeys.contains($0.key) && $0.key != "lead" && $0.key != "slug" }
            let want = Array(wanted).filter { $0 != " " }.map { String($0) }
            total += max(want.count, letters.count)
            for (j, w) in want.enumerated() {
                guard j < letters.count else { continue }
                if letters[j].key == w && !letters[j].turned { right += 1 }
            }
        }
        let accuracy = total > 0 ? Double(right) / Double(total) : 0
        let turned = forme.lines.flatMap { $0 }.filter { $0.turned }.count
        if turned > 0 {
            faults.append(turned == 1 ? "One sort is standing on its head and prints as a turned letter."
                          : "\(turned) sorts are standing on their heads.")
        }
        if accuracy < 0.99 && turned == 0 {
            faults.append("The line does not read as the copy does. Somewhere a sort came out of the wrong box.")
        }

        var worst = 0.0
        var spacingScore = 1.0
        for line in forme.lines where !line.isEmpty {
            let off = abs(Measure.deficit(line, face, size, measurePicas: measurePicas))
            worst = max(worst, off)
            spacingScore = min(spacingScore, max(0, 1 - max(0, off - 0.5) / 9.0))
        }
        if worst > 4 {
            faults.append(String(format: "A line is out by %.1f points. Justify it with quads and hair spaces until it is exact.", worst))
        }

        let quoinIdeal = 0.62 + (1 - paper.softness) * 0.06
        let quoinOff = abs(pull.quoin - quoinIdeal)
        var lockup = max(0, 1 - quoinOff / 0.30)
        if pull.quoin < 0.36 {
            lockup *= 0.4
            faults.append("The forme was loose. Sorts dropped out as it was lifted, which the trade calls pi.")
        } else if pull.quoin > 0.90 {
            lockup *= 0.55
            faults.append("The quoins were driven too hard and the forme sprang, so the lines are bowed.")
        }

        let inkIdeal = 0.44 + paper.absorbency * 0.24
        let inkOff = pull.inking - inkIdeal
        var inking = max(0, 1 - abs(inkOff) / 0.30)
        if inkOff < -0.16 {
            faults.append("Too little ink. The impression is grey and broken and the thin strokes have dropped out.")
        } else if inkOff > 0.16 {
            faults.append("Too much ink. The counters have filled in and the enclosed letters print as blobs.")
        }
        if pull.inking > 0.86 && (face.key == "textura" || face.key == "doric") {
            inking *= 0.7
            faults.append("\(face.name) has small counters and closes up before anything else on the stone.")
        }

        let depthOff = pull.depth - paper.bestDepth
        var impression = max(0, 1 - abs(depthOff) / max(0.12, paper.depthWindow))
        impression = min(1, impression + pull.makeready * 0.22)
        if depthOff > paper.depthWindow {
            faults.append("The impression was driven too deep for \(paper.name) and the sheet is punched through at the heavy letters.")
        } else if depthOff < -paper.depthWindow {
            faults.append("A kiss impression on \(paper.name) has left the letters grey and uneven.")
        }
        if pull.depth > 0.72 && face.key == "bodoni" {
            impression *= 0.72
            faults.append("Bodoni's hairlines have broken under that much impression.")
        }
        if pull.makeready < 0.2 && paper.smoothness < 0.5 {
            faults.append("No makeready. On a rough sheet the light areas print weakly and the heavy ones print black.")
        }

        var register = 1.0
        if secondColour {
            register = max(0, 1 - pull.registerOffset / 3.0)
            if pull.registerOffset > 1.2 {
                faults.append(String(format: "The second colour is out of register by %.1f points and the two impressions do not sit together.", pull.registerOffset))
            }
        }

        let weights: [Double] = secondColour ? [0.30, 0.18, 0.13, 0.14, 0.13, 0.12] : [0.34, 0.21, 0.15, 0.16, 0.14, 0.0]
        let parts = [accuracy, spacingScore, lockup, inking, impression, register]
        var sum = 0.0
        for (i, w) in weights.enumerated() { sum += parts[i] * w }
        let denom = weights.reduce(0, +)
        return Verdict(accuracy: accuracy, spacing: spacingScore, lockup: lockup,
                       inking: inking, impression: impression, register: register,
                       total: denom > 0 ? sum / denom : 0, faults: faults)
    }
}
