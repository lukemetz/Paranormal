import Foundation
import Cocoa

class DocumentController: NSDocumentController {
    var windowController = WindowController(windowNibName: "Application")
    var documentCreationController : DocumentCreationController?

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
            documentCreationController = DocumentCreationController(parentWindow: window)

            if let documentCreationWindow : NSWindow = documentCreationController?.window {
                NSApp.beginSheet(documentCreationWindow, modalForWindow: window,
                    modalDelegate: self, didEndSelector: nil, contextInfo: nil)
            }
        }
    }

    func export(sender: AnyObject?) {
        // Get the current active document
        if let document = windowController.document as? Document {
            let panel = NSSavePanel()
            panel.allowedFileTypes = ["png"]
            panel.beginWithCompletionHandler({ (_) -> Void in
                // Convert image to png and write to file
                let imageData = document.computedExportImage?.TIFFRepresentation
                if nil != panel.URL && imageData != nil {
                    let newRep = NSBitmapImageRep(data: imageData!)
                    let type = NSBitmapImageFileType.NSPNGFileType
                    let pngData = newRep?.representationUsingType(type, properties:[:])

                    pngData?.writeToURL(panel.URL!, atomically: true)
                }
            })
        }
    }
}
