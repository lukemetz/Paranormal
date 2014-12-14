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

    var document: Document?

    override func loadView() {
        super.loadView()
        setUpEditor()
    }

    func setUpEditor() {
        if let documentSettings = document?.documentSettings {

            let width = documentSettings.width
            let height = documentSettings.height

            let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

            editorContext = CGBitmapContextCreate(nil, UInt(width),
                UInt(height), 8, 0, colorSpace, bitmapInfo)

            if let currentLayer  = document?.currentLayer {
                currentLayer.drawToContext(editorContext!)
            }

            tempContext = CGBitmapContextCreate(nil, UInt(width),
                UInt(height), 8, 0, colorSpace, bitmapInfo)
        } else {
            println("[Error] Failed to setup editor, document has no documentSettings")
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

        if let color = document?.currentColor {
            CGContextSetRGBStrokeColor(context,
                color.redComponent, color.greenComponent, color.blueComponent, 1.0)
        }
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        CGContextStrokePath(context)
    }

    override func mouseDown(theEvent: NSEvent) {
        mouseSwiped = false
        lastPoint = theEvent.locationInWindow
        let width = CGFloat(CGBitmapContextGetWidth(tempContext))
        let height = CGFloat(CGBitmapContextGetHeight(tempContext))
        let rect = CGRectMake(0, 0, width, height)

        CGContextClearRect(tempContext, rect)
        CGContextSetFillColorWithColor(tempContext, CGColorCreateGenericRGB(0, 0, 1, 0))
        CGContextFillRect(tempContext, CGRectMake(0, 0, width, height))
    }

    override func mouseDragged(theEvent: NSEvent) {
        mouseSwiped = true
        var currentPoint : CGPoint = theEvent.locationInWindow
        drawLine(tempContext, currentPoint: currentPoint)

        let image = CGBitmapContextCreateImage(tempContext!)
        let width = CGFloat(CGBitmapContextGetWidth(tempContext))
        let height = CGFloat(CGBitmapContextGetHeight(tempContext))
        tempEditor.image = NSImage(CGImage: image, size: NSSize(width: width, height: height))

        lastPoint = currentPoint
    }

    override func mouseUp(theEvent: NSEvent) {
        let width = CGFloat(CGBitmapContextGetWidth(tempContext))
        let height = CGFloat(CGBitmapContextGetHeight(tempContext))
        var currentPoint : CGPoint = theEvent.locationInWindow
        drawLine(tempContext, currentPoint: currentPoint)

        var rect = CGRectMake(0, 0, width, height)
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
