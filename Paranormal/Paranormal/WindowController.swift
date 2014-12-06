import Foundation
import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var mainView: NSView!

    @IBOutlet weak var panelsView: NSView!
    var panelsViewController: PanelsViewController?

    @IBOutlet weak var toolsView: NSView!
    var toolsViewController: ToolsViewController?

    @IBOutlet weak var editorView: NSView!
    var editorViewController: EditorViewController?

    override init(window: NSWindow?) {
        super.init(window:window)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func windowDidLoad() {
        editorViewController = EditorViewController(nibName: "Editor", bundle: nil)
        editorViewController?.document = document as? Document
        if let view = editorViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(editorView, child: view)
        }

        toolsViewController = ToolsViewController(nibName: "Tools", bundle: nil)
        toolsViewController?.document = document as? Document
        if let view = toolsViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(toolsView, child: view)
        }

        panelsViewController = PanelsViewController(nibName: "Panels", bundle: nil)
        panelsViewController?.document = document as? Document
        if let view = panelsViewController?.view{
            ViewControllerUtils.insertSubviewIntoParent(panelsView, child: view)
        }
    }

    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }

    override init() {
        super.init()
    }

    override var document : AnyObject? {
        // TODO this needs to now hold an array or something as
        // we are using a single window
        set(document) {
            super.document = document
        }

        get {
            return super.document
        }
    }

    func windowWillClose(notification: NSNotification) {
        document?.close()
    }

    func windowWillReturnUndoManager(window: NSWindow) -> NSUndoManager? {
        let doc = document as Document?
        return doc?.undoManager
    }
}
