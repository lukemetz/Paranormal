import Foundation
import Cocoa

class NSImageHelper {
    class func getPixelColor(image: NSImage, pos: NSPoint) -> NSColor {
        var imageRect: CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        var imageRef = image.CGImageForProposedRect(&imageRect, context: nil, hints: nil)
        let width = CGFloat(image.size.width)

        let dataProvider : CGDataProvider! =
        CGImageGetDataProvider(imageRef?.takeUnretainedValue())
        var pixelData = CGDataProviderCopyData(dataProvider)
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        // Index is calculated in storage frame. Thus the y axis needs to be flipped.
        var index: Int = ((Int(width) * Int(image.size.height - pos.y - 1)) + Int(pos.x)) * 4

        let color = NSColor(red: CGFloat(data[index]), green: CGFloat(data[index+1]),
            blue: CGFloat(data[index+2]), alpha: CGFloat(data[index+3]))
        return color
    }

    class func writeToFile(image: NSImage, path: String) {
        // Write images to files for debugging purposes

        let imageData = image.TIFFRepresentation

        let newRep = NSBitmapImageRep(data: imageData!)
        let type = NSBitmapImageFileType.NSPNGFileType
        let pngData = newRep?.representationUsingType(type, properties:[:])
        let url = NSURL(fileURLWithPath: path)
        pngData?.writeToURL(url!, atomically: true)
    }

    class func CGImageFrom(image: NSImage) -> CGImage {
        let imageData = image.TIFFRepresentation
        let tmp = unsafeBitCast(imageData!.bytes, UnsafePointer<UInt8>.self)
        let cfData = CFDataCreate(nil, tmp, imageData!.length)
        let source = CGImageSourceCreateWithData(cfData, nil)
        let drawImg = CGImageSourceCreateImageAtIndex(source, UInt(0), nil)
        return drawImg
    }
}

