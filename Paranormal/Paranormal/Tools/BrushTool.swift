import Foundation

import Foundation

public class BrushTool : NSObject, EditorActiveTool {

    var editorContext : CGContext?
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)
    var editLayer : Layer?

    override init() {
        super.init()
    }

    func lazySetupContext(size : CGSize) {
        if editorContext == nil {
            let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
            editorContext = CGBitmapContextCreate(nil, UInt(size.width),
                UInt(size.height),  8,  0 , colorSpace, bitmapInfo)
        }
    }

    func drawLine(context: CGContext?, currentPoint: CGPoint, color: NSColor, size: CGFloat) {
        CGContextMoveToPoint(context, lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y)
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, size)
        CGContextSetRGBStrokeColor(context,
            color.redComponent, color.greenComponent, color.blueComponent, 1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        CGContextStrokePath(context)
    }

    func drawStep(point : NSPoint, editorViewController: EditorViewController) {
        if let color = editorViewController.color {
            if let size = editorViewController.brushSize {
                drawLine(editorContext, currentPoint: point, color: color, size: CGFloat(size))
            }
        }

        if let context = editorContext {
            editLayer?.updateFromContext(context)
        }
    }

    func initializeEditLayer() {
    }

    public func mouseDownAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        if let currentLayer = editorViewController.currentLayer {
            lazySetupContext(currentLayer.size)
        }

        editLayer = editorViewController.currentLayer?.createEditLayer()

        if let brushOpacity = editorViewController.brushOpacity {
            editLayer?.opacity = Float(brushOpacity)
        }

        if let context = editorContext {
            editLayer?.drawToContext(context)
        }

        initializeEditLayer()

        lastPoint = point
    }

    public func mouseDraggedAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        drawStep(point, editorViewController: editorViewController)

        lastPoint = point
    }

    public func mouseUpAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        drawStep(point, editorViewController: editorViewController)

        if let layer = editLayer {
            editorViewController.currentLayer?.combineLayerOntoSelf(layer)
        }

        editLayer = nil
    }
}
