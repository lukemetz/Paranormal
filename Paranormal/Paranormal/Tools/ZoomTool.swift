import Foundation

public class ZoomTool : NSObject, EditorActiveTool {
    public override init() {
        super.init()
    }

    var scaleAmount: CGFloat = 1.5

    public func mouseDownAtPoint(point : NSPoint, editorViewController: EditorViewController) {
    }

    public func mouseUpAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        editorViewController.zoomAroundImageSpacePoint(point, scale: scaleAmount)
    }

    public func mouseDraggedAtPoint(point : NSPoint, editorViewController: EditorViewController) {
    }
}
