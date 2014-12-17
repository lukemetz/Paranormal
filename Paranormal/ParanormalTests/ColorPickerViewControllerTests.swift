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

    func testColorConversions(){
        let document = Document(type: "Paranormal", error: nil)!
        let colorPickerViewController = ColorPickerViewController()
        colorPickerViewController.document = document

        colorPickerViewController.deg = 0
        colorPickerViewController.pit = 0
        println(document.currentColor)
        XCTAssert(document.currentColor == NSColor(red: 0.5,
            green: 0.5, blue: 1.0, alpha: 1.0), "Top should be z-up")

    }

}
