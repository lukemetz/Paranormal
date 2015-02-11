import Foundation
import Cocoa
import AppKit
import CoreGraphics

public class EditorViewController : PNViewController {

    @IBOutlet public weak var editor: EditorView!

    var editorContext : CGContext?
    var mouseSwiped : Bool = false
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)

    var brush : CGFloat = 10.0
    var opacity : CGFloat = 1.0
    var viewSize : CGSize = CGSizeMake(0, 0)

    var editLayer : Layer?

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

    func updateComputedEditorImage(notification: NSNotification) {
        // Run on main thread for core animation
        dispatch_async(dispatch_get_main_queue()) {
                self.editor.image = self.document?.computedEditorImage
        }
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
        return point
    }

    override public func mouseDown(theEvent: NSEvent) {
        mouseSwiped = false
        editLayer = document?.currentLayer?.createEditLayer()
        var locationInWindow = theEvent.locationInWindow
        lastPoint = pointToContext(theEvent.locationInWindow)

        let rect = CGRectMake(0, 0, viewSize.width, viewSize.height)
        CGContextClearRect(editorContext, rect)
        CGContextSetFillColorWithColor(editorContext, CGColorCreateGenericRGB(0, 0, 1, 0))
        CGContextFillRect(editorContext, CGRectMake(0, 0, viewSize.width, viewSize.height))
    }

    override public func mouseDragged(theEvent: NSEvent) {
        mouseSwiped = true

        var locationInWindow = theEvent.locationInWindow
        var currentPoint = pointToContext(theEvent.locationInWindow)

        drawLine(editorContext, currentPoint: currentPoint)

        if let context = editorContext {
            editLayer?.updateFromContext(context)
        }

        lastPoint = currentPoint
    }

    override public func mouseUp(theEvent: NSEvent) {
        let currentPoint : CGPoint = pointToContext(theEvent.locationInWindow)

        drawLine(editorContext, currentPoint: currentPoint)

        if let context = editorContext {
            editLayer?.updateFromContext(context)
        }

        if let layer = editLayer {
            document?.currentLayer?.combineLayerOntoSelf(layer)
            document?.currentLayer?.parent.removeLayer(layer)
        }

        editLayer = nil
    }

    public func getPixelColor(x: CGFloat, _ y: CGFloat) -> NSColor? {
        let pos : CGPoint = CGPointMake(x, y)
        if let documentSettings = document?.documentSettings {
            self.updateEditorWithDocument()
            if let image = editor.image {
                var imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
                var imageRef = image.CGImageForProposedRect(&imageRect, context: nil, hints: nil)
                let width = CGFloat(documentSettings.width)

                let dataProvider : CGDataProvider! =
                CGImageGetDataProvider(imageRef?.takeUnretainedValue())
                var pixelData = CGDataProviderCopyData(dataProvider)
                var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
                var index: Int = ((Int(width) * Int(pos.y)) + Int(pos.x)) * 4

                let color = NSColor(red: CGFloat(data[index]), green: CGFloat(data[index+1]),
                    blue: CGFloat(data[index+2]), alpha: CGFloat(data[index+3]))
                return color
            }
        }
        return nil
    }
}
