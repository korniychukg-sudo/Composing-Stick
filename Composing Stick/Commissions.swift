import Foundation

public struct Commission: Hashable {
    public let key: String
    public let name: String
    public let client: String
    public let brief: String
    public let copy: [String]
    public let faceKey: String
    public let size: Int
    public let measurePicas: Double
    public let paperKey: String
    public let inkKey: String
    public let secondInk: String?
    public let forbidFace: String?
    public let days: Int
    public let ornamentKey: String
    public let history: String
    public let rankNeeded: Int
}

public enum Orders {
    private static let lotOne: [Commission] = [
        Commission(key: "wedding", name: "Wedding Invitation", client: "Mrs Aldersey, of Bright Street",
                   brief: "Engraver's script for the names and Caslon for the rest. Cotton rag, deep impression, and nothing crooked.",
                   copy: ["THE MARRIAGE OF", "Alice Vernon", "AND", "Thomas Rowe"],
                   faceKey: "script", size: 24, measurePicas: 22, paperKey: "rag",
                   inkKey: "black", secondInk: nil, forbidFace: "poster", days: 6,
                   ornamentKey: "fleuron",
                   history: "Social printing was the best paid jobbing work in the shop and the fussiest. An invitation was expected to imitate copperplate engraving, so the shop kept a script face and a very light touch.",
                   rankNeeded: 0),
        Commission(key: "broadside", name: "Poetry Broadside", client: "The Sparrow Press",
                   brief: "One poem, one sheet, one side. Caslon at eighteen on laid, and let the white space do the work.",
                   copy: ["THE LONG FIELD", "by Anne Cardew", "Printed at the sign of the sparrow"],
                   faceKey: "caslon", size: 18, measurePicas: 31, paperKey: "laid",
                   inkKey: "black", secondInk: nil, forbidFace: nil, days: 7,
                   ornamentKey: "ivy",
                   history: "A broadside is printed on one side of a single sheet and was the cheapest way to put words in front of people. Ballads, proclamations and executions all came out this way.",
                   rankNeeded: 0),
        Commission(key: "bookplate", name: "Bookplate", client: "Dr Hallam, physician",
                   brief: "Small, square, and it must sit inside a border. Bodoni, and keep the impression light so the hairlines survive.",
                   copy: ["EX LIBRIS", "Josiah Hallam"],
                   faceKey: "bodoni", size: 18, measurePicas: 12, paperKey: "wove",
                   inkKey: "black", secondInk: nil, forbidFace: "poster", days: 5,
                   ornamentKey: "laurel",
                   history: "An ex libris label pasted inside the front board. The Latin means from the books of, and the earliest printed ones are German and date from the 1470s.",
                   rankNeeded: 0),
        Commission(key: "concert", name: "Concert Bill", client: "The Assembly Rooms",
                   brief: "It has to read from the far side of the street. Wood letter for the top line and Clarendon under it.",
                   copy: ["GRAND CONCERT", "Friday the 9th", "Doors at seven"],
                   faceKey: "poster", size: 60, measurePicas: 63, paperKey: "news",
                   inkKey: "black", secondInk: nil, forbidFace: "script", days: 4,
                   ornamentKey: "lyre",
                   history: "Bill posting was a trade of its own. A concert bill went up on a hoarding among a hundred others, so the top line was cut in wood at whatever size would win.",
                   rankNeeded: 0),
        Commission(key: "apothecary", name: "Apothecary Label", client: "Renton and Son, chemists",
                   brief: "Very small measure, and the name of the shop in red. Two colours, in register.",
                   copy: ["RENTON AND SON", "Chemists", "17 Market Row"],
                   faceKey: "clarendon", size: 18, measurePicas: 18, paperKey: "wove",
                   inkKey: "black", secondInk: "vermilion", forbidFace: nil, days: 5,
                   ornamentKey: "ruleplain",
                   history: "Label work was printed many up on one sheet and cut afterwards. A chemist's label had to survive being handled with wet fingers, which is why they were varnished.",
                   rankNeeded: 1),
        Commission(key: "card", name: "Business Card", client: "Mr Pell, land agent",
                   brief: "Three lines and a rule. Gothic, small, and the spacing is the whole job.",
                   copy: ["HENRY PELL", "Land Agent", "By appointment only"],
                   faceKey: "gothic", size: 12, measurePicas: 12, paperKey: "bristol",
                   inkKey: "black", secondInk: nil, forbidFace: nil, days: 3,
                   ornamentKey: "ruleswelled",
                   history: "A card so small leaves nowhere to hide. Everything the trade knows about spacing shows on a business card, which is why apprentices were set to them.",
                   rankNeeded: 0),
        Commission(key: "chapbook", name: "Chapbook Title Page", client: "Wilkes, of Paternoster Row",
                   brief: "Old style, centred, and it wants a fist somewhere. Cheap paper, so do not be delicate.",
                   copy: ["A TRUE ACCOUNT", "of the Great Storm", "Printed for J Wilkes"],
                   faceKey: "caslon", size: 18, measurePicas: 18, paperKey: "laid",
                   inkKey: "black", secondInk: nil, forbidFace: nil, days: 6,
                   ornamentKey: "fist",
                   history: "Chapbooks were sold by pedlars for a penny. The title page carried the whole sales pitch, which is why they are set in six sizes and read like a shout.",
                   rankNeeded: 0),
        Commission(key: "memorial", name: "Memorial Card", client: "The family of Mr Sedley",
                   brief: "Black border, quiet type, deep impression on rag. Nothing loud anywhere.",
                   copy: ["IN MEMORY OF", "Charles Sedley", "1814 to 1877"],
                   faceKey: "caslon", size: 18, measurePicas: 14, paperKey: "rag",
                   inkKey: "denseblack", secondInk: nil, forbidFace: "poster", days: 4,
                   ornamentKey: "borderleaf",
                   history: "Mourning stationery was a Victorian industry with rules about how wide the black border might be and for how long. A shop kept a whole case of black rule for it.",
                   rankNeeded: 1)
    ]

