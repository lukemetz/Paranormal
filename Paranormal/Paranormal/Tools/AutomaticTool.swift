import Foundation
import CoreGraphics
import GPUImage
import Appkit

class AutomaticToolSettings {
    var depth : Float = 0.0
}

public class AutomaticTool {
    var heightMap : NSImage?
    var running = false

    let document : Document
    var chamferLayer : Layer?

    public init(document: Document) {
        self.document = document
    }

    public func setup(document : Document) {
        running = true
        ThreadUtils.runGPUImageDestructive { () -> Void in
            let alphaMask = GPUImageFilter(fragmentShaderFromFile: "AlphaToBlack")
            let mask = alphaMask.imageByFilteringImage(document.baseImage)
            NSImageHelper.writeToFile(mask, path: "/Users/scope/Desktop/input.png")
            self.heightMap = AutomaticGeneration.generatePossionHeightMap(mask)
            //document.singleWindowController?.debug.image = self.heightMap
        }

        update(document, settings: AutomaticToolSettings())
    }

    func update(document : Document, settings : AutomaticToolSettings) {
        ThreadUtils.runGPUImageDestructive { () -> Void in
            let spriteOverlay = SpriteOverlayFilter()

            let base = GPUImagePicture(image: document.baseImage)
            base.addTarget(spriteOverlay)

            let height = GPUImagePicture(image: self.heightMap)
            height.addTarget(spriteOverlay)

            let depthToNormal = DepthToNormalFilter()

            spriteOverlay.addTarget(depthToNormal)
            depthToNormal.useNextFrameForImageCapture()


            //chamfer.useNextFrameForImageCapture()
            base.processImage()
            height.processImage()



            //spriteOverlay.useNextFrameForImageCapture()
            //let img = spriteOverlay.imageFromCurrentFramebuffer()
            let image = depthToNormal.imageFromCurrentFramebuffer()

            if let currentLayer = document.currentLayer {
                if let newLayer = document.rootLayer?.addLayer() {
                    newLayer.imageData = image?.TIFFRepresentation
                    newLayer.name = "Noise Layer"
                    newLayer.blendMode = BlendMode.Tilted
                    currentLayer.combineLayerOntoSelf(newLayer)
                }
            }
            //let img = depthToNormal.imageByFilteringImage(self.heightMap)
            //document.currentLayer?.imageData = img.TIFFRepresentation;
            NSImageHelper.writeToFile(image, path: "/Users/scope/Desktop/outputFinal.png")

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
            self.running = false
        }
    }
}
