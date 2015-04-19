import Foundation
import Cocoa
import AppKit

public class EditorView : NSView {

    @IBOutlet var delegate : EditorViewController?

    private var defaultCursor : NSCursor = NSCursor.arrowCursor()
    var editorCursor : NSCursor?

    func createCustomCursor() {
        if let editor = delegate {
            if let doc = editor.document? {
                let radius : CGFloat = CGFloat(
                    (doc.toolSettings.size/2.0)*(editor.zoom))
                let image : NSImage = drawCircle(radius: radius)
                editorCursor = NSCursor(image: image, hotSpot: NSPoint(x: radius, y: radius))
                updateTrackingAreas()
            }
        }
    }

    func drawCircle(#radius : CGFloat) -> NSImage {
        let imageSideLength : CGFloat = radius*2.0
        let imageSize = CGSize(width: imageSideLength, height: imageSideLength)

        let diameter : CGFloat = max( 0.001, ((radius - 2.0)*2.0))
        let circleBoundsSize = CGSize(width: diameter, height: diameter)
        let circleBounds = CGRect(origin : CGPoint(x: 2.0 , y: 1.0), size: circleBoundsSize)

        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

        var context = CGBitmapContextCreate(nil, UInt(imageSize.width),
            UInt(imageSize.height),  8,  0 , colorSpace, bitmapInfo)

        CGContextSetStrokeColorWithColor(context, NSColor.darkGrayColor().CGColor)
        CGContextSetLineWidth(context, 1.0)
        CGContextStrokeEllipseInRect(context, circleBounds)

        let image = CGBitmapContextCreateImage(context)
        return NSImage(CGImage: image, size: imageSize)
    }

    public override func viewDidMoveToSuperview() {
        createCustomCursor()
        setTrackingArea()
    }

    public override func updateTrackingAreas() {
        if (trackingAreas.count > 0) {
            for index in 1...trackingAreas.count{
                removeTrackingArea(trackingAreas[0] as NSTrackingArea)
            }
        }
        setTrackingArea()
    }

    func setTrackingArea() {
        if let editorContainer = self.superview {
            if let windowView = editorContainer.superview {
                let rect = windowView.convertRect(editorContainer.frame, toView: editorContainer)

                var trackingArea : NSTrackingArea =
                NSTrackingArea(rect: rect,
                    options: NSTrackingAreaOptions.MouseEnteredAndExited |
                        NSTrackingAreaOptions.MouseMoved |
                        NSTrackingAreaOptions.ActiveAlways,
                    owner: self, userInfo: nil)

                addTrackingArea(trackingArea)
            }
        }
    }

    override public func mouseEntered(theEvent: NSEvent) {
        if let cursor = editorCursor {
            cursor.set()
        }
    }

    override public func mouseExited(theEvent: NSEvent) {
        defaultCursor.set()
    }

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
            createCustomCursor()
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
