import Foundation
import Cocoa
import Paranormal
import Quick
import Nimble

class WindowControllerTests : QuickSpec {
    override func spec() {
        describe("WindowControllerTests") {
            var windowController : WindowController!
            var document : Document!

            beforeEach() {
                windowController = WindowController(windowNibName: "Application")
                document = Document(type: "Paranormal", error: nil)!
                windowController.document = document
                windowController.loadWindow()
                windowController.windowDidLoad()
            }

            describe("windowDidLoad") {
                it("Sets the document on its subviews") {
                    expect(windowController.panelsViewController?.document).toNot(beNil())
                    expect(windowController.toolsViewController?.document).toNot(beNil())
                    expect(windowController.editorViewController?.document).toNot(beNil())
                }
            }

            it("Should set the document on its view controllers when changed") {
                expect(windowController.panelsViewController?.document).to(equal(document))
                expect(windowController.toolsViewController?.document).to(equal(document))
                expect(windowController.editorViewController?.document).to(equal(document))
            }
        }
    }
}