    private static let lotTwo: [Commission] = [
        Commission(key: "seed", name: "Seed Packet", client: "Coles Nurseries",
                   brief: "Kraft paper, bold slab, and one line in green. Coarse stock, so keep the size up.",
                   copy: ["SCARLET RUNNER", "Coles Nurseries", "Sow in May"],
                   faceKey: "clarendon", size: 24, measurePicas: 23, paperKey: "kraft",
                   inkKey: "black", secondInk: "green", forbidFace: "script", days: 5,
                   ornamentKey: "oakleaf",
                   history: "Seed packets were printed flat and folded by hand. The paper was chosen to keep damp out rather than to print well, and the printer worked round it.",
                   rankNeeded: 1),
        Commission(key: "handbill", name: "Handbill", client: "The Corn Exchange",
                   brief: "Newsprint, one impression, a thousand of them. Condensed face, because there is a great deal to say.",
                   copy: ["PUBLIC MEETING", "at the Corn Exchange", "Tuesday the 3rd at eight"],
                   faceKey: "doric", size: 36, measurePicas: 33, paperKey: "news",
                   inkKey: "black", secondInk: nil, forbidFace: "bodoni", days: 3,
                   ornamentKey: "ruledouble",
                   history: "A handbill is given out rather than posted, so it can be smaller and busier. Newsprint took the ink badly and nobody minded because it was read once and dropped.",
                   rankNeeded: 1),
        Commission(key: "menu", name: "Hotel Menu", client: "The Bell Hotel",
                   brief: "Italic for the dishes and a rule between courses. Wove, light impression.",
                   copy: ["THE BELL HOTEL", "Dinner", "Half past seven"],
                   faceKey: "italic", size: 18, measurePicas: 14, paperKey: "wove",
                   inkKey: "black", secondInk: nil, forbidFace: "poster", days: 4,
                   ornamentKey: "ruleswelled",
                   history: "A hotel menu was reset every day, which is why shops that did hotel work kept standing lines of the courses and changed only the dishes.",
                   rankNeeded: 1),
        Commission(key: "catalogue", name: "Bookseller's Catalogue", client: "Grimston, bookseller",
                   brief: "The cover only. Caslon, generous measure, and the shop's name in the second colour.",
                   copy: ["A CATALOGUE OF", "Rare and Curious Books", "GRIMSTON of York"],
                   faceKey: "caslon", size: 24, measurePicas: 29, paperKey: "laid",
                   inkKey: "black", secondInk: "crimson", forbidFace: nil, days: 8,
                   ornamentKey: "cartouche",
                   history: "Booksellers advertised by catalogue and the cover was their shop front. Setting one in Caslon was a claim about the kind of stock inside.",
                   rankNeeded: 2),
        Commission(key: "playbill", name: "Theatre Playbill", client: "The Theatre Royal",
                   brief: "Every line a different size, which is the fashion. Wood letter, Tuscan, and no restraint whatever.",
                   copy: ["THEATRE ROYAL", "THE WINTER TALE", "Boxes 3s Pit 2s"],
                   faceKey: "tuscan", size: 48, measurePicas: 47, paperKey: "news",
                   inkKey: "black", secondInk: "vermilion", forbidFace: "bodoni", days: 4,
                   ornamentKey: "sunburst",
                   history: "The Victorian playbill is the loudest thing the trade produced, and it grew that way because each theatre had to out shout the one next door on the same hoarding.",
                   rankNeeded: 2),
        Commission(key: "auction", name: "Auction Notice", client: "Rudd and Beale, auctioneers",
                   brief: "Condensed and dense. Give them the date big and the conditions small.",
                   copy: ["TO BE SOLD", "By Public Auction", "On the 14th of June"],
                   faceKey: "doric", size: 36, measurePicas: 27, paperKey: "laid",
                   inkKey: "black", secondInk: nil, forbidFace: "script", days: 4,
                   ornamentKey: "ruleplain",
                   history: "Auction bills carried a legal weight and had to name the day and the place exactly, so the compositor checked the copy against the instructions twice before locking up.",
                   rankNeeded: 1),
        Commission(key: "letterhead", name: "Letterhead", client: "Mowbray and Ash, solicitors",
                   brief: "One line of Bodoni across the head and the address in small caps below it.",
                   copy: ["MOWBRAY AND ASH", "Solicitors", "9 Chancery Walk"],
                   faceKey: "bodoni", size: 18, measurePicas: 19, paperKey: "wove",
                   inkKey: "black", secondInk: nil, forbidFace: "poster", days: 5,
                   ornamentKey: "ruleplain",
                   history: "Letter heads were printed in thousands and stored flat. A solicitor's head was deliberately plain, because looking expensive was the wrong signal.",
                   rankNeeded: 1),
        Commission(key: "ticket", name: "Admission Ticket", client: "The Horticultural Society",
                   brief: "Tiny measure, numbers that must be right, and a border all round.",
                   copy: ["ADMIT ONE", "No 148", "Not transferable"],
                   faceKey: "gothic", size: 12, measurePicas: 10, paperKey: "bristol",
                   inkKey: "black", secondInk: nil, forbidFace: nil, days: 3,
                   ornamentKey: "borderchain",
                   history: "Numbered tickets were printed with a numbering box locked into the forme, which stepped on every impression. Before that the numbers were written in by hand.",
                   rankNeeded: 0)
    ]

