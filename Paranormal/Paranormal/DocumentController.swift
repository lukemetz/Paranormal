import Foundation
import Cocoa

class DocumentController: NSDocumentController {
    var windowController = WindowController(windowNibName: "Application")

    override func addDocument(document: NSDocument) {
        if let paraDocument = document as? Document {
            paraDocument.singleWindowController = windowController
        }

        super.addDocument(document)
    }
}