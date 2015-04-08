import Cocoa
import Quick
import Nimble
import Paranormal

class ColorPickerViewControllerTests: QuickSpec {

    override func spec() {
        describe("ColorPickerViewController") {
            func expectColorNear(color1: NSColor, color2: NSColor) {
                let e = 0.00001
                let r1 = Float(color1.redComponent)
                let r2 = Float(color2.redComponent)
                expect(r1).to(beCloseTo(r2, within: e))

                let g1 = Float(color1.greenComponent)
                let g2 = Float(color2.greenComponent)
                expect(g1).to(beCloseTo(g2, within: e))

                let b1 = Float(color1.blueComponent)
                let b2 = Float(color2.blueComponent)
                expect(b1).to(beCloseTo(b2, within: e))

                let a1 = Float(color1.alphaComponent)
                let a2 = Float(color2.alphaComponent)
                expect(a1).to(beCloseTo(a2, within: e))
            }

            it("converts colors from pitch direction to rgb") {
                let document = Document(type: "Paranormal", error: nil)!
                let colorPickerViewController = ColorPickerViewController()
                colorPickerViewController.document = document
                document.toolSettings.colorAsAngles = (0,0)
                // This corresponds to a vector pointing out of screen, +z
                // (0, 0, 1)
                expect(document.toolSettings.colorAsNSColor)
                    .to(equal(NSColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)))

        document.toolSettings.colorAsAngles = (180,90.0)
                // This corresponds to the vector pointing entirly down, -y
                // (0, -1, 0)
                expectColorNear(document.toolSettings.colorAsNSColor,
                    NSColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0))

        document.toolSettings.colorAsAngles = (0.0,90.0)
                // This corresponds to the vector pointing entirly up, +y
                // (0, 1, 0)
                expectColorNear(document.toolSettings.colorAsNSColor,
                    NSColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0))
            }
        }
    }
}
