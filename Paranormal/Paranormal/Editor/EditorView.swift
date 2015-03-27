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

    public var transform : CGAffineTransform = CGAffineTransformIdentity {
        didSet {
            needsDisplay = true
        }
    }

    override public func drawRect(dirtyRect: NSRect) {
        let context = NSGraphicsContext.currentContext()?.CGContext
        if let context = context {
            if let img = image {
                let drawImg = NSImageHelper.CGImageFrom(img)

                CGContextConcatCTM(context, transform)
                CGContextDrawImage(context,
                    CGRectMake(0,0,img.size.width, img.size.height),
                    drawImg)

            }
        }
    }

    public func applicationToImage(aPoint: CGPoint) -> CGPoint {
        return CGPointApplyAffineTransform(aPoint, CGAffineTransformInvert(transform))
    }

    public func imageToApplication(aPoint: CGPoint) -> CGPoint {
        return CGPointApplyAffineTransform(aPoint, transform)
    }
}
