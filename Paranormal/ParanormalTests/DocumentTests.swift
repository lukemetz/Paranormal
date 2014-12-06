import Cocoa
import XCTest

class DocumentTests: XCTestCase {


    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDocumentInitialization() {
        let document = Document(type: "Paranormal", error: nil)!

        // The set up does not leave anythin in the undo stack
        document.windowControllerDidLoadNib(NSWindowController())
        XCTAssert(document.undoManager?.canUndo == false, "Can't undo initialization")

        // The set up creates 1 Refraction entity
        let refractionFetch = NSFetchRequest(entityName: "Refraction")
        let refractionResult : NSArray? =
            document.managedObjectContext.executeFetchRequest(refractionFetch, error: nil)
        XCTAssert(refractionResult?.count == 1, "1 Refraction")

        // The set up creates 1 DocumentSettings entity
        let documentFetch = NSFetchRequest(entityName: "DocumentSettings")
        let documentResult : NSArray? =
        document.managedObjectContext.executeFetchRequest(documentFetch, error: nil)
        XCTAssert(documentResult?.count == 1, "1 DocumentSettings")

        // The set up creates 1 default layer entity
        let layerFetch = NSFetchRequest(entityName: "Layer")
        let layerResult : NSArray? =
        document.managedObjectContext.executeFetchRequest(layerFetch, error: nil)
        // One layer for container / root. One to draw on.
        XCTAssert(layerResult?.count == 2, "2 Layers on setup")

        // TODO fix this so it takes advantage of subclasses
        // Currently the test environment can do these dynamic casts from
        // managedObjects to subclasses.
        let documentSettings = documentResult?[0] as NSManagedObject
        let rootLayer = documentSettings.valueForKey("rootLayer") as NSManagedObject
        let layers = rootLayer.valueForKey("layers") as NSOrderedSet

        XCTAssert(layers.count == 1, "Root Layer has 1 child")
    }
}
