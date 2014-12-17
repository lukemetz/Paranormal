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

    // Create a document with the url and switch to it.
    func createDocumentFromUrl(baseUrl: NSURL) {
        var error : NSError?
        var document = self.openUntitledDocumentAndDisplay(true, error: &error)
            as Document
        if let actualError = error {
            let alert = NSAlert(error: actualError)
            alert.runModal()
        }

        document.documentSettings?.baseImage = baseUrl.path

        let filter = ZUpInitializeFilter()
        if let image = document.baseImage {
            if let data = image.TIFFRepresentation {
                let bitmap = NSBitmapImageRep.imageRepsWithData(data)[0] as NSBitmapImageRep

                document.documentSettings?.width = bitmap.pixelsWide
                document.documentSettings?.height = bitmap.pixelsHigh

                let filteredImage = filter.imageByFilteringImage(image)
                document.currentLayer?.imageData = filteredImage.TIFFRepresentation
            } else {
                log.error("Could not initialize document. Image size cannot be found")
            }
        }

        document.managedObjectContext.processPendingChanges()
        document.undoManager?.removeAllActions()

        // Retrigger the setting of document to reupdate with new document settings
        // TODO this should really be a message
        windowController.document = document
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
