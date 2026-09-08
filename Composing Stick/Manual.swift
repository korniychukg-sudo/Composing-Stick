import Foundation

public struct Term: Hashable {
    public let word: String
    public let meaning: String
    public let group: String
}

public enum Glossary {
    private static let partOne: [Term] = [
        Term(word: "Sort", meaning: "One piece of type. A single letter cast on its own body. When a shop runs out of a particular letter it is said to be out of sorts, which is where the phrase comes from.", group: "The metal"),
        Term(word: "Nick", meaning: "The groove or grooves cast across the front of the body. A compositor feels for it with a thumb and knows the sort is the right way up without looking at the face. Different founts carry different nicks so mixed type can be separated again.", group: "The metal"),
        Term(word: "Face", meaning: "The raised part that carries the letter and takes the ink. Everything else on the sort exists to hold the face at the right height and the right place.", group: "The metal"),
        Term(word: "Shoulder", meaning: "The flat metal around the face, below printing height. It is why letters have space around them even when the bodies touch.", group: "The metal"),
        Term(word: "Beard", meaning: "The sloped part between the face and the shoulder. On old type it is deep, which is why worn type prints a thickened letter.", group: "The metal"),
        Term(word: "Kern", meaning: "Any part of the face that hangs over the edge of its own body and rests on the shoulder of the next sort. Kerns break. It is the reason the f ligatures were cast.", group: "The metal"),
        Term(word: "Body", meaning: "The size of the block the letter is cast on, measured front to back. Twelve point type is cast on a twelve point body whatever the letter is.", group: "The metal"),
        Term(word: "Type high", meaning: "The height from foot to face, 0.918 of an inch in Britain and America. Anything locked in the forme that is to print must be exactly this and nothing else may be within a hair of it.", group: "The metal")
    ]

    private static let partTwo: [Term] = [
        Term(word: "Em", meaning: "A square of the body. In twelve point type an em is twelve points wide and twelve deep. Named after the capital M, which in early founts filled the body.", group: "The system"),
        Term(word: "En", meaning: "Half an em. The width the founders reckoned an average figure at, which is why figures are usually cast on an en body.", group: "The system"),
        Term(word: "Point", meaning: "The unit of the whole system, a seventy second of an inch to a very close approximation. Adopted in America in 1886 and in Britain soon after, replacing a chaos of named sizes.", group: "The system"),
        Term(word: "Pica", meaning: "Twelve points. Measures are given in picas, so a twenty four pica measure is two hundred and eighty eight points wide.", group: "The system"),
        Term(word: "Leading", meaning: "White space added between lines by laying thin strips of type metal between them. Named for the metal. Type set with none is said to be set solid.", group: "The system"),
        Term(word: "Measure", meaning: "The width a line is set to, and the first thing set on the composing stick before a single sort goes in.", group: "The system"),
        Term(word: "Quad", meaning: "A blank sort below printing height, used to fill space. An em quad and an en quad are the common ones, and larger quads fill out a short line.", group: "The system"),
        Term(word: "Justification", meaning: "Making the line exactly the measure by adjusting the spaces between words. Not a decoration but a structural necessity: a line that is not tight will fall apart when the forme is lifted.", group: "The system")
    ]

    private static let partThree: [Term] = [
        Term(word: "Composing stick", meaning: "The hand held tray the compositor sets into, adjustable to the measure with a sliding knee. Held in the left hand, filled from the right, and the type goes in upside down and backwards.", group: "The bench"),
        Term(word: "Galley", meaning: "A shallow metal tray with a ledge on two or three sides. Finished lines are slid out of the stick into it and stored there until the whole job is set.", group: "The bench"),
        Term(word: "Stone", meaning: "The flat table the forme is made up and locked on. Once actually stone, later a steel or iron surface planed flat, because anything that is not flat will not lock up.", group: "The bench"),
        Term(word: "Chase", meaning: "The rectangular iron frame the type is locked into so it can be lifted and carried to the press as one solid block.", group: "The bench"),
        Term(word: "Furniture", meaning: "Blocks of wood or metal, below printing height, packed around the type inside the chase to fill the space and give the quoins something to push against.", group: "The bench"),
        Term(word: "Quoin", meaning: "The expanding wedge that tightens the forme in the chase. Older ones are pairs of wooden wedges driven with a mallet and shooting stick; later ones expand with a key.", group: "The bench"),
        Term(word: "Forme", meaning: "The whole locked up assembly of type, furniture, chase and quoins, ready to go on the press.", group: "The bench"),
        Term(word: "Planer", meaning: "A flat block of wood laid on the type and tapped with a mallet to knock every sort down to the same level before locking up.", group: "The bench")
    ]

