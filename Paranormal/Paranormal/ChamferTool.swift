import Foundation
import CoreGraphics
import GPUImage
import Appkit

class ChamferTool {
    func preform(document: Document) {
        // TODO Update to the new document model.
        if let context = document.editorContext {
            // Convert what is on the context to an NSImage
            let cgImage = CGBitmapContextCreateImage(context)
            let chamfer = ChamferFilter()
            let width = CGBitmapContextGetWidth(context)
            let height = CGBitmapContextGetHeight(context)
            let size = NSSize(width: CGFloat(width), height: CGFloat(height))
            let nsImage = NSImage(CGImage: cgImage, size:size)

            // Apply the filter
            let resultImage = chamfer.imageByFilteringImage(nsImage)

            // Set back the editor
            let source = CGImageSourceCreateWithData(resultImage.TIFFRepresentation, nil)
            let backCgImage =  CGImageSourceCreateImageAtIndex(source, 0, nil)
            let rect = CGRectMake(0, 0, size.width, size.height)
            CGContextDrawImage(context, rect, backCgImage)
            // TODO trigger update from editor context
        }
    }
}
