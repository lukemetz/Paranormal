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

    var viewWidth : CGFloat = 0.0
    var viewHeight : CGFloat = 0.0
    var imageWidth : CGFloat = 0.0
    var imageHeight : CGFloat = 0.0

    var document: Document?

    func editorViewDidLayout() {
        if let documentSettings = document?.documentSettings {
            viewWidth = editor.frame.width
            viewHeight = editor.frame.height

            if tempContext==nil {

                imageWidth = CGFloat(documentSettings.width)
                imageHeight = CGFloat(documentSettings.height)

                let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

                editorContext = CGBitmapContextCreate(nil, UInt(viewWidth),
                    UInt(viewHeight),  8,  0 , colorSpace, bitmapInfo)

                if let currentLayer  = document?.currentLayer {
                    currentLayer.drawToContext(editorContext!)
                }

                tempContext = CGBitmapContextCreate(nil, UInt(viewWidth),
                    UInt(viewHeight), 8, 0, colorSpace, bitmapInfo)
            }
        } else {
            log.error("Failed to setup editor, document has no documentSettings")
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCoreData:",
            name: NSManagedObjectContextObjectsDidChangeNotification, object: nil)
    }

    func updateCoreData(notification: NSNotification){
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

    override func mouseDown(theEvent: NSEvent) {
        mouseSwiped = false

        var locationInWindow = theEvent.locationInWindow
        var locationInFrame = editor.convertPoint(theEvent.locationInWindow, fromView: nil)
        lastPoint = CGPointMake(locationInFrame.x, locationInFrame.y)

        let rect = CGRectMake(0, 0, viewWidth, viewHeight)
        CGContextClearRect(tempContext, rect)
        CGContextSetFillColorWithColor(tempContext, CGColorCreateGenericRGB(0, 0, 1, 0))
        CGContextFillRect(tempContext, CGRectMake(0, 0, viewWidth, viewHeight))
    }

    override func mouseDragged(theEvent: NSEvent) {
        mouseSwiped = true

        var locationInWindow = theEvent.locationInWindow
        var locationInFrame = editor.convertPoint(theEvent.locationInWindow, fromView: nil)
        var currentPoint : CGPoint = CGPointMake(locationInFrame.x, locationInFrame.y)

        drawLine(tempContext, currentPoint: currentPoint)

        let image = CGBitmapContextCreateImage(tempContext!)
        tempEditor.image =
            NSImage(CGImage: image, size: NSSize(width: viewWidth, height: viewHeight))
        lastPoint = currentPoint
    }

    override func mouseUp(theEvent: NSEvent) {

        var locationInWindow = theEvent.locationInWindow
        var locationInFrame = editor.convertPoint(theEvent.locationInWindow, fromView: nil)
        var currentPoint : CGPoint = CGPointMake(locationInFrame.x, locationInFrame.y)

        drawLine(tempContext, currentPoint: currentPoint)

        var rect = CGRectMake(0, 0, viewWidth, viewHeight)
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
