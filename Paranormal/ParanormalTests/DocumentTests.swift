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
        let fetch = NSFetchRequest(entityName: "Refraction")
        let result : NSArray? =
            document.managedObjectContext.executeFetchRequest(fetch, error: nil)
        XCTAssert(result?.count == 1, "1 Refraction")
    }
}
