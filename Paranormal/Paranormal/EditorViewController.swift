import Foundation
import Cocoa
import AppKit
import CoreGraphics

class EditorViewController : NSViewController {

    @IBOutlet weak var editor: NSImageView!
    @IBOutlet weak var tempEditor: NSImageView!

    var editorContext : CGContext?
    var tempContext : CGContext?
    var mouseSwiped : Bool = false
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)

    var red : CGFloat = 0.0/255.0
    var green : CGFloat =  0.0/255.0
    var blue : CGFloat =  0.0/255.0
    var brush : CGFloat = 10.0
    var opacity : CGFloat = 1.0
    var viewSize : CGSize = CGSizeMake(0, 0)

    var document: Document? {
        didSet {
            if editor != nil {
                editor.image = document?.computedEditorImage
            }
        }
    }

    func editorViewDidLayout() {
        if let documentSettings = document?.documentSettings {
            viewSize = CGSizeMake(CGFloat(documentSettings.width),
                CGFloat(documentSettings.height))

            if tempContext == nil {
                let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

                editorContext = CGBitmapContextCreate(nil, UInt(viewSize.width),
                    UInt(viewSize.height),  8,  0 , colorSpace, bitmapInfo)

                if let currentLayer  = document?.currentLayer {
                    currentLayer.drawToContext(editorContext!)
                }

                tempContext = CGBitmapContextCreate(nil, UInt(viewSize.width),
                    UInt(viewSize.height), 8, 0, colorSpace, bitmapInfo)
            }
        } else {
            log.error("Failed to setup editor, document has no documentSettings")
        }

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
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        CGContextStrokePath(context)
    }

    func pointToContext(point: CGPoint) -> CGPoint {
        var point = editor.convertPoint(point, fromView: nil)

        if let documentSettings = document?.documentSettings {
            let width = CGFloat(documentSettings.width)
            let height = CGFloat(documentSettings.height)
            let offsetY = (height - editor.frame.size.height) / 2.0
            let offsetX = (width - editor.frame.size.width) / 2.0

            point = CGPointMake(point.x + offsetX, point.y + offsetY)
        } else {
            log.error("Could not convert point to drawing canvas")
        }

        return point
    }

    override func mouseDown(theEvent: NSEvent) {
        mouseSwiped = false

        var locationInWindow = theEvent.locationInWindow
        lastPoint = pointToContext(theEvent.locationInWindow)

        let rect = CGRectMake(0, 0, viewSize.width, viewSize.height)
        CGContextClearRect(tempContext, rect)
        CGContextSetFillColorWithColor(tempContext, CGColorCreateGenericRGB(0, 0, 1, 0))
        CGContextFillRect(tempContext, CGRectMake(0, 0, viewSize.width, viewSize.height))
    }

    override func mouseDragged(theEvent: NSEvent) {
        mouseSwiped = true

        var locationInWindow = theEvent.locationInWindow
        var currentPoint = pointToContext(theEvent.locationInWindow)

        drawLine(tempContext, currentPoint: currentPoint)

        let image = CGBitmapContextCreateImage(tempContext!)
        tempEditor.image =
            NSImage(CGImage: image, size: NSSize(width: viewSize.width, height: viewSize.height))
        lastPoint = currentPoint
    }

    override func mouseUp(theEvent: NSEvent) {
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
