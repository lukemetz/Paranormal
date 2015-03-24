import Foundation

public protocol EditorActiveTool {
    func mouseDownAtPoint(point : NSPoint, editorViewController: EditorViewController);
    func mouseDraggedAtPoint(point : NSPoint, editorViewController: EditorViewController);
    func mouseUpAtPoint(point : NSPoint, editorViewController: EditorViewController);
}
