import Cocoa
import XCTest

class ColorPickerViewControllerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation
        // of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation
        // of each test method in the class.
        super.tearDown()
    }

    func expectColorNear(color1: NSColor, _ color2: NSColor) {
        let r1 = Float(color1.redComponent)
        let r2 = Float(color2.redComponent)
        XCTAssertEqualWithAccuracy(r1, r2, 1e-5, "red component")

        let g1 = Float(color1.greenComponent)
        let g2 = Float(color2.greenComponent)
        XCTAssertEqualWithAccuracy(g1, g2, 1e-5, "green component")


        let b1 = Float(color1.blueComponent)
        let b2 = Float(color2.blueComponent)
        XCTAssertEqualWithAccuracy(b1, b2, 1e-5, "blue component")

        let a1 = Float(color1.alphaComponent)
        let a2 = Float(color2.alphaComponent)
        XCTAssertEqualWithAccuracy(a1, a2, 1e-5, "alpha component")
    }

    func testColorConversions(){
        let document = Document(type: "Paranormal", error: nil)!
        let colorPickerViewController = ColorPickerViewController()
        colorPickerViewController.document = document

        colorPickerViewController.deg = 0
        colorPickerViewController.pit = 0
        // This corresponds to a vector pointing out of screen, +z
        XCTAssert(document.currentColor == NSColor(red: 0.5,
            green: 0.5, blue: 1.0, alpha: 1.0), "Top should be z-up")

        colorPickerViewController.deg = 180
        colorPickerViewController.pit = 90
        // This corresponds to the vector pointing entirly down, -y
        // (0, -1, 0)
        expectColorNear(document.currentColor, NSColor(red: 0.5,
            green: 0.0, blue: 0.5, alpha: 1.0))


        colorPickerViewController.deg = 0
        colorPickerViewController.pit = 90
        // This corresponds to the vector pointing entirly up, +y
        // (0, 1, 0)
        expectColorNear(document.currentColor, NSColor(red: 0.5,
            green: 1.0, blue: 0.5, alpha: 1.0))
    }
}
