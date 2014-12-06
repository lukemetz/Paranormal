import Foundation
import CoreGraphics
import GPUImage
import Appkit

class NoiseTool {
    func perform(document: Document) {
        // This should just add a new layer!
        let panel = NSOpenPanel()
        panel.beginWithCompletionHandler { (_) -> Void in
            if let url = panel.URL {
                let image = NSImage(contentsOfURL: url)
                if let layer = document.rootLayer?.addLayer() {
                    layer.imageData = image?.TIFFRepresentation
                    layer.name = "Noise Layer"
                }
            }
        }
    }
}
