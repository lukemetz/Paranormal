import Foundation
import Cocoa
import AppKit

public class EditorView : NSView {

    @IBOutlet var delegate : EditorViewController?

    override public func mouseDown(theEvent: NSEvent) {
        let _ = self.delegate?.mouseDown(theEvent)
    }

    override public func mouseDragged(theEvent: NSEvent) {
        let _ = self.delegate?.mouseDragged(theEvent)
    }

    override public func mouseUp(theEvent: NSEvent) {
        let _ = self.delegate?.mouseUp(theEvent)
    }

    public var image : NSImage? {
        didSet {
            // Redraw view
            needsDisplay = true
        }
    }

    public var translate : CGVector = CGVectorMake(0, 0) {
        didSet {
            // Redraw view
            needsDisplay = true
        }
    }
    public var scale : CGVector = CGVectorMake(1, 1) {
        didSet {
            // Redraw view
            needsDisplay = true
        }
    }

    override public func drawRect(dirtyRect: NSRect) {
        let context = NSGraphicsContext.currentContext()?.CGContext
        if let context = context {
            if let img = image {
                let drawImg = image?.CGImageForProposedRect(nil, context: nil, hints: nil)
                CGContextTranslateCTM(context, translate.dx, translate.dy)
                CGContextScaleCTM(context, scale.dx, scale.dy)
                CGContextDrawImage(context,
                                   CGRectMake(0,0,img.size.width, img.size.height),
                                   drawImg?.takeUnretainedValue())

            }
        }
    }

    public func applicationToImage(aPoint: CGPoint) -> CGPoint {
        let unTranslate = NSPoint(x: aPoint.x - translate.dx, y: aPoint.y - translate.dy)

        let unScale = NSPoint(x: unTranslate.x / scale.dx, y: unTranslate.y / scale.dy)
        return unScale
    }

    public func imageToApplication(aPoint: CGPoint) -> CGPoint {
        let unScale = NSPoint(x: aPoint.x * scale.dx, y: aPoint.y * scale.dy)
        let unTranslate = NSPoint(x: unScale.x + translate.dx, y: unScale.y + translate.dy)

        return unTranslate
    }
}
