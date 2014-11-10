import Foundation
import Cocoa
import AppKit

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

    override func awakeFromNib() {
        setUpEditor()
    }

    func setUpEditor() {
        let width = editor.frame.size.width
        let height = editor.frame.size.height

        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

        editorContext = CGBitmapContextCreate(nil, UInt(width),
            UInt(height),  8,  0 , colorSpace, bitmapInfo)
        CGContextSetFillColorWithColor(editorContext, CGColorCreateGenericRGB(0, 0, 1, 0))
        CGContextFillRect(editorContext, CGRectMake(0, 0, width, height))

        let image = CGBitmapContextCreateImage(editorContext!)

        tempContext = CGBitmapContextCreate(nil, UInt(width),
            UInt(height),  8,  0, colorSpace, bitmapInfo)
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
        lastPoint = theEvent.locationInWindow
        let width = editor.frame.size.width
        let height = editor.frame.size.height
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
        let width = editor.frame.size.width
        let height = editor.frame.size.height
        tempEditor.image = NSImage(CGImage: image, size: NSSize(width: width, height: height))

        lastPoint = currentPoint
    }

    override func mouseUp(theEvent: NSEvent) {
        let width = editor.frame.size.width
        let height = editor.frame.size.height
        var currentPoint : CGPoint = theEvent.locationInWindow
        drawLine(tempContext, currentPoint: currentPoint)

        var rect = CGRectMake(0, 0, width, height)
        var image = CGBitmapContextCreateImage(tempContext)
        CGContextDrawImage(editorContext, rect, image)

        let editorImage = CGBitmapContextCreateImage(editorContext!)
        editor.image = NSImage(CGImage: editorImage, size: NSSize(width: width, height: height))
        tempEditor.image = nil
    }
}