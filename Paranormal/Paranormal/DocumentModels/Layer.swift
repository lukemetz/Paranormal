import Foundation
import Cocoa

public class Layer : NSManagedObject{
    @NSManaged public var visible : Bool
    @NSManaged public var name : String
    @NSManaged public var imageData : NSData?
    @NSManaged public var layers : NSMutableOrderedSet
    @NSManaged public var parent : Layer
    @NSManaged public var blendMode : Int16

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
            return layer
        } else {
            return nil
        }
    }

    public func removeLayer(layer : Layer) {
        self.layers.removeObject(layer)
        managedObjectContext?
            .deleteObject(layer)
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
            return layer
        } else {
            return nil
        }
    }

    // TODO test me with image data accessors
    public func combineLayerOntoSelf(layer : Layer) {

        if let image = layer.toImage() {
            let size = image.size
            func toContext(layer : Layer) -> CGContext {
                let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

                let context = CGBitmapContextCreate(nil, UInt(size.width),
                    UInt(size.height),  8,  0 , colorSpace, bitmapInfo)

                layer.drawToContext(context)
                return context
            }

            let context = toContext(self)

            let cgImage = image.CGImageForProposedRect(nil, context: nil, hints: nil)
            let rect = CGRectMake(0, 0, size.width, size.height)
            if let cgImageUnwrap = cgImage {
                CGContextDrawImage(context, rect, cgImageUnwrap.takeUnretainedValue())

                self.updateFromContext(context)
                return
            }
        }
        log.error("Failed to combine layer due to unexpected optional value")
    }
}

