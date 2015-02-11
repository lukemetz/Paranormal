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
    var translate : CGVector = CGVectorMake(0, 0)
    var scale : CGVector = CGVectorMake(1, 1)

    override public func drawRect(dirtyRect: NSRect) {
        let context = NSGraphicsContext.currentContext()?.CGContext
        if let context = context {
            if let img = image {
                let drawImg = image?.CGImageForProposedRect(nil, context: nil, hints: nil)
                CGContextDrawImage(context,
                                   CGRectMake(0,0,img.size.width, img.size.height),
                                   drawImg?.takeUnretainedValue())
                CGContextTranslateCTM (context, translate.dx, translate.dy)
                CGContextScaleCTM (context, scale.dx, scale.dy)
            }
        }
    }
}