    private static let lotThree: [Commission] = [
        Commission(key: "hymn", name: "Hymn Sheet", client: "St Botolph's",
                   brief: "Blackletter for the heading and Caslon for the verses. Thin paper, light touch.",
                   copy: ["Advent Hymns", "SAINT BOTOLPH", "Sunday next"],
                   faceKey: "textura", size: 24, measurePicas: 15, paperKey: "india",
                   inkKey: "black", secondInk: nil, forbidFace: "poster", days: 6,
                   ornamentKey: "quatrefoil",
                   history: "Churches kept a printer on account and the black letter heading was a deliberate archaism, meant to look older than the building.",
                   rankNeeded: 2),
        Commission(key: "winelabel", name: "Wine Label", client: "Pargeter and Company",
                   brief: "Small, oval, and gold ochre on a dark stock with opaque white for the name.",
                   copy: ["OLD TAWNY", "Pargeter and Co", "Bottled 1878"],
                   faceKey: "italic", size: 18, measurePicas: 13, paperKey: "cover",
                   inkKey: "white", secondInk: "ochre", forbidFace: "gothic", days: 6,
                   ornamentKey: "vine",
                   history: "Wine labels were among the first jobs printed on coloured cover stock, which meant the shop had to keep opaque white and learn how to make it cover in one pull.",
                   rankNeeded: 2),
        Commission(key: "timetable", name: "Railway Timetable", client: "The Valley Railway",
                   brief: "Figures, figures and more figures, in a narrow measure with dotted leaders.",
                   copy: ["VALLEY RAILWAY", "Down Trains", "7 40 and 11 25"],
                   faceKey: "typewriter", size: 12, measurePicas: 11, paperKey: "news",
                   inkKey: "black", secondInk: nil, forbidFace: "script", days: 5,
                   ornamentKey: "ruledotted",
                   history: "Timetable setting was reckoned the hardest work in a jobbing shop, because a single figure in the wrong box could put a passenger on a platform at the wrong hour.",
                   rankNeeded: 2),
        Commission(key: "shopbill", name: "Shop Bill", client: "Dacre the ironmonger",
                   brief: "A fist, a slab face, and prices that shout. Coarse paper, heavy ink.",
                   copy: ["DACRE", "IRONMONGER", "Nails and Tools"],
                   faceKey: "clarendon", size: 36, measurePicas: 28, paperKey: "kraft",
                   inkKey: "denseblack", secondInk: nil, forbidFace: "bodoni", days: 4,
                   ornamentKey: "fist",
                   history: "The shop bill was the tradesman's advertisement and often his only printed thing. It was pinned in the window and replaced when it went brown.",
                   rankNeeded: 1),
        Commission(key: "birth", name: "Birth Announcement", client: "Mr and Mrs Coyne",
                   brief: "Script, small, deep bite on handmade paper. The kind of job that pays for a week.",
                   copy: ["A daughter", "Eleanor Mary Coyne", "Born the 2nd of March"],
                   faceKey: "script", size: 18, measurePicas: 20, paperKey: "deckle",
                   inkKey: "black", secondInk: nil, forbidFace: "poster", days: 5,
                   ornamentKey: "rosette",
                   history: "Announcement cards were a middle class ritual with an exact etiquette about size, wording and how long you had to send one.",
                   rankNeeded: 2),
        Commission(key: "certificate", name: "Prize Certificate", client: "The Mechanics Institute",
                   brief: "Blackletter heading, a wreath, and the winner's name left blank for the pen.",
                   copy: ["Awarded to", "FOR DILIGENCE", "The Mechanics Institute"],
                   faceKey: "textura", size: 24, measurePicas: 21, paperKey: "rag",
                   inkKey: "black", secondInk: "ochre", forbidFace: "gothic", days: 7,
                   ornamentKey: "wreath",
                   history: "Certificates were printed with the name left out so one setting served a whole prize day. The writing master filled them in afterwards.",
                   rankNeeded: 3),
        Commission(key: "invoice", name: "Invoice Heading", client: "Sallows, corn merchant",
                   brief: "Plain, wide, and it must leave room for the ruled columns below.",
                   copy: ["SALLOWS", "Corn Merchant", "Bought of"],
                   faceKey: "gothic", size: 18, measurePicas: 13, paperKey: "laid",
                   inkKey: "black", secondInk: nil, forbidFace: nil, days: 4,
                   ornamentKey: "ruledouble",
                   history: "The heading was printed and the ruling was done separately by a ruling machine with pens on a moving belt, which is why the two are so often out of square.",
                   rankNeeded: 1),
        Commission(key: "ball", name: "Ball Programme", client: "The Subscription Ball",
                   brief: "A list of dances in a narrow measure with a rule under each. Small and neat.",
                   copy: ["PROGRAMME", "of Dances", "Quadrille and Waltz"],
                   faceKey: "italic", size: 12, measurePicas: 11, paperKey: "bristol",
                   inkKey: "black", secondInk: nil, forbidFace: "poster", days: 4,
                   ornamentKey: "ruleplain",
                   history: "A ball programme had a pencil on a cord and a line beside each dance for a partner's name, which is the whole reason it was printed at all.",
                   rankNeeded: 1)
    ]

