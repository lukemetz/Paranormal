import Foundation
import Cocoa
import AppKit
import CoreGraphics

let PNScrollMultiplier : CGFloat = 2.0

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

    public var zoom : Float {
        let t = editor.transform
        let sx = sqrt(t.a * t.a + t.c * t.c)
        let sy = sqrt(t.b * t.b + t.d * t.d)
        if abs(sx - sy) > 1e-6 {
            log.error("XY zoom are off. You are no longer viewing a square image.")
        }
        return Float(sx)
    }

    public func changeActiveTool(tool : EditorActiveTool?) {
        activeEditorTool?.stopUsingTool()
        activeEditorTool = tool
    }

    public func zoomAroundImageSpacePoint(point : NSPoint, scale : CGFloat) {
        let applicationPoint = editor.imageToApplication(point)

        let centerTrans = CGAffineTransformTranslate(CGAffineTransformIdentity,
            -applicationPoint.x, -applicationPoint.y)

        var trans = CGAffineTransformConcat(editor.transform, centerTrans)

        let scale = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale)
        trans = CGAffineTransformConcat(trans, scale)

        let backTrans = CGAffineTransformTranslate(CGAffineTransformIdentity,
            applicationPoint.x, applicationPoint.y)

        trans = CGAffineTransformConcat(trans, backTrans)
        editor.transform = trans

        NSNotificationCenter.defaultCenter()
            .postNotificationName(PNNotificationZoomChanged,
                object: nil, userInfo: ["zoom" : zoom])
    }

    public func setZoomAroundApplicationSpacePoint(point : NSPoint, scale : CGFloat) {
        let imagePoint = editor.applicationToImage(point)
        let delta = scale / CGFloat(zoom)
        zoomAroundImageSpacePoint(imagePoint, scale: delta)
    }

    public func translateView(dx : CGFloat, _ dy : CGFloat) {
        let t = CGAffineTransformTranslate(CGAffineTransformIdentity, dx, dy);
        editor.transform = CGAffineTransformConcat(editor.transform, t)
    }

    override public func loadView() {
        super.loadView()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateComputedEditorImage:",
            name: PNDocumentNormalImageChanged,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateComputedEditorImage:",
            name: PNPreviewNeedsRedraw,
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

    override public func magnifyWithEvent(event: NSEvent) {
        let viewSpace = editor.convertPoint(event.locationInWindow, fromView: nil)
        let imageSpace = editor.applicationToImage(viewSpace)
        let amount = 1 + event.magnification

        zoomAroundImageSpacePoint(imageSpace, scale: amount)
    }

    public override func scrollWheel(theEvent: NSEvent) {
        translateView(theEvent.deltaX * PNScrollMultiplier,
                      -theEvent.deltaY * PNScrollMultiplier)
    }
}
