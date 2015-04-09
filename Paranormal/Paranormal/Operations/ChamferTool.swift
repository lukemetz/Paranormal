import Foundation
import CoreGraphics
import GPUImage
import Appkit

class ChamferTool {
    let document : Document
    var chamferLayer : Layer?

    init(document: Document) {
        self.document = document
    }

    func previewChamfer(#radius: Float, depth: Float, shape: Float) {
        ThreadUtils.runGPUImageDestructive { () -> Void in
            if let imageData = self.document.currentLayer?.imageData {
                let image = NSImage(data: imageData)
                // Apply the filter
                let chamfer = ChamferFilter(radius: radius, depth: depth, shape: shape)

                let source = GPUImagePicture(image: image)
                source.addTarget(chamfer)

                chamfer.useNextFrameForImageCapture()
                source.processImage()

                let resultImage = chamfer.imageFromCurrentFramebuffer()

                // Combine chamfer onto working layer as tilt operation
                if let chamferLayer = self.chamferLayer {
                    chamferLayer.imageData = resultImage?.TIFFRepresentation
                } else {
                    if let newLayer = self.document.rootLayer?.addLayer() {
                        newLayer.imageData = resultImage?.TIFFRepresentation
                        newLayer.blendMode = BlendMode.Add // TODO: Change me back!
                        self.chamferLayer = newLayer
                    }
                }
            }
        }
    }

    func finalizePreview() {
        if let chamferLayer = self.chamferLayer {
            if let currentLayer = document.currentLayer {
                currentLayer.combineLayerOntoSelf(chamferLayer)
            }
        }
        removeChamferLayer()
    }

    func cancel() {
        removeChamferLayer()
    }

    func removeChamferLayer() {
        if let rootLayer = document.rootLayer {
            if let chamferLayer = self.chamferLayer {
                rootLayer.removeLayer(chamferLayer)
                self.chamferLayer = nil
            }
        }
    }
}
