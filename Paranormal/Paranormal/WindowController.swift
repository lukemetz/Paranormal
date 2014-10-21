import Foundation
import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var previewView: NSView!

    @IBOutlet weak var glView: CCGLView!
    var previewSettings : PreviewSettings?

    class var sharedInstance: WindowController {
        struct Static {
            static var instance: WindowController?
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            Static.instance = WindowController(windowNibName: "Application")
        }

        return Static.instance!
    }

    override init(window: NSWindow?) {
        super.init(window:window)
    }

    func setUpCocos() {
        let director = CCDirector.sharedDirector() as CCDirector!
        director.setView(glView)

        let scene = TestScene()
        director.runWithScene(scene)
    }

    func tearDownCocos() {
        let director = CCDirector.sharedDirector() as CCDirector!
        director.end()
        director.setView(nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func windowDidLoad() {
        setUpCocos()
        if previewSettings == nil {
            previewSettings = PreviewSettings(context: document?.managedObjectContext)

            if let preview = previewSettings?.view {
                previewView.addSubview(preview)

                // Place the view at the top
                let rect : NSRect! = preview.frame
                let container : NSRect! = previewView?.frame
                preview.frame = NSRect(x: 0,
                    y: container.height - rect.height,
                    width: rect.width,
                    height: rect.height)
            }
        }
    }

    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }

    override init()
    {
        super.init()
    }

    override var document : AnyObject? {
        // TODO this needs to now hold an array or something as
        // we are using a single window
        set(document) {
            // Tear down UI or something
            super.document = document
        }

        get {
            return super.document
        }
    }

    func windowWillClose(notification: NSNotification) {
        document?.close()
        tearDownCocos()
    }

    func windowWillReturnUndoManager(window: NSWindow) -> NSUndoManager? {
        let doc = document as Document?
        return doc?.managedObjectContext.undoManager
    }
}