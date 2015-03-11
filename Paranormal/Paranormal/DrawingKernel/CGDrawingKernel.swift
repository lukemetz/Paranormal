import Foundation
import Cocoa

class CGDrawingKernel: DrawingKernel {
    var editorContext : CGContext?
    var lastPoint: CGPoint?

    var updateFunc: ((image : NSImage) -> Void)?
    var size : NSSize
    init(size : NSSize) {
        self.size = size
    }

    func startDraw(update : (image : NSImage) -> Void) {
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        editorContext = CGBitmapContextCreate(nil, UInt(size.width),
            UInt(size.height),  8,  0 , colorSpace, bitmapInfo)
        updateFunc = update
    }

    func addPoint(point : CGPoint, brush : Brush) {
        if let context = editorContext {
            if let lp = lastPoint {
                CGContextMoveToPoint(context, lp.x, lp.y)
                CGContextAddLineToPoint(context, point.x, point.y)
                CGContextSetLineCap(context, kCGLineCapRound)
                CGContextSetLineWidth(context, brush.size)
                CGContextSetRGBStrokeColor(context,
                    brush.color.redComponent,
                    brush.color.greenComponent,
                    brush.color.blueComponent, 1.0)
                CGContextSetBlendMode(context, kCGBlendModeNormal)
                CGContextStrokePath(context)
            }
            lastPoint = point

            let cgImage = CGBitmapContextCreateImage(context)
            let width = CGImageGetWidth(cgImage)
            let height = CGImageGetHeight(cgImage)

            let size = NSSize(width: Int(width), height: Int(height))
            let nsImage = NSImage(CGImage: cgImage, size: size)
            if let update = updateFunc {
                update(image: nsImage)
            }
        }
    }

    func stopDraw(finish : () -> Void) {
        finish()

        editorContext = nil
        lastPoint = nil
        updateFunc = nil
    }
}