    private static let lotFour: [Commission] = [
        Commission(key: "almanac", name: "Almanac Page", client: "Kirby's Almanack",
                   brief: "Figures in columns, tight measure, and every one of them right.",
                   copy: ["JANUARY", "Sun rises 8 6", "Moon full on the 12th"],
                   faceKey: "caslon", size: 12, measurePicas: 13, paperKey: "laid",
                   inkKey: "black", secondInk: nil, forbidFace: "poster", days: 6,
                   ornamentKey: "star6",
                   history: "Almanacks were the best selling printed things in England after the Bible, and the astronomical figures came from a computer who was paid by the page.",
                   rankNeeded: 2),
        Commission(key: "tradecard", name: "Trade Card", client: "Ebden the glover",
                   brief: "Ornament heavy, a border all round, and the trade named in a display face.",
                   copy: ["EBDEN", "Glover and Hosier", "Est 1841"],
                   faceKey: "tuscan", size: 36, measurePicas: 34, paperKey: "bristol",
                   inkKey: "black", secondInk: "crimson", forbidFace: "gothic", days: 5,
                   ornamentKey: "arabesque",
                   history: "The trade card was the ancestor of the business card and often carried an engraved picture of the shop. Printers set them as showpieces.",
                   rankNeeded: 2),
        Commission(key: "cigar", name: "Cigar Band", client: "The Havana Rooms",
                   brief: "A very small measure indeed, in gold ochre, with the name in the middle.",
                   copy: ["HAVANA", "Fine Cut"],
                   faceKey: "bodoni", size: 18, measurePicas: 8, paperKey: "enamel",
                   inkKey: "ochre", secondInk: nil, forbidFace: "poster", days: 5,
                   ornamentKey: "borderchain",
                   history: "Cigar bands were the most elaborate small printing ever done, and they moved to lithography early because letterpress could not hold that much detail.",
                   rankNeeded: 3),
        Commission(key: "notice", name: "Church Notice", client: "The Parish Council",
                   brief: "Plain and legible at ten feet. Nothing clever, and it must last a month on a board.",
                   copy: ["PARISH NOTICE", "Vestry Meeting", "Thursday at 7"],
                   faceKey: "clarendon", size: 24, measurePicas: 20, paperKey: "cover",
                   inkKey: "black", secondInk: nil, forbidFace: "script", days: 3,
                   ornamentKey: "ruleplain",
                   history: "Notices on a board outdoors were printed on cover stock and sometimes varnished. The type was chosen for weight rather than beauty.",
                   rankNeeded: 0),
        Commission(key: "musiccover", name: "Sheet Music Cover", client: "Harker and Nunn",
                   brief: "The title in Tuscan, the composer in italic, and a lyre. Two colours.",
                   copy: ["THE LARK", "A Song", "Words by J Harker"],
                   faceKey: "tuscan", size: 36, measurePicas: 35, paperKey: "wove",
                   inkKey: "black", secondInk: "prussian", forbidFace: "typewriter", days: 6,
                   ornamentKey: "lyre",
                   history: "Sheet music covers were the poster art of the drawing room, and a good one sold the song. The music inside was engraved on pewter, not set in type.",
                   rankNeeded: 3),
        Commission(key: "subscription", name: "Subscription Form", client: "The Lending Library",
                   brief: "Typewriter face, dotted leaders, and blanks the width of a name.",
                   copy: ["SUBSCRIPTION", "Name", "One guinea a year"],
                   faceKey: "typewriter", size: 12, measurePicas: 13, paperKey: "wove",
                   inkKey: "black", secondInk: nil, forbidFace: "textura", days: 4,
                   ornamentKey: "ruledotted",
                   history: "Forms had to leave exactly enough room for a hand to write in, which meant the compositor measured a signature and set the blank to fit.",
                   rankNeeded: 1),
        Commission(key: "greeting", name: "Greetings Card", client: "Mrs Farrow",
                   brief: "Ornament, ornament, and a short line of script in the middle of it.",
                   copy: ["With every", "Good Wish", "Christmas 1879"],
                   faceKey: "script", size: 24, measurePicas: 18, paperKey: "rag",
                   inkKey: "crimson", secondInk: "green", forbidFace: "doric", days: 6,
                   ornamentKey: "borderleaf",
                   history: "The printed Christmas card began in the 1840s and was a printer's invention before it was a custom. The trade made the market and then complained about it.",
                   rankNeeded: 2),
        Commission(key: "compliments", name: "Compliments Slip", client: "Verity and Sons",
                   brief: "One line, one rule, one afternoon. Get the spacing perfect and go home.",
                   copy: ["With Compliments", "VERITY AND SONS"],
                   faceKey: "gothic", size: 12, measurePicas: 12, paperKey: "wove",
                   inkKey: "warmgrey", secondInk: nil, forbidFace: nil, days: 2,
                   ornamentKey: "ruleplain",
                   history: "A compliments slip is a letter head cut down, and shops printed them from the same forme with the address dropped out.",
                   rankNeeded: 0)
    ]

