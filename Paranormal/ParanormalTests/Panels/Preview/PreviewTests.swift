import Foundation
import Cocoa
import Quick
import Nimble
import Paranormal

class previewTests: QuickSpec {
    override func spec() {
        describe("Preview on new document") {
            var previewController : PreviewViewController!
            var documentController : DocumentController!

            beforeEach {
                documentController = DocumentController()
                previewController = PreviewViewController()
                for doc in documentController.documents {
                    documentController.removeDocument(doc as NSDocument)
                }
                documentController.createDocumentFromUrl(nil)
            }

            it("Renders a preview") {
                expect(documentController.documents.count).to(equal(1))
                let document = documentController.documents[0] as? Document
                PNEditorHelper.waitForEditorImageInDocument(document!)
                expect(document?.computedPreviewImage).toEventuallyNot(beNil())
                if let image = document?.computedPreviewImage {
                    let darkerColor = NSImageHelper.getPixelColor(
                        image, pos: NSPoint(x: 10, y: 10))
                    expect(darkerColor).to(beColor(77, 77, 77, 255))
                    let lighterColor = NSImageHelper.getPixelColor(
                        image, pos: NSPoint(x: 300, y:150))
                    expect(lighterColor).to(beNearColor(81, 81, 81, 255, tolerance: 2))
                }
            }
        }
    }
}
