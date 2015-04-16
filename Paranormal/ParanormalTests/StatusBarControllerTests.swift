import Foundation
import Paranormal
import Quick
import Nimble

class StatusBarViewControllerTests : QuickSpec {
    override func spec() {
        describe("Status Bar Controller Tests") {
            var document : Document?
            var windowController : WindowController!
            var statusBarController : StatusBarViewController!

            beforeEach() {
                let documentController = DocumentController()
                document = documentController
                    .makeUntitledDocumentOfType("Paranormal", error: nil) as? Document
                documentController.addDocument(document!)
                document?.makeWindowControllers()

                windowController = document?.singleWindowController
                statusBarController = windowController.statusBarViewController
            }

            describe("gui elements") {
                describe("zoom") {
                    it("Zooms in the editor") {
                        statusBarController.zoomTextField.floatValue = 200.0
                        statusBarController.zoomSentFromGUI(statusBarController.zoomTextField)
                        expect(windowController.editorViewController?.zoom).to(equal(2.0))
                    }

                    it("Triggers a PNNotificationZoomChanged notification") {
                        var ranNotification = false
                        NSNotificationCenter.defaultCenter()
                            .addObserverForName(PNNotificationZoomChanged, object: nil, queue: nil,
                                usingBlock: { (n) -> Void in
                                    ranNotification = true
                            })

                        statusBarController.zoomSentFromGUI(statusBarController.zoomTextField)
                        let date = NSDate(timeIntervalSinceNow: 0.1)
                        NSRunLoop.currentRunLoop().runUntilDate(date)
                        expect(ranNotification).toEventually(beTrue(()))
                    }
                }
            }
        }
    }
}