    private static let partFour: [Term] = [
        Term(word: "Pi", meaning: "Type that has been spilled and mixed. A forme that comes apart pies, and the resulting heap has to be distributed back into the case sort by sort. The worst thing that can happen at the stone.", group: "Going wrong"),
        Term(word: "Turned letter", meaning: "A sort set upside down, so it prints rotated. Compositors used a turned sort deliberately to mark a letter they had run out of, meaning to correct it before printing.", group: "Going wrong"),
        Term(word: "Filling in", meaning: "Too much ink, so the counters of a, e, o and the rest close up and print solid. Almost always the brayer and not the press.", group: "Going wrong"),
        Term(word: "Monk", meaning: "A patch of the sheet that has taken too much ink and printed black. Its opposite is a friar, an area that has taken none.", group: "Going wrong"),
        Term(word: "Work up", meaning: "A space or quad that creeps up during the run until it reaches printing height and prints as a mark. Caused by a forme that was not locked tightly enough.", group: "Going wrong"),
        Term(word: "Out of register", meaning: "A second impression that does not land exactly over the first. On a two colour job of any delicacy a point of error is visible and two is fatal.", group: "Going wrong"),
        Term(word: "Slur", meaning: "A doubled or smeared impression caused by the sheet or the forme moving during the pull.", group: "Going wrong"),
        Term(word: "Set off", meaning: "Wet ink transferring from the face of one sheet to the back of the next in the pile. Prevented by slip sheeting or by waiting.", group: "Going wrong")
    ]

    private static let partFive: [Term] = [
        Term(word: "Makeready", meaning: "Building up the packing behind the sheet with tissue and card so that every part of the forme prints with the same weight. The difference between a passable sheet and a fine one.", group: "At the press"),
        Term(word: "Tympan", meaning: "The frame carrying the packing and the sheet on a hand press. The sheet is laid on it and the frisket folded over to hold it.", group: "At the press"),
        Term(word: "Frisket", meaning: "A light frame with a paper mask cut away over the printing areas, folded over the sheet to keep the margins clean.", group: "At the press"),
        Term(word: "Platen", meaning: "The flat surface that presses the sheet against the forme. A platen press brings two flat surfaces together, which is why it needs so much force.", group: "At the press"),
        Term(word: "Brayer", meaning: "A hand roller for inking. Ink is worked out thin on a slab first, then rolled over the forme in two directions.", group: "At the press"),
        Term(word: "Kiss impression", meaning: "Just enough pressure to transfer the ink and no more, leaving no dent in the paper. What the trade considered correct for four hundred years.", group: "At the press"),
        Term(word: "Bite", meaning: "A deep impression that presses the letter into the sheet. Regarded as a fault until the twentieth century, and as the point of the whole exercise since.", group: "At the press"),
        Term(word: "Proof", meaning: "A trial sheet pulled to be read and corrected before the run. A galley proof is pulled from type still in the galley, before it is made up into pages.", group: "At the press")
    ]

    public static let all: [Term] = partOne + partTwo + partThree + partFour + partFive

    public static let groups: [String] = ["The metal", "The system", "The bench", "Going wrong", "At the press"]
}

public struct Lesson: Hashable {
    public let key: String
    public let title: String
    public let plate: String
    public let body: [String]
}

public enum Bench {
    private static let setOne: [Lesson] = [
        Lesson(key: "case", title: "Reading the case", plate: "dg_case", body: [
            "The California job case put the capitals and the lowercase in one tray instead of two, which is why a compositor stopped needing two frames and started needing a good memory.",
            "The lowercase boxes are not alphabetical and they are not the same size. They are laid out by how often each letter is used and how far the hand has to travel, so e has the largest box in the case and sits under the middle of the tray, while z and q are pushed to the edges in boxes barely big enough to get two fingers into.",
            "The capitals are alphabetical, in equal boxes, on the right. J and U come after Z rather than in their alphabetical places, because they were not separate letters when the order was fixed and nobody wanted to move everything along to make room.",
            "A compositor learns the case as a shape rather than as a list, and by the end of an apprenticeship the hand goes to the box without the eye following it."
        ]),
        Lesson(key: "nick", title: "The nick", plate: "dg_anatomy", body: [
            "Every sort has one or more grooves cast across the front of its body. That is the nick, and it faces the compositor as the sort sits in the stick.",
            "Because the nick is on the front, a sort that is the right way up shows it and a sort that is upside down does not. The thumb finds it without the eye, which is the whole point: the letter itself is mirrored and rotated in the stick and is very hard to read at speed.",
            "Founts from different foundries carry different nick patterns, so if two founts of the same face get mixed the nicks are how they are sorted out again.",
            "A sort set nick down prints as a turned letter. Compositors used to do it on purpose to mark a letter they had run out of, intending to put the right one in before the forme went to press."
        ]),
        Lesson(key: "backwards", title: "Why it is backwards", plate: "dg_stick", body: [
            "The type prints by touching the paper, so whatever is on the face lands mirrored on the sheet. To print the right way round, the face must be cut the wrong way round, and it is.",
            "The compositor sets from left to right along the stick, but is looking at the sorts upside down, because the stick is held with the foot of the letters towards the body and the line reads away from you.",
            "That is not a difficulty the trade got used to, it is the arrangement that makes the trade possible. The alternative is holding the stick the other way and reading nothing at all.",
            "Set the line, then hold it up and read it in a mirror or from the printed proof. Reading upside down and backwards fluently takes about a year."
        ]),
        Lesson(key: "spacing", title: "Spacing and justification", plate: "dg_spacing", body: [
            "A line of type has to be exactly the measure. Not near it, exactly it, because the forme is held together by nothing but friction and a line that is short will spill.",
            "Words are separated by a three to em space, a third of the body. To make the line come out exactly, spaces are swapped for wider or narrower ones: em and en quads, four to em and five to em spaces, and hair spaces of about a twelfth.",
            "A good compositor keeps the word spaces even across the line. Two hair spaces here and an en quad there will justify a line arithmetically and look terrible.",
            "Too loose and the line falls out when it is lifted. Too tight and it buckles the stick and springs the whole forme when it is locked."
        ])
    ]

