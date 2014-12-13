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



    var document: Document?

    func editorViewDidLayout() {
        if let documentSettings = document?.documentSettings {
            viewSize = CGSizeMake(editor.frame.width, editor.frame.height)

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
        lastPoint = editor.convertPoint(theEvent.locationInWindow, fromView: nil)

        let rect = CGRectMake(0, 0, viewSize.width, viewSize.height)
        CGContextClearRect(tempContext, rect)
        CGContextSetFillColorWithColor(tempContext, CGColorCreateGenericRGB(0, 0, 1, 0))
        CGContextFillRect(tempContext, CGRectMake(0, 0, viewSize.width, viewSize.height))
    }

    override func mouseDragged(theEvent: NSEvent) {
        mouseSwiped = true

        var locationInWindow = theEvent.locationInWindow
        var currentPoint = editor.convertPoint(theEvent.locationInWindow, fromView: nil)

        drawLine(tempContext, currentPoint: currentPoint)

        let image = CGBitmapContextCreateImage(tempContext!)
        tempEditor.image =
            NSImage(CGImage: image, size: NSSize(width: viewSize.width, height: viewSize.height))
        lastPoint = currentPoint
    }

    override func mouseUp(theEvent: NSEvent) {

        let locationInWindow = theEvent.locationInWindow
        let currentPoint : CGPoint = editor.convertPoint(theEvent.locationInWindow, fromView: nil)

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
