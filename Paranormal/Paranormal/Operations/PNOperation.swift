import Foundation
import GPUImage

class PNOperation {
    let document : Document
    var operationLayer : Layer?
    var operationFilter : GPUImageFilterGroup? {
        didSet(newFilter) {
            updateWithNewFilter()
        }
    }
    var blendMode : BlendMode

    init(document: Document, filter: GPUImageFilterGroup?, blendMode: BlendMode = .Tilt) {
        self.document = document
        self.operationFilter = filter
        self.blendMode = blendMode
    }

    func create() {
        createLayerWithFilter(self.operationFilter)
    }

    func updateWithNewFilter() {
        // updates operation layer with current operation filter parameters
        ThreadUtils.runGPUImageDestructive { () -> Void in
            if let operationLayer = self.operationLayer {
                if let image = self.resultFromFilter(self.operationFilter) {
                    operationLayer.imageData = image.TIFFRepresentation
                }
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName(
            NSManagedObjectContextObjectsDidChangeNotification,
            object: nil)
    }

    func confirm() {
        if let operationLayer = self.operationLayer {
            if let currentLayer = document.currentLayer {
                currentLayer.combineLayerOntoSelf(operationLayer)
            }
        }
        removeOperationLayer()
    }

    func cancel() {
        removeOperationLayer()
    }

    func createLayerWithImage(image: NSImage?) {
        if let newLayer = self.document.rootLayer?.addLayer() {
            newLayer.imageData = image?.TIFFRepresentation
            newLayer.blendMode = self.blendMode
            self.operationLayer = newLayer
        }
    }

    func createLayerWithFilter(operationFilter: GPUImageFilterGroup?) {
        ThreadUtils.runGPUImageDestructive { () -> Void in
            self.createLayerWithImage(self.resultFromFilter(operationFilter))
        }
    }

    func resultFromFilter(operationFilter: GPUImageFilterGroup?) -> NSImage? {
        // Must be run on a GPUImage thread
        var resultImage : NSImage?
        if let imageData = self.document.currentLayer?.imageData {
            if let filter = operationFilter {
                let source = GPUImagePicture(image: NSImage(data: imageData))
                source.addTarget(operationFilter)

                filter.useNextFrameForImageCapture()
                source.processImage()

                resultImage = filter.imageFromCurrentFramebuffer()
            }
        }
        return resultImage
    }

    func removeOperationLayer() {
        if let rootLayer = document.rootLayer {
            if let operationLayer = self.operationLayer {
                rootLayer.removeLayer(operationLayer)
                self.operationLayer = nil
            }
        }
    }
}
