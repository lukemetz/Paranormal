import Foundation
import CoreGraphics
import GPUImage
import Appkit

class ChamferTool {
    func perform(document: Document) {
        ThreadUtils.runGPUImageDestructive { () -> Void in
            if let imageData = document.currentLayer?.imageData {
                let image = NSImage(data: imageData)
                // Apply the filter
                let chamfer = ChamferFilter()

                let source = GPUImagePicture(image: image)
                source.addTarget(chamfer)

                chamfer.useNextFrameForImageCapture()
                source.processImage()

                let resultImage = chamfer.imageFromCurrentFramebuffer()

                // Combine chamfer onto working layer as tilt operation
                if let currentLayer = document.currentLayer {
                    if let newLayer = document.rootLayer?.addLayer() {
                        newLayer.imageData = resultImage?.TIFFRepresentation
                        newLayer.blendMode = BlendMode.Tilt
                        currentLayer.combineLayerOntoSelf(newLayer)
                    }
                }
            }
        }
    }
}