    private static let lotFive: [Commission] = [
        Commission(key: "poster", name: "Fair Poster", client: "The Michaelmas Fair",
                   brief: "The biggest wood letter in the shop, on the cheapest paper, in one day.",
                   copy: ["THE FAIR", "MICHAELMAS", "All Week"],
                   faceKey: "poster", size: 72, measurePicas: 58, paperKey: "news",
                   inkKey: "black", secondInk: "vermilion", forbidFace: "bodoni", days: 2,
                   ornamentKey: "sunburst",
                   history: "Fair posters were pasted up in overlapping layers until the wall was an inch thick in paper, and the shop that got there last was the one that got read.",
                   rankNeeded: 1),
        Commission(key: "specimen", name: "Type Specimen", client: "The shop itself",
                   brief: "Show the face at its best. Your own work, your own choices, and it goes on the wall.",
                   copy: ["SPECIMEN", "of Printing Types", "Set and printed here"],
                   faceKey: "caslon", size: 24, measurePicas: 25, paperKey: "rag",
                   inkKey: "black", secondInk: nil, forbidFace: nil, days: 9,
                   ornamentKey: "fleuron",
                   history: "Every foundry issued specimen books and every shop kept one. Caslon's 1734 sheet is the most reproduced piece of English printing there is.",
                   rankNeeded: 4),
        Commission(key: "proclamation", name: "Town Proclamation", client: "The Town Clerk",
                   brief: "Blackletter heading, wide measure, and the wording is not to be altered by one letter.",
                   copy: ["Proclamation", "BY ORDER", "The Town Clerk"],
                   faceKey: "textura", size: 36, measurePicas: 21, paperKey: "laid",
                   inkKey: "black", secondInk: nil, forbidFace: "script", days: 3,
                   ornamentKey: "crown",
                   history: "Official printing carried the arms and a fixed form of words. Getting a letter wrong in a proclamation was not a printing error, it was a legal one.",
                   rankNeeded: 3),
        Commission(key: "sailing", name: "Sailing Bill", client: "The Anchor Line",
                   brief: "An anchor, a date, and a condensed face. Salt air, so use the coated stock.",
                   copy: ["FOR NEW YORK", "Sailing the 8th", "Anchor Line"],
                   faceKey: "doric", size: 36, measurePicas: 22, paperKey: "enamel",
                   inkKey: "prussian", secondInk: nil, forbidFace: "script", days: 4,
                   ornamentKey: "anchor",
                   history: "Emigration bills were posted in every port and inland market town, and the printer was paid by the shipping agent per hundred posted rather than per hundred printed.",
                   rankNeeded: 2),
        Commission(key: "receipt", name: "Receipt Book Head", client: "The Gas Company",
                   brief: "Numbers, a rule, and nothing else. Set it once and it prints for a year.",
                   copy: ["GAS COMPANY", "Received", "No 2 3 4 5"],
                   faceKey: "typewriter", size: 12, measurePicas: 9, paperKey: "news",
                   inkKey: "black", secondInk: nil, forbidFace: "tuscan", days: 3,
                   ornamentKey: "ruledouble",
                   history: "Utility printing was steady money and dull work, and shops took it because it filled the press between the jobs that were interesting.",
                   rankNeeded: 0),
        Commission(key: "invitation", name: "Society Invitation", client: "The Antiquarian Society",
                   brief: "Caslon, a wide measure, an ornamented border and a very light impression on hard stock.",
                   copy: ["THE ANTIQUARIAN", "Society", "Requests the pleasure"],
                   faceKey: "caslon", size: 18, measurePicas: 20, paperKey: "bristol",
                   inkKey: "black", secondInk: nil, forbidFace: "poster", days: 5,
                   ornamentKey: "bordergreek",
                   history: "Learned societies printed their own invitations and specified the face, which is how Caslon came to look like the type of the establishment.",
                   rankNeeded: 2),
        Commission(key: "pricelist", name: "Price List", client: "Dalby the grocer",
                   brief: "Figures against names, in two colours, on thin paper. The register has to hold.",
                   copy: ["DALBY", "Grocer and Tea Dealer", "Prices for June"],
                   faceKey: "clarendon", size: 18, measurePicas: 21, paperKey: "india",
                   inkKey: "black", secondInk: "vermilion", forbidFace: "script", days: 5,
                   ornamentKey: "ruledotted",
                   history: "A price list went out of date the week it was printed, so it was set from standing lines and only the figures were changed for the next run.",
                   rankNeeded: 3),
        Commission(key: "colophon", name: "Colophon", client: "The Kelmscott imitators",
                   brief: "The last page. Say who printed it, where, and when, and then get out of the way.",
                   copy: ["Here ends", "THIS BOOK", "Printed by hand"],
                   faceKey: "textura", size: 18, measurePicas: 11, paperKey: "deckle",
                   inkKey: "denseblack", secondInk: "vermilion", forbidFace: "typewriter", days: 8,
                   ornamentKey: "borderleaf",
                   history: "A colophon is the printer's signature at the end of a book, and it predates the title page. The word is Greek for finishing touch.",
                   rankNeeded: 4)
    ]

