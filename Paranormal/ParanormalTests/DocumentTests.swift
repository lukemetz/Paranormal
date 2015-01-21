import Cocoa
import Quick
import Nimble

class DocumentTests: QuickSpec {
    override func spec() {
        describe("Document") {
            describe("Initialization") {
                var document : Document!

                beforeEach {
                    document = Document(type: "Paranormal", error: nil)!
                }

                it("Does not leave anything in the undo stack") {
                    document.windowControllerDidLoadNib(NSWindowController())
                    expect(document.undoManager?.canUndo).to(beFalsy())
                }

                it("Creates 1 Refraction entity") {
                    let refractionFetch = NSFetchRequest(entityName: "Refraction")
                    let refractionResult : NSArray? =
                        document.managedObjectContext
                            .executeFetchRequest(refractionFetch, error: nil)
                    expect(refractionResult?.count).to(equal(1))
                }

                it("Creates 1 DocumentSettings entity") {
                    let documentFetch = NSFetchRequest(entityName: "DocumentSettings")
                    let documentResult : NSArray? =
                    document.managedObjectContext.executeFetchRequest(documentFetch, error: nil)
                    expect(documentResult?.count).to(equal(1))
                }

                it("Creates 1 default layer entity") {
                    let layerFetch = NSFetchRequest(entityName: "Layer")
                    let layerResult : NSArray? =
                    document.managedObjectContext.executeFetchRequest(layerFetch, error: nil)
                    // One layer for container / root. One to draw on.
                    expect(layerResult?.count).to(equal(2))
                }

                it("Check number of sublayers") {
                    // TODO fix this so it takes advantage of subclasses
                    // Currently the test environment can do these dynamic casts from
                    // managedObjects to subclasses.
                    let documentFetch = NSFetchRequest(entityName: "DocumentSettings")
                    let documentResult : NSArray? =
                        document.managedObjectContext.executeFetchRequest(documentFetch, error: nil)
                    let documentSettings = documentResult?[0] as NSManagedObject
                    let rootLayer = documentSettings.valueForKey("rootLayer") as NSManagedObject
                    let layers = rootLayer.valueForKey("layers") as NSOrderedSet

                    expect(layers.count).to(equal(1))
                }
            }
        }
    }
}
