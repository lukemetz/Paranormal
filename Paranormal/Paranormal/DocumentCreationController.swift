import Foundation
import Cocoa

class DocumentCreationController : NSWindowController, NSOpenSavePanelDelegate {
    var parentWindow : NSWindow?
    var baseImageURL : NSURL?

    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var imageView: NSImageView!

    override var windowNibName : String! {
        return "DocumentCreation"
    }

    init(parentWindow: NSWindow) {
        super.init(window: nil)
        self.parentWindow = parentWindow
    }

    override init() {
        super.init()
    }

    func closeSheet() {
        if let unwrapParentWindow = parentWindow {
            NSApp.endSheet(window!)
            window?.orderOut(unwrapParentWindow)
        }
    }

    @IBAction func pushBaseImageBrowse(sender: NSButton) {
        var panel = NSOpenPanel()
        panel.allowedFileTypes = ["png", "jpg", "jpeg"]
        panel.delegate = self;
        panel.beginWithCompletionHandler { (_) -> Void in
            if let url = panel.URL {
                self.baseImageURL = url
                self.urlTextField.stringValue = url.path!
                self.imageView.image = NSImage(contentsOfURL: url)
            }
        }
    }

    @IBAction func changeUrlText(sender: NSTextField) {
        let urlString = sender.stringValue
        if let url = NSURL(fileURLWithPath: urlString) {
            self.baseImageURL = url
            self.imageView.image = NSImage(contentsOfURL: url)
        }
    }

    @IBAction func pushCancel(sender: NSButton) {
        closeSheet()
    }

    @IBAction func pushCreate(sender: NSButton) {
        closeSheet()
        var error : NSError?
        let documentController = DocumentController.sharedDocumentController() as DocumentController
        var document = documentController.openUntitledDocumentAndDisplay(true, error: &error)
            as Document
        if let actualError = error {
            let alert = NSAlert(error: actualError)
            alert.runModal()
        }

        document.documentSettings?.baseImage = baseImageURL?.absoluteString

        document.managedObjectContext.processPendingChanges()
        document.undoManager?.removeAllActions()
    }

    override init(window: NSWindow?) {
        super.init(window:window)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
