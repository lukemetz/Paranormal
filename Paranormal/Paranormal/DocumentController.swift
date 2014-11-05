import Foundation
import Cocoa

class DocumentController: NSDocumentController {
    var windowController = WindowController(windowNibName: "Application")
    var newDocumentController : NewDocumentController?

    override func addDocument(document: NSDocument) {
        if let paraDocument = document as? Document {
            paraDocument.singleWindowController = windowController
        }

        // Only keep one document open at a time.
        if let current = currentDocument as? Document {
            // TODO prompt the user to save
            removeDocument(current)
        }

        super.addDocument(document)
    }

    override func newDocument(sender: AnyObject?) {
        if let window = windowController.window {
            newDocumentController = NewDocumentController(parentWindow: window)

            if let newDocumentWindow : NSWindow = newDocumentController?.window {
                NSApp.beginSheet(newDocumentWindow, modalForWindow: window, modalDelegate: self,
                    didEndSelector: nil, contextInfo: nil)
            }
        }
    }
}