    private static let lotSix: [Commission] = [
        Commission(key: "labelbottle", name: "Bottle Label", client: "Sowerby's Cordial",
                   brief: "Ochre and black on enamel, small figures, and the counters must stay open.",
                   copy: ["SOWERBY", "Cordial", "One Shilling"],
                   faceKey: "clarendon", size: 18, measurePicas: 11, paperKey: "enamel",
                   inkKey: "black", secondInk: "ochre", forbidFace: "textura", days: 5,
                   ornamentKey: "ruleswelled",
                   history: "Patent medicine labels made more money for jobbing printers than any other single class of work in the nineteenth century.",
                   rankNeeded: 2)
    ]

    public static let all: [Commission] = lotOne + lotTwo + lotThree + lotFour + lotFive + lotSix

    public static func find(_ key: String) -> Commission { all.first { $0.key == key } ?? all[0] }

    public static func open(rank: Int) -> [Commission] { all.filter { $0.rankNeeded <= rank } }
}

public struct DayJob: Hashable {
    public let day: Int
    public let client: String
    public let line: String
    public let faceKey: String
    public let size: Int
    public let measurePicas: Double
    public let paperKey: String
    public let inkKey: String
    public let constraint: Int
    public let constraintName: String
    public let constraintNote: String
    public let ornamentKey: String
}

