import Foundation
import Cocoa

class DocumentCreationController : NSWindowController, NSOpenSavePanelDelegate {
    @IBOutlet weak var createButton: NSButton!
    var parentWindow : NSWindow?
    let allowedFileTypes = ["png", "jpg", "jpeg"]
    var baseImageURL : NSURL? {
        didSet {
            if let url = baseImageURL {
                var err : NSError?
                let fileIsValid = url.checkResourceIsReachableAndReturnError(&err) &&
                                    contains(allowedFileTypes, url.pathExtension!)
                if (fileIsValid) {
            createButton.title = "Create"
                } else {
                    createButton.title = "Create Blank"
                    log.info("specified path does not point to an image.")
                }
            }
        }
    }

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
        panel.allowedFileTypes = allowedFileTypes
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
        if let url = NSURL(fileURLWithPath: urlString, isDirectory: false) {
            self.baseImageURL = url
            self.imageView.image = NSImage(contentsOfURL: url)
        }
    }

    @IBAction func pushCancel(sender: NSButton) {
        closeSheet()
    }

    @IBAction func pushCreate(sender: NSButton) {
        closeSheet()
        let documentController = DocumentController.sharedDocumentController() as DocumentController
        documentController.createDocumentFromUrl(baseImageURL)
    }

    @IBAction func pushImportNormal(sender: NSButton) {
        var panel = NSOpenPanel()
        panel.allowedFileTypes = allowedFileTypes
        panel.delegate = self;
        panel.beginWithCompletionHandler { (_) -> Void in
            if let url = panel.URL {
                let normalImage = NSImage(contentsOfURL: url)

                self.closeSheet()
                let documentController =
                    DocumentController.sharedDocumentController() as DocumentController
                documentController.createDocumentFromUrl(self.baseImageURL)
                let document = documentController.currentDocument as? Document
                let overlay = NoiseTool()
                if let currentLayer = document?.currentLayer {
                    if let newLayer = document?.rootLayer?.addLayer() {
                        newLayer.imageData = normalImage?.TIFFRepresentation
                        newLayer.name = "Noise Layer"
                        newLayer.blendMode = BlendMode.Tilted
                        currentLayer.combineLayerOntoSelf(newLayer)
                    }
                }
            }
        }
    }

    override init(window: NSWindow?) {
        super.init(window:window)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
