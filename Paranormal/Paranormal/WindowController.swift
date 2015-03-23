import Foundation
import Cocoa

public let PNNotificationZoomChanged = "PNNotificationZoomChanged"

public class WindowController: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var mainView: NSView!

    @IBOutlet weak var panelsView: NSView!
    public var panelsViewController: PanelsViewController?

    @IBOutlet weak var toolsView: NSView!
    public var toolsViewController: ToolsViewController?

    @IBOutlet weak var editorView: NSView!
    public var editorViewController: EditorViewController?
    var childViewControllers : [PNViewController?] = []

    @IBOutlet public weak var zoomField: NSTextField!

    override init(window: NSWindow?) {
        super.init(window:window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "zoomUpdated:",
            name: PNNotificationZoomChanged, object: nil)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    func zoomUpdated(notification: NSNotification) {
        zoomField.floatValue = (notification.userInfo?["zoom"] as Float)*100
    }

    @IBAction public func zoomSetFromGUI(sender: NSTextField) {
        let zoomAmount = sender.floatValue / 100.0
        if let editViewCont = editorViewController {
            let center = CGPoint(x: editViewCont.editor.frame.width / 2.0,
                y: editViewCont.editor.frame.height / 2.0)
            editViewCont.setZoomAroundApplicationSpacePoint(center, scale: CGFloat(zoomAmount))
        }

        NSNotificationCenter.defaultCenter()
            .postNotificationName(PNNotificationZoomChanged,
                object: nil, userInfo: ["zoom" : zoomAmount])
    }

    // TODO: This and other preview settings should get their own view controller.
    @IBAction func setEditorViewMode(sender: NSSegmentedControl) {
        if let newViewMode = EditorViewMode(rawValue: sender.selectedSegment) {
            if let doc = document as? Document {
                doc.editorViewMode = newViewMode
            }
        } else {
            log.error("editor mode set to unknown value \(sender.selectedSegment)")
        }
    }

    override public func windowDidLoad() {
        editorViewController = EditorViewController(nibName: "Editor", bundle: nil)
        childViewControllers.append(editorViewController)

        panelsViewController = PanelsViewController(nibName: "Panels", bundle: nil)
        childViewControllers.append(panelsViewController)

        toolsViewController = ToolsViewController(nibName: "Tools", bundle: nil)
        childViewControllers.append(toolsViewController)

        setDocumentOnChildren()

        if let view = editorViewController?.view {
            if editorView != nil {
                ViewControllerUtils.insertSubviewIntoParent(editorView, child: view)
            }
        }

        if let view = toolsViewController?.view {
            if toolsView != nil {
                ViewControllerUtils.insertSubviewIntoParent(toolsView, child: view)
            }
        }

        if let view = panelsViewController?.view {
            if panelsView != nil {
                ViewControllerUtils.insertSubviewIntoParent(panelsView, child: view)
            }
        }

    }

    required public init?(coder:NSCoder) {
        super.init(coder: coder)
    }

    override public init() {
        super.init()
    }

    func setDocumentOnChildren() {
        if let doc = document as? Document {
            for child in childViewControllers {
                child?.document = doc
            }
        }
    }

    override public var document : AnyObject? {
        // TODO this needs to now hold an array or something as
        // we are using a single window
        set(document) {
            super.document = document
            setDocumentOnChildren()
        }

        get {
            return super.document
        }
    }

    public func windowWillClose(notification: NSNotification) {
        document?.close()
    }

    public func windowWillReturnUndoManager(window: NSWindow) -> NSUndoManager? {
        let doc = document as Document?
        return doc?.undoManager
    }
}
