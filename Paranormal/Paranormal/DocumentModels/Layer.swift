import Foundation
import Cocoa
import GPUImage

public class Layer : NSManagedObject{
    @NSManaged public var visible : Bool
    @NSManaged public var name : String
    @NSManaged public var imageData : NSData?
    @NSManaged public var layers : NSMutableOrderedSet
    @NSManaged public var parent : Layer
    @NSManaged public var opacity : Float
    @NSManaged private var rawBlendMode : Int16

    public var blendMode : BlendMode {
        get {
            if let mode = BlendMode(rawValue: rawBlendMode) {
                return mode
            } else {
                log.error("Bad blend mode from core data")
                return BlendMode.Add
            }
        }

        set(newVal) {
            rawBlendMode = Int16(newVal.rawValue.value)
        }
    }

    public var size : NSSize {
        if let img = toImage() {
            return img.size
        } else {
            log.error("Cannot get size of layer. Returning nonsense size.")
            return NSSize()
        }
    }

    override public init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext?) {

            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    // Copies content of CGContext to data attribute
    public func updateFromContext(context: CGContext) {
        let cgImage = CGBitmapContextCreateImage(context)
        let width = CGImageGetWidth(cgImage)
        let height = CGImageGetHeight(cgImage)

        let size = NSSize(width: Int(width), height: Int(height))
        let nsImage = NSImage(CGImage: cgImage, size: size)
        // Hack to fix backwards compatibility with NSImage(CGImage:...) constructor
        if let image = (nsImage as NSObject) as? NSImage {
            if let data = image.TIFFRepresentation {
                self.imageData = data
            } else {
                log.error("Could not set image data")
            }
        } else {
            log.error("Could not unwrap constructed NSImage")
        }
    }

    // Clear and draw the layers data to a CGContext
    public func drawToContext(context: CGContext) {
        let source = CGImageSourceCreateWithData(self.imageData, nil)
        let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)

        let width = CGImageGetWidth(cgImage)
        let height = CGImageGetHeight(cgImage)
        let rect = CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height))
        CGContextClearRect(context, rect)

        CGContextDrawImage(context, rect, cgImage)
    }

    func fillWithEmpty(size: NSSize) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        var context = CGBitmapContextCreate(nil, UInt(size.width), UInt(size.height),
            8, 0, colorSpace, bitmapInfo)
        CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height))
        let cgImage = CGBitmapContextCreateImage(context)

        let nsImage = NSImage(CGImage: cgImage, size: size)

        self.imageData = nsImage.TIFFRepresentation
    }

    public func toImage() -> NSImage? {
        if let data = imageData {
            return NSImage(data: data)
        } else {
            return nil
        }
    }

    public func addLayer() -> Layer? {
        if let context = managedObjectContext {
            let layerDescription = NSEntityDescription.entityForName("Layer",
                inManagedObjectContext: context)!
            let layer = Layer(entity: layerDescription,
                insertIntoManagedObjectContext: managedObjectContext)
            layer.name = "Unnamed Layer"
            layer.visible = true
            let index = layers.count
            layers.insertObject(layer, atIndex: index)
            layer.parent = self
            if let size = self.toImage()?.size {
                layer.fillWithEmpty(size)
            } else {
                log.error("Parent layer does not have image data")
            }
            return layer
        } else {
            return nil
        }
    }

    public func removeLayer(layer : Layer) {
        self.layers.removeObject(layer)
        managedObjectContext?
            .deleteObject(layer)
        self.managedObjectContext?.refreshObject(layer, mergeChanges: false)
        self.managedObjectContext?.save(nil)
    }

    public func createEditLayer() -> Layer? {
        if let context = managedObjectContext {
            let layerDescription = NSEntityDescription.entityForName("Layer",
                inManagedObjectContext: context)!
            let layer = Layer(entity: layerDescription,
                insertIntoManagedObjectContext: managedObjectContext)
            layer.name = "Edit Layer"
            layer.visible = true
            let index = parent.layers.indexOfObject(self)
            parent.layers.insertObject(layer, atIndex: index+1)
            if let size = self.toImage()?.size {
                layer.fillWithEmpty(size)
            } else {
                log.error("current layer to make edit does not have image data")
            }
            return layer
        } else {
            return nil
        }
    }

    // TODO test me with image data accessors
    public func combineLayerOntoSelf(layer : Layer) {
        ThreadUtils.runGPUImageDestructive {
            if let overlayImage = layer.toImage() {
                if let baseImage = self.toImage() {
                    let overlayPicture = GPUImagePicture(image: overlayImage)
                    let basePicture = GPUImagePicture(image: baseImage)
                    let filter = self.filterForBlendMode(layer.blendMode)
                    filter.setOpacity(layer.opacity)
                    filter.setInputs(top: overlayPicture, base: basePicture)
                    filter.useNextFrameForImageCapture()
                    basePicture.processImage()
                    overlayPicture.processImage()
                    let combinedImage = filter.imageFromCurrentFramebuffer()

                    if combinedImage != nil
                        && combinedImage.size.width > 0
                        && combinedImage.size.height > 0 {
                        self.imageData = combinedImage.TIFFRepresentation
                        self.parent.removeLayer(layer)
                    } else {
                        log.error("Failed to get valid image from GPUImage framebuffer.")
                    }
                    return
                }
            }
            log.error("Failed to combine layer due to unexpected optional value.")
        }
    }

    private func filterForBlendMode(blend: BlendMode) -> BlendFilter {
        switch blend {
        case .Add:
            return BlendAddFilter()
        case .Tilt:
            return BlendTiltFilter()
        case .Tilted:
            return BlendReorientTextureFilter()
        case .Flatten:
            return BlendFlattenFilter()
        case .Smooth:
            return BlendSmoothFilter()
        case .Sharpen:
            return BlendSharpenFilter()
        case .Emphasize:
            return BlendEmphasizeFilter()
        case .Invert:
            return BlendInvertFilter()
        }
    }

    private func renderOutputNode() -> (GPUImageOutput, [GPUImagePicture]) {
        let layersArray = layers.array as [Layer]
        if layersArray.count == 0 {
            // is a leaf node just grab the image
            let baseImage = toImage()

            let picture = GPUImagePicture(image: baseImage)
            return (picture, [picture])
        } else {
            // Otherwise recursivly build the filter graph

            let baseImage = layersArray[0].toImage()
            let lastPicture = GPUImagePicture(image: baseImage)

            var inputPictures : [GPUImagePicture] = [lastPicture]
            var lastSource = lastPicture as GPUImageOutput

            for (index, layer) in enumerate(layersArray[1..<layersArray.count]) {
                var filter = filterForBlendMode(layer.blendMode)
                filter.setOpacity(layer.opacity)
                let (currentSource, pictures) = layer.renderOutputNode()
                inputPictures = pictures + inputPictures

                filter.setInputs(top: currentSource, base: lastSource)
                // The output of the filter is the new next source
                lastSource = filter
            }
            return (lastSource, inputPictures);
        }
    }

    public func renderLayer() -> NSImage? {
        // Never run this on the main thread as it will interfer with cocos2d
        assert(NSThread.currentThread() != NSThread.mainThread())

        let (outputSource, pictures) = renderOutputNode()
        if pictures.count == 1 {
            return layers[0].toImage()
        } else {
            outputSource.useNextFrameForImageCapture()
            for pic in pictures {
                pic.processImage()
            }

            return outputSource.imageFromCurrentFramebuffer()
        }
    }
}

