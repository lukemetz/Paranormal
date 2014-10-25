import Cocoa

class Document: NSPersistentDocument {

    var singleWindowController : WindowController?

    override init() {
        super.init()
        let entityDescription = NSEntityDescription.entityForName("Refraction",
            inManagedObjectContext: managedObjectContext)!
        let refraction = Refraction(entity: entityDescription,
            insertIntoManagedObjectContext: managedObjectContext)

        refraction.indexOfRefraction = 0.8
        managedObjectContext.processPendingChanges()

        undoManager?.removeAllActions()
    }

    convenience init?(type typeName: String, error outError: NSErrorPointer) {
        self.init()
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController
        // has loaded the document's window.

    }

    override class func autosavesInPlace() -> Bool {
        return false
    }

    override func makeWindowControllers() {
        addWindowController(singleWindowController!)
    }
}
