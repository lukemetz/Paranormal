import Foundation

import Foundation

public class BrushTool : NSObject, EditorActiveTool {

    var editorContext : CGContext?
    var mouseSwiped : Bool = false
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)

    var brush : CGFloat = 10.0
    var opacity : CGFloat = 1.0
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

    func drawLine(wrapContext: CGContext?, currentPoint: CGPoint, color: NSColor) {
        if let context = wrapContext {
            CGContextMoveToPoint(context, lastPoint.x, lastPoint.y)
            CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y)
            CGContextSetLineCap(context, kCGLineCapRound)
            CGContextSetLineWidth(context, brush)
            CGContextSetRGBStrokeColor(context,
                color.redComponent, color.greenComponent, color.blueComponent, 1.0)
            CGContextSetBlendMode(context, kCGBlendModeNormal)
            CGContextStrokePath(context)
        }
    }

    public func mouseDownAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        if let currentLayer = editorViewController.currentLayer {
            lazySetupContext(currentLayer.size)
        }

        mouseSwiped = false
        editLayer = editorViewController.currentLayer?.createEditLayer()
        lastPoint = point
    }

    public func mouseDraggedAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        mouseSwiped = true

        if let color = editorViewController.color {
            drawLine(editorContext, currentPoint: point, color: color)
        }

        if let context = editorContext {
            editLayer?.updateFromContext(context)
        }

        lastPoint = point
    }

    public func mouseUpAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        if let color = editorViewController.color {
            drawLine(editorContext, currentPoint: point, color: color)
        }

        if let context = editorContext {
            editLayer?.updateFromContext(context)
        }

        if let layer = editLayer {
            editorViewController.currentLayer?.combineLayerOntoSelf(layer)
            editorViewController.currentLayer?.parent.removeLayer(layer)
        }

        editLayer = nil
    }
}
