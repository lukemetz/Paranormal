import Cocoa
import Quick
import Nimble
import Paranormal

class DocumentTests: QuickSpec {
    override func spec() {
        describe("Document") {
            describe("initialization") {
                var document : Document!

                beforeEach {
                    document = Document(type: "Paranormal", error: nil)!
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
                it("sets brush color to ZUP"){
                expect(document.currentColor.redComponent).to(equal(0.5))
                    expect(document.currentColor.greenComponent).to(equal(0.5))
                    expect(document.currentColor.blueComponent).to(equal(1.0))
                }
            }
        }
    }
}
