import Foundation

import Foundation

public class BrushTool : NSObject, EditorActiveTool {
    public var editLayer : Layer?
    public var drawingKernel : DrawingKernel?

    override init() {
        super.init()
    }

    func lazySetupKernel(size : CGSize) {
        if drawingKernel == nil {
            drawingKernel = GLDrawingKernel(size: size)
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
            self.editLayer?.managedObjectContext?.performBlock({ () -> Void in
                self.editLayer?.imageData = image.TIFFRepresentation
                return
            })
            return
        }
        editorViewController.document?.managedObjectContext.undoManager?.beginUndoGrouping()
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
            self.editLayer?.managedObjectContext?.performBlockAndWait({ () -> Void in
                if let layer = self.editLayer {
                    editorViewController.currentLayer?.combineLayerOntoSelf(layer)
                }
                self.editLayer = nil
                editorViewController.document?.managedObjectContext.undoManager?.endUndoGrouping()
                return
            })
            return
        }
    }

    // Call when no longer using the tool.
    public func stopUsingTool() {
        drawingKernel?.destroy()
    }
}