    private static let setTwo: [Lesson] = [
        Lesson(key: "points", title: "The point system", plate: "dg_points", body: [
            "Before 1886 type sizes had names: nonpareil, brevier, bourgeois, long primer, pica, english, great primer. They were not consistent between foundries, so type from two sources would not line up.",
            "The American point system fixed the point at 0.013837 of an inch, or as near as makes no difference a seventy second. Twelve points make a pica and six picas make an inch.",
            "Everything follows from the body size. Twelve point type is cast on a twelve point body, an em of it is twelve points wide, and a two em indent is twenty four points.",
            "Britain adopted the same system, but continental Europe used the Didot point of about 0.0148 of an inch, which is why French and German type will not line up with English type to this day."
        ]),
        Lesson(key: "lockup", title: "Locking up", plate: "dg_lockup", body: [
            "The made up pages go on the stone. Furniture is packed round them inside the chase, and the quoins go on two sides only, never four, because a forme squeezed from all four sides has nowhere to go.",
            "The quoins are tightened a little at a time, working round, so the forme takes up evenly. Then the planer goes on top and is tapped with a mallet to knock every sort down flush.",
            "Test it by lifting one corner of the chase an inch off the stone. If anything drops, it was not tight enough, and now there is pi to distribute.",
            "Too tight is its own fault. An over tightened forme bows in the middle and the lines print curved, and on a badly made forme it will spring the chase."
        ]),
        Lesson(key: "inking", title: "Inking", plate: "dg_ink", body: [
            "Ink goes on the slab first, not on the forme. It is worked out with the brayer until the roller carries an even film and the slab hisses slightly as the roller lifts.",
            "The forme is rolled in two directions, and lightly. A roller pressed hard drives ink down into the counters and closes them.",
            "How much is right depends on the paper. An absorbent sheet takes more, a coated one takes very little and will smear if given more.",
            "Grey and broken means not enough. Blobs where the a and e should have holes in them means too much. There is a surprisingly narrow band between them and finding it is most of the craft."
        ]),
        Lesson(key: "impression", title: "Impression and makeready", plate: "dg_makeready", body: [
            "Impression is how hard the paper is pressed against the type. For four centuries the correct answer was as little as will transfer the ink, which is called a kiss impression.",
            "Modern letterpress deliberately drives the type into a soft sheet to leave a dent you can feel. Purists object. The paper decides which is possible: a hard thin sheet will split before it will take a bite.",
            "Makeready is the slow part. Pull a sheet, look at where it printed light, and paste a piece of tissue on the packing behind that area so the next pull presses harder there.",
            "A serious makeready on a big forme took a day and was built up in layers of tissue, and the difference it makes is the difference between a proof and a piece of printing."
        ])
    ]