public enum Daily {
    private static let linesOne: [String] = [
        "SET IN A STICK", "THE QUICK PRESS", "MIND THE NICK", "LOCK IT UP TIGHT",
        "ONE CLEAN PULL", "READ THE FORME", "TYPE HIGH", "A FAIR IMPRESSION"
    ]
    private static let linesTwo: [String] = [
        "PICAS AND POINTS", "THE STONE IS FLAT", "TURN IT OVER", "SPACE IT OUT",
        "INK THE FORME", "HOLD THE MEASURE", "THE LAST WORD", "PROOF AND CORRECT"
    ]
    private static let linesThree: [String] = [
        "SORTS AND QUADS", "A SHARP NICK", "THE THIRD PULL", "GOOD COLOUR",
        "THE BRASS RULE", "DOWN TO THE STONE", "CHASE AND QUOIN", "SET IT AGAIN"
    ]
    private static let linesFour: [String] = [
        "STRAIGHT AND TRUE", "NO PI TODAY", "THE FLAT STONE", "COUNT THE COPY",
        "RUN IT SLOWLY", "A CLEAN SHEET", "THE FIRST PROOF", "OFF THE PRESS"
    ]
    private static let linesFive: [String] = [
        "NO CROOKED LINES", "THIS SIDE UP", "A FULL GALLEY", "DRY IT FLAT",
        "MIND THE KERNS", "PULL AND CHECK", "STAND IT UP", "THE LONG DAY"
    ]

    public static let lines: [String] = linesOne + linesTwo + linesThree + linesFour + linesFive

    public static let noE: [String] = [
        "STAND FAST", "A GOOD PULL", "TRIM IT DOWN", "LOCK IT DOWN",
        "WORK IT OUT", "COUNT AGAIN", "PACK IT UP", "AN OLD CRAFT"
    ]

