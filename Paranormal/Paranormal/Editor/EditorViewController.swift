import Foundation
import Cocoa
import AppKit
import CoreGraphics

public class EditorViewController : PNViewController {

    @IBOutlet weak var editor: NSImageView!
    @IBOutlet weak var tempEditor: NSImageView!

    var editorContext : CGContext?
    var tempContext : CGContext?
    var mouseSwiped : Bool = false
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)

    var brush : CGFloat = 10.0
    var opacity : CGFloat = 1.0
    var viewSize : CGSize = CGSizeMake(0, 0)

    override public var document: Document? {
        didSet {
            if editor != nil {
                updateEditorWithDocument()
            }
        }
    }

    func updateEditorWithDocument() {
        if let documentSettings = document?.documentSettings {
            viewSize = CGSizeMake(CGFloat(documentSettings.width),
            CGFloat(documentSettings.height))

            let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

            editorContext = CGBitmapContextCreate(nil, UInt(viewSize.width),
                UInt(viewSize.height),  8,  0 , colorSpace, bitmapInfo)

            if let currentLayer  = document?.currentLayer {
                currentLayer.drawToContext(editorContext!)
            }

            tempContext = CGBitmapContextCreate(nil, UInt(viewSize.width),
                UInt(viewSize.height), 8, 0, colorSpace, bitmapInfo)

            editor.image = document?.computedEditorImage
        } else {
            log.error("Failed to setup editor, document has no documentSettings")
        }
    }

    override public func loadView() {
        super.loadView()
        updateEditorWithDocument()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateComputedEditorImage:",
            name: PNDocumentComputedEditorChanged,
            object: nil)
    }

    func updateComputedEditorImage(notification: NSNotification){
        editor.image = document?.computedEditorImage
    }

    func drawLine(context: CGContext?, currentPoint: CGPoint) {
        CGContextMoveToPoint(context, lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y)
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, brush)

        if let color = document?.currentColor {
            CGContextSetRGBStrokeColor(context,
                color.redComponent, color.greenComponent, color.blueComponent, 1.0)
        }
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        CGContextStrokePath(context)
    }

    func pointToContext(point: CGPoint) -> CGPoint {
        var point = editor.convertPoint(point, fromView: nil)

        if let documentSettings = document?.documentSettings {
            let width = CGFloat(documentSettings.width)
            let height = CGFloat(documentSettings.height)
            // The image in the imageview is placed in the center of the screen
            // Determine the difference in sizes then divide by two to get offset
            let offsetY = (height - editor.frame.size.height) / 2.0
            let offsetX = (width - editor.frame.size.width) / 2.0

            point = CGPointMake(point.x + offsetX, point.y + offsetY)
        } else {
            log.error("Could not convert point to drawing canvas")
        }

        return point
    }

    override public func mouseDown(theEvent: NSEvent) {
        mouseSwiped = false

        var locationInWindow = theEvent.locationInWindow
        lastPoint = pointToContext(theEvent.locationInWindow)

        let rect = CGRectMake(0, 0, viewSize.width, viewSize.height)
        CGContextClearRect(tempContext, rect)
        CGContextSetFillColorWithColor(tempContext, CGColorCreateGenericRGB(0, 0, 1, 0))
        CGContextFillRect(tempContext, CGRectMake(0, 0, viewSize.width, viewSize.height))
    }

    override public func mouseDragged(theEvent: NSEvent) {
        mouseSwiped = true

        var locationInWindow = theEvent.locationInWindow
        var currentPoint = pointToContext(theEvent.locationInWindow)

        drawLine(tempContext, currentPoint: currentPoint)

        let image = CGBitmapContextCreateImage(tempContext!)
        tempEditor.image =
            NSImage(CGImage: image, size: NSSize(width: viewSize.width, height: viewSize.height))
        lastPoint = currentPoint
    }

    override public func mouseUp(theEvent: NSEvent) {
        let currentPoint : CGPoint = pointToContext(theEvent.locationInWindow)

        drawLine(tempContext, currentPoint: currentPoint)

        var rect = CGRectMake(0, 0, viewSize.width, viewSize.height)
        var image = CGBitmapContextCreateImage(tempContext)

        if let context = editorContext {
            document?.currentLayer?.drawToContext(context)
        }

        CGContextDrawImage(editorContext, rect, image)

        if let context = editorContext {
            document?.currentLayer?.updateFromContext(context)
        }

        editor.image = document?.computedEditorImage
        tempEditor.image = nil
    }
}
