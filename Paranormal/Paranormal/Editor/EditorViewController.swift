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

    public func getPixelColor(x: CGFloat, _ y: CGFloat) -> NSColor? {
        let pos : CGPoint = CGPointMake(x, y)
        if let documentSettings = document?.documentSettings {
            if let image = editor.image {
                var imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
                var imageRef = image.CGImageForProposedRect(&imageRect, context: nil, hints: nil)
                let width = CGFloat(documentSettings.width)

                let dataProvider : CGDataProvider! =
                CGImageGetDataProvider(imageRef?.takeUnretainedValue())
                var pixelData = CGDataProviderCopyData(dataProvider)
                var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                var index: Int = ((Int(width) * Int(pos.y)) + Int(pos.x)) * 4

                let color = NSColor(red: CGFloat(data[index]), green: CGFloat(data[index+1]),
                    blue: CGFloat(data[index+2]), alpha: CGFloat(data[index+3]))
                return color
            }
        }
        return nil
    }
}