    private static let clients: [String] = [
        "the foreman", "the overseer", "the shop", "a walk in customer", "the reader",
        "the proprietor", "an old subscriber", "the parish clerk"
    ]

    public static let constraints: [(String, String)] = [
        ("No constraint", "An ordinary job. Set it, space it, lock it and pull it."),
        ("The e box is empty", "Somebody emptied the e box into the wrong case yesterday. Today's line has no e in it, which is the only reason the job can be done at all."),
        ("The 3 to em spaces have run out", "The word space you would reach for is gone. Build every word space out of en quads, four to ems, five to ems and hair spaces."),
        ("Set from the wrong case", "The sorts were tipped in nick down. Every one of them is standing on its head until you turn it."),
        ("Blind case", "The box labels are covered. Read the metal, not the label."),
        ("Two colours", "The client wants a second colour, so the forme is pulled twice and the register is on you."),
        ("Fine face on rough stock", "A hairline face on a coarse sheet. The makeready is the whole job.")
    ]

    private struct Spin {
        var s: UInt64
        init(_ v: UInt64) { s = v == 0 ? 0x9E3779B97F4A7C15 : v }
        mutating func next() -> UInt64 { s ^= s << 13; s ^= s >> 7; s ^= s << 17; return s }
        mutating func i(_ a: Int, _ b: Int) -> Int { a + Int(next() % UInt64(max(1, b - a + 1))) }
    }

    public static func seedFor(_ day: Int) -> UInt64 {
        var h: UInt64 = 1469598103934665603
        var v = UInt64(bitPattern: Int64(day &+ 7919))
        for _ in 0..<8 {
            h = (h ^ (v & 0xFF)) &* 1099511628211
            v >>= 8
        }
        return h
    }

    public static func job(_ day: Int) -> DayJob {
        var rng = Spin(seedFor(day))
        let constraint = rng.i(0, constraints.count - 1)
        let line = constraint == 1 ? noE[rng.i(0, noE.count - 1)] : lines[rng.i(0, lines.count - 1)]
        var faceIndex = rng.i(0, Foundry.faces.count - 1)
        if constraint == 6 { faceIndex = rng.i(0, 1) == 0 ? 1 : 7 }
        let face = Foundry.faces[faceIndex]
        let size = face.sizes[rng.i(0, face.sizes.count - 1)]
        let width = Composer.lineWidth(line, face, Double(size))
        let needPicas = width / Measure.pointsPerPica
        let measure = (needPicas + Double(rng.i(2, 5))).rounded()
        var paperIndex = rng.i(0, Papers.all.count - 1)
        if constraint == 6 { paperIndex = rng.i(0, 1) == 0 ? 3 : 8 }
        let inkIndex = constraint == 5 ? rng.i(0, 2) : rng.i(0, Inks.all.count - 1)
        return DayJob(day: day,
                      client: clients[rng.i(0, clients.count - 1)],
                      line: line,
                      faceKey: face.key,
                      size: size,
                      measurePicas: max(8, measure),
                      paperKey: Papers.all[paperIndex].key,
                      inkKey: Inks.all[inkIndex].key,
                      constraint: constraint,
                      constraintName: constraints[constraint].0,
                      constraintNote: constraints[constraint].1,
                      ornamentKey: Ornaments.all[rng.i(0, Ornaments.all.count - 1)].key)
    }
}

public enum Standing {
    public static let ranks: [(Int, String, String)] = [
        (0, "Devil", "You sweep the floor, wash the formes and are trusted with the distribution of pi."),
        (240, "Apprentice", "Bound for seven years. You are allowed to set plain matter and to be corrected in public."),
        (700, "Journeyman", "Out of your time and paid by the thousand ems. You can be trusted with a measure."),
        (1500, "Compositor", "You take the job in at the counter and decide how it will look."),
        (2800, "Master Printer", "The chase, the stone and the shop are yours, and so is the blame.")
    ]

    public static func rank(_ marks: Int) -> (String, String, Int, Int, Int) {
        var index = 0
        for (i, step) in ranks.enumerated() where marks >= step.0 { index = i }
        let ceiling = index + 1 < ranks.count ? ranks[index + 1].0 : ranks[index].0
        return (ranks[index].1, ranks[index].2, marks, ceiling, index)
    }
}
