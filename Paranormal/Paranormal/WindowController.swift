import Foundation
import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var mainView: NSView!

    @IBOutlet weak var panelView: NSView!
    @IBOutlet weak var previewView: NSView!
    var previewViewController: PreviewViewController?

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

    // Insert view into parent and set up constraints such that it resizes how parent element
    // resizes.
    func insertSubviewIntoParent(parent: NSView, child: NSView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(child)

        let horizontalContraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: ["view" : child])
        parent.addConstraints(horizontalContraints)

        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: ["view" : child])

        parent.addConstraints(verticalConstraints)

        child.updateConstraints()
        parent.updateConstraints()
    }

    override func windowDidLoad() {
        editorViewController = EditorViewController(nibName: "Editor", bundle: nil)
        editorViewController?.document = document as? Document
        if let view = editorViewController?.view {
            insertSubviewIntoParent(editorView, child: view)
        }

        previewViewController = PreviewViewController(nibName: "Preview", bundle: nil)
        if let view = previewViewController?.view {
            insertSubviewIntoParent(previewView, child: view)
        }

        toolsViewController = ToolsViewController(nibName: "Tools", bundle: nil)
        toolsViewController?.document = document as? Document
        if let view = toolsViewController?.view {
            insertSubviewIntoParent(toolsView, child: view)
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
