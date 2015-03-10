import Foundation

import Foundation

public class BrushTool : NSObject, EditorActiveTool {
    var editLayer : Layer?
    var drawingKernel : DrawingKernel?

    override init() {
        super.init()
    }

    func lazySetupKernel(size : CGSize) {
        if drawingKernel == nil {
            drawingKernel = CGDrawingKernel(size: size)
        }
    }

    func initializeEditLayer() {
    }

    public func mouseDownAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        if let currentLayer = editorViewController.currentLayer {
            lazySetupKernel(currentLayer.size)
        }

        editLayer = editorViewController.currentLayer?.createEditLayer()

        if let brushOpacity = editorViewController.brushOpacity {
            editLayer?.opacity = Float(brushOpacity)
        }

        initializeEditLayer()

        drawingKernel?.startDraw() { (image) -> () in
            self.editLayer?.imageData = image.TIFFRepresentation
            return
        }
    }

    public func mouseDraggedAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        if let brushSize = editorViewController.brushSize {
            if let color = editorViewController.color {
                let b = Brush(size: CGFloat(brushSize), color: color)
                drawingKernel?.addPoint(point, brush: b)
            }
        }
    }

    public func mouseUpAtPoint(point : NSPoint, editorViewController: EditorViewController) {
        if let brushSize = editorViewController.brushSize {
            if let color = editorViewController.color {
                let b = Brush(size: CGFloat(brushSize), color: color)
                drawingKernel?.addPoint(point, brush: b)
            }
        }

        drawingKernel?.stopDraw() {
            if let layer = self.editLayer {
                editorViewController.currentLayer?.combineLayerOntoSelf(layer)
            }
            self.editLayer = nil
        }
    }
}
