import Foundation

let args = CommandLine.arguments
let outDir = args.count > 1 ? args[1] : "./out"
let mode = args.count > 2 ? args[2] : "all"
try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)

if mode == "icon" || mode == "all" {
    buildIcon(dir: outDir)
    print("icon")
}
if mode == "plates" || mode == "all" {
    for f in Foundry.faces { facePlate(f, dir: outDir); print("fa_" + f.key) }
    for f in Foundry.faces { faceDetail(f, dir: outDir); print("fd_" + f.key) }
    for o in Ornaments.all { ornamentPlate(o, dir: outDir); print("or_" + o.key) }
    for s in Papers.all { paperPlate(s, dir: outDir); print("pa_" + s.key) }
    for c in Inks.all { inkPlate(c, dir: outDir); print("in_" + c.key) }
    for h in shopHours { shopPlate(h, dir: outDir); print(h.key) }
    casePlate(dir: outDir); print("dg_case")
    anatomyPlate(dir: outDir); print("dg_anatomy")
    stickPlate(dir: outDir); print("dg_stick")
    spacingPlate(dir: outDir); print("dg_spacing")
    pointsPlate(dir: outDir); print("dg_points")
    lockupPlate(dir: outDir); print("dg_lockup")
    inkDiagram(dir: outDir); print("dg_ink")
    makereadyPlate(dir: outDir); print("dg_makeready")
    distPlate(dir: outDir); print("dg_dist")
    pressPlate(dir: outDir); print("dg_press")
    woodPlate(dir: outDir); print("dg_wood")
    colourPlate(dir: outDir); print("dg_colour")
    for i in 0..<4 { onboardPlate(i, dir: outDir); print("ob_\(i)") }
    for c in Orders.all { commissionPlate(c, dir: outDir); print("cm_" + c.key) }
}
print("done")
