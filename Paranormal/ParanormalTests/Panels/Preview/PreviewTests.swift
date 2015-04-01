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
//                previewController = PreviewViewController()
                for doc in documentController.documents {
                    documentController.removeDocument(doc as NSDocument)
                }
                documentController.createDocumentFromUrl(nil)
                let swc = (documentController.documents[0] as Document).singleWindowController
                previewController = swc?.panelsViewController?.previewViewController
            }

            fit("Renders a preview") {
                expect(documentController.documents.count).to(equal(1))
                let document = documentController.documents[0] as? Document
                PNEditorHelper.waitForPreviewImageInDocument(document!)
                expect(document?.computedPreviewImage).toEventuallyNot(beNil())
                if let image = document?.computedPreviewImage {
                    let darkerColor = NSImageHelper.getPixelColor(
                        image, pos: NSPoint(x: 10, y: 10))
                    expect(darkerColor).to(beNearColor(77, 77, 77, 255, tolerance: 2))
                    let lighterColor = NSImageHelper.getPixelColor(
                        image, pos: NSPoint(x: 300, y:150))
                    expect(lighterColor).to(beNearColor(82, 82, 82, 255, tolerance: 2))
                }
            }
        }
    }
}
