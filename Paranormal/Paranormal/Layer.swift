import Foundation
import Cocoa

public class Layer : NSManagedObject{
    @NSManaged public var visible : Bool
    @NSManaged public var name : String
    @NSManaged public var imageData : NSData?
    @NSManaged public var layers : NSMutableOrderedSet
    @NSManaged public var parent : Layer

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
            return layer
        } else {
            return nil
        }
    }
}
