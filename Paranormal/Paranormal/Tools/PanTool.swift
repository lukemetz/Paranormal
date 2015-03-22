import Foundation

public class PanTool : NSObject, EditorActiveTool {
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)

    public override init() {
        super.init()
    }

    public func mouseDownAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        lastPoint = editorViewController.editor.imageToApplication(point)
    }

    private func transform(point : NSPoint, _ editorViewController: EditorViewController) {
        let applicationPoint = editorViewController.editor.imageToApplication(point)
        let dx = (applicationPoint.x - lastPoint.x)
        let dy = (applicationPoint.y - lastPoint.y)

        editorViewController.translateView(dx, dy)

        lastPoint = applicationPoint
    }

    public func mouseDraggedAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        transform(point, editorViewController)
    }

    public func mouseUpAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        transform(point, editorViewController)
    }

    public func stopUsingTool() {
    }
}
