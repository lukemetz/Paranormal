import Foundation
import Cocoa
import AppKit
import CoreGraphics

public class EditorViewController : PNViewController {

    @IBOutlet public weak var editor: EditorView!

    public var activeEditorTool : EditorActiveTool?

    override public var document: Document? {
        didSet {
            if editor != nil {
                activeEditorTool = BrushTool()
            }
        }
    }

    public var color : NSColor? {
        return document?.currentColor
    }

    public var currentLayer : Layer? {
        return document?.currentLayer
    }

    public var brushSize : Float? {
        return document?.brushSize
    }

    public var brushOpacity : Float? {
        return document?.brushOpacity
    }

    public func updateZoom(editorScale : Float) {
        editor.scale = CGVector(dx: CGFloat(editorScale), dy: CGFloat(editorScale))
    }

    override public func loadView() {
        super.loadView()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateComputedEditorImage:",
            name: PNDocumentComputedEditorChanged,
            object: nil)

        activeEditorTool = BrushTool()
    }

    func updateComputedEditorImage(notification: NSNotification) {
        // Run on main thread for core animation
        dispatch_async(dispatch_get_main_queue()) {
            self.editor.image = self.document?.computedEditorImage
        }
    }

    func pointToContext(point: CGPoint) -> CGPoint {
        var point = editor.convertPoint(point, fromView: nil)
        return editor.applicationToImage(point)
    }

    override public func mouseDown(theEvent: NSEvent) {
        var locationInWindow = theEvent.locationInWindow
        let point = pointToContext(theEvent.locationInWindow)

        activeEditorTool?.mouseDownAtPoint(point, editorViewController: self)
    }

    override public func mouseDragged(theEvent: NSEvent) {
        var locationInWindow = theEvent.locationInWindow
        let point = pointToContext(theEvent.locationInWindow)

        activeEditorTool?.mouseDraggedAtPoint(point, editorViewController: self)
    }

    override public func mouseUp(theEvent: NSEvent) {
        var locationInWindow = theEvent.locationInWindow
        let point = pointToContext(theEvent.locationInWindow)

        activeEditorTool?.mouseUpAtPoint(point, editorViewController: self)
    }
}
