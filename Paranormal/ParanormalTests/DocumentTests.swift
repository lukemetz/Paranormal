import Cocoa
import Quick
import Nimble
import Paranormal
import CoreGraphics

class DocumentTests: QuickSpec {
    override func spec() {
        describe("Document") {
            describe("initialization") {
                var document : Document!

                beforeEach {
                    document = DocumentController()
                        .makeUntitledDocumentOfType("Paranormal", error: nil) as Document
                }

                it("does not leave anything in the undo stack") {
                    document.windowControllerDidLoadNib(NSWindowController())
                    expect(document.undoManager?.canUndo).to(beFalsy())
                }

                it("creates 1 Refraction entity") {
                    let refractionFetch = NSFetchRequest(entityName: "Refraction")
                    let refractionResult : NSArray? =
                        document.managedObjectContext
                            .executeFetchRequest(refractionFetch, error: nil)
                    expect(refractionResult?.count).to(equal(1))
                }

                it("creates 1 DocumentSettings entity") {
                    let documentFetch = NSFetchRequest(entityName: "DocumentSettings")
                    let documentResult : NSArray? =
                    document.managedObjectContext.executeFetchRequest(documentFetch, error: nil)
                    expect(documentResult?.count).to(equal(1))
                }

                it("creates 1 default layer entity") {
                    let layerFetch = NSFetchRequest(entityName: "Layer")
                    let layerResult : NSArray? =
                    document.managedObjectContext.executeFetchRequest(layerFetch, error: nil)
                    // One layer for container / root. One to draw on.
                    expect(layerResult?.count).to(equal(2))
                }

                it("Check number of sublayers") {
                    let documentFetch = NSFetchRequest(entityName: "DocumentSettings")
                    let documentResult : NSArray? =
                        document.managedObjectContext.executeFetchRequest(documentFetch, error: nil)
                    let documentSettings = documentResult?[0] as DocumentSettings
                    let layers = documentSettings.rootLayer?.layers

                    expect(layers?.count).to(equal(1))
                }

                it("Root layer should have imageData") {
                    let documentFetch = NSFetchRequest(entityName: "DocumentSettings")
                    let documentResult : NSArray? =
                    document.managedObjectContext.executeFetchRequest(documentFetch, error: nil)
                    let documentSettings = documentResult?[0] as DocumentSettings
                    let root = documentSettings.rootLayer!
                    expect(root.imageData).toNot(beNil())
                }

                it("sets brush color to ZUP"){
                    expect(document.currentColor.redComponent).to(equal(0.5))
                    expect(document.currentColor.greenComponent).to(equal(0.5))
                    expect(document.currentColor.blueComponent).to(equal(1.0))
                }
            }

            describe ("Initialization on Import") {
                var documentController : DocumentController!

                beforeEach {
                    documentController = DocumentController()
                    let url = NSBundle(forClass: DocumentTests.self)
                        .URLForResource("bear", withExtension: "png")

                    for doc in documentController.documents {
                        documentController.removeDocument(doc as NSDocument)
                    }

                    documentController.createDocumentFromUrl(url!)
                }

                it ("Imports a bear image") {
                    expect(documentController.documents.count).to(equal(1))
                    //import creates a second document
                    let newDocument = documentController.documents[0] as? Document
                    expect(newDocument?.documentSettings?.width).to(equal(161))
                }

                // Bug 88400728: This test has a race condition involving the editor controller
                // not initializing the image before the colors are extracted.
                // TODO: Stop skipping this test.
                xit ("Initializes editor with ZUP in shape of bear") {

                    let newDocument = documentController.documents[0] as? Document
                    let editorController = newDocument?.singleWindowController?.editorViewController
                        as EditorViewController?
                    expect(editorController?.editor.image).toEventuallyNot(beNil()) //wait for image
                    //w=161, h=156
                    //check that corners are transparent
                    var color = editorController?.getPixelColor(0.0, 0.0) //top left
                    expect(color?.alphaComponent).to(equal(0))
                    color = editorController?.getPixelColor(160.0, 0.0) //top right
                    expect(color?.alphaComponent).to(equal(0))
                    color = editorController?.getPixelColor(0.0, 155.0) //bottom left
                    expect(color?.alphaComponent).to(equal(0))
                    color = editorController?.getPixelColor(160.0, 155.0) //bottom right
                    expect(color?.alphaComponent).to(equal(0))

                    expect(editorController?.getPixelColor(105.0, 8.0)?.alphaComponent)
                        .toEventually(equal(255))
                    expect(editorController?.getPixelColor(105.0, 8.0)?.redComponent)
                        .toEventually(equal(128))
                    expect(editorController?.getPixelColor(105.0, 8.0)?.greenComponent)
                        .toEventually(equal(128))
                    expect(editorController?.getPixelColor(105.0, 8.0)?.blueComponent)
                        .toEventually(equal(255))
                }
            }
        }
    }
}
