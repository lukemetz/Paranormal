import Foundation
import CoreGraphics
import GPUImage
import Appkit

class AutomaticToolSettings {
    var depth : Float = 0.0
}

class AutomaticTool : EditorActiveTool {
    var heightMap : NSImage?

    init() {
    }

    func setup(document : Document) {
        ThreadUtils.runGPUImageDestructive { () -> Void in
            let alphaMask = GPUImageFilter(fragmentShaderFromFile: "AlphaToBlack")
            let mask = alphaMask.imageByFilteringImage(document.baseImage)
            NSImageHelper.writeToFile(mask, path: "/Users/scope/Desktop/input.png")
            self.heightMap = AutomaticGeneration.generatePossionHeightMap(mask)
            document.singleWindowController?.debug.image = self.heightMap
        }

        update(document, settings: AutomaticToolSettings())
    }

    func update(document : Document, settings : AutomaticToolSettings) {
        ThreadUtils.runGPUImageDestructive { () -> Void in
            let depthToNormal = DepthToNormalFilter()
            let img = depthToNormal.imageByFilteringImage(self.heightMap)
            document.currentLayer?.imageData = img.TIFFRepresentation;
//            
//            if let imageData = document.currentLayer?.imageData {
//                let image = NSImage(data: imageData)
//                // Apply the filter
//                let chamfer = ChamferFilter()
//
//                let source = GPUImagePicture(image: image)
//                source.addTarget(chamfer)
//
//                chamfer.useNextFrameForImageCapture()
//                source.processImage()
//
//                let resultImage = chamfer.imageFromCurrentFramebuffer()
//
//                // Combine chamfer onto working layer as tilt operation
//                if let currentLayer = document.currentLayer {
//                    if let newLayer = document.rootLayer?.addLayer() {
//                        newLayer.imageData = resultImage?.TIFFRepresentation
//                        newLayer.blendMode = BlendMode.Tilt
//                        currentLayer.combineLayerOntoSelf(newLayer)
//                    }
//                }
//            }
        }
    }

    func mouseDownAtPoint(point : NSPoint, editorViewController: EditorViewController) {
    }
    func mouseDraggedAtPoint(point : NSPoint, editorViewController: EditorViewController) {
    }
    func mouseUpAtPoint(point : NSPoint, editorViewController: EditorViewController) {
    }
}
