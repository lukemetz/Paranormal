import Foundation
import Cocoa

class Layer : NSManagedObject{
    @NSManaged var visible : Bool
    @NSManaged var name : String
    @NSManaged var imageData : NSData?
    @NSManaged var layers : NSMutableSet
    @NSManaged var parent : Layer

    override init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext?) {

            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    // Copies content of CGContext to data attribute
    func updateFromContext(context: CGContext) {
        let cgImage = CGBitmapContextCreateImage(context)
        let width = CGImageGetWidth(cgImage)
        let height = CGImageGetHeight(cgImage)

        let size = NSSize(width: Int(width), height: Int(height))
        let nsImage = NSImage(CGImage: cgImage, size: size)
        if let data = nsImage.TIFFRepresentation {
            self.imageData = data
        } else {
            // TODO we need an logging framework
            println("[Error] could not set image data")
        }
    }

    // Clear and draw the layers data to a CGContext
    func drawToContext(context: CGContext) {
        let source = CGImageSourceCreateWithData(self.imageData, nil)
        let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)

        let width = CGImageGetWidth(cgImage)
        let height = CGImageGetHeight(cgImage)
        let rect = CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height))

        CGContextClearRect(context, rect)

        CGContextDrawImage(context, rect, cgImage)
    }
}