    private static let setThree: [Lesson] = [
        Lesson(key: "distribution", title: "Distribution", plate: "dg_dist", body: [
            "When the job is printed the type is washed and put back in the case, box by box. That is distribution and it is half the work of the trade.",
            "The compositor holds a few lines in the left hand, reads them, and lets the sorts fall into the boxes with the right, several at a time. Done well it is faster than setting.",
            "Type that is put back in the wrong box is a fault that only shows up weeks later in somebody else's job, and it is the reason apprentices did the distribution under supervision.",
            "Type wears. Every trip through the press and the wash rounds the face a little, and a fount is eventually thrown back into the melting pot and recast."
        ]),
        Lesson(key: "presses", title: "Presses", plate: "dg_press", body: [
            "The common press was wooden, and printed half a sheet at a time by turning a screw with a bar. Two men worked it, one inking with leather balls and one pulling.",
            "The iron hand press, from about 1800, used a system of levers instead of a screw and could print a whole sheet in one pull. The Albion and the Columbian are the English ones and the Washington the American.",
            "The platen jobbing press brought the platen and the forme together like a clam shell, was worked by a treadle, and made short run jobbing work economic. Most surviving small presses are of this kind.",
            "The cylinder press rolled the sheet over a flat forme instead of pressing it, needed far less force, and is what actually printed the nineteenth century."
        ]),
        Lesson(key: "wood", title: "Wood letter", plate: "dg_wood", body: [
            "Above about seventy two point, metal type is too heavy to handle and far too expensive to cast, so large letters were cut from wood.",
            "The wood is end grain, usually maple, cut across the tree so the fibres run into the surface rather than along it. That is why a wood letter takes a beating without splintering.",
            "The letters were cut on a pantograph from a single master pattern, which is why a fount of wood type has a consistency the earlier hand cut ones do not.",
            "Wood is lighter, cheaper and takes ink unevenly, showing its grain in the solid areas. That unevenness is now the reason people want it."
        ]),
        Lesson(key: "colour", title: "Two colours", plate: "dg_colour", body: [
            "A second colour means a second forme and a second run through the press, with the sheet laid in exactly the same place both times.",
            "The register is held by lays: a paper stop at the side and two at the front against which the sheet is pushed each time. Everything depends on the sheet being cut square.",
            "Overprinting is the other reason for a second colour. Two transparent inks laid over one another give a third colour, so a red over a blue prints violet where they cross.",
            "Opaque inks do not overprint, they cover. On a coloured stock only an opaque white will show, and it usually wants two impressions to cover properly."
        ])
    ]

    public static let all: [Lesson] = setOne + setTwo + setThree
}

public struct SpacingRow: Hashable {
    public let name: String
    public let ems: Double
    public let use: String
}

public enum Tables {
    public static let spaces: [SpacingRow] = [
        SpacingRow(name: "Two em quad", ems: 2.0, use: "Filling out a short last line, and indenting a display line."),
        SpacingRow(name: "Em quad", ems: 1.0, use: "The paragraph indent, and the unit the whole system is named after."),
        SpacingRow(name: "En quad", ems: 0.5, use: "Half the body. The width a figure is normally cast on."),
        SpacingRow(name: "Three to em", ems: 1.0 / 3.0, use: "The ordinary word space. Reach for this one first."),
        SpacingRow(name: "Four to em", ems: 0.25, use: "A tighter word space, and the first thing to try when a line is over."),
        SpacingRow(name: "Five to em", ems: 0.2, use: "Tighter still. Used between the letters of a spaced capital line."),
        SpacingRow(name: "Hair space", ems: 1.0 / 12.0, use: "About a twelfth. Used a pair at a time to bring a stubborn line exactly to the measure.")
    ]

    public static let sizes: [(Int, String, String)] = [
        (6, "Nonpareil", "Six points. Footnotes and the small print nobody reads."),
        (8, "Brevier", "Eight points. Newspaper body text for a century."),
        (9, "Bourgeois", "Nine points. Between brevier and long primer, and named for nobody in particular."),
        (10, "Long Primer", "Ten points. The commonest book size in English printing."),
        (12, "Pica", "Twelve points, and the size the measure is counted in."),
        (14, "English", "Fourteen points. Large book work and prayer books."),
        (18, "Great Primer", "Eighteen points. Chapter openings and small display."),
        (24, "Double Pica", "Twenty four points. Title pages."),
        (36, "Double Great Primer", "Thirty six points. Jobbing display."),
        (48, "Canon", "Forty eight points. Above this a shop reached for wood.")
    ]

    public static let anatomy: [(String, String)] = [
        ("Face", "The raised letter that takes the ink."),
        ("Counter", "The enclosed white inside a, e, o, b and the rest. The first thing to close up when the forme is over inked."),
        ("Shoulder", "The flat metal around the face, below printing height."),
        ("Beard", "The slope between the face and the shoulder."),
        ("Nick", "The groove on the front of the body. The compositor's guide to which way up the sort goes."),
        ("Body", "The block itself, cast to the point size."),
        ("Feet", "The two flat surfaces the sort stands on, with the groove between them left by the jet being broken off."),
        ("Height to paper", "0.918 of an inch from foot to face in Britain and America.")
    ]
}
