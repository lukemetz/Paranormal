import Foundation
import CoreGraphics
import GPUImage
import Appkit

class ChamferTool {
    func perform(document: Document) {
        if let imageData = document.currentLayer?.imageData {
            let image = NSImage(data: imageData)
            // Apply the filter
            let chamfer = ChamferFilter()
            let resultImage = chamfer.imageByFilteringImage(image)
            document.currentLayer?.imageData = resultImage.TIFFRepresentation
        }
    }
}
