import Foundation
import CoreGraphics
import GPUImage
import Appkit

class NoiseTool {
    func perform(document: Document) {
        // This should just add a new layer!
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["png", "jpg", "jpeg"]
        panel.beginWithCompletionHandler { (_) -> Void in
            if let url = panel.URL {
                let image = NSImage(contentsOfURL: url)
                if let currentLayer = document.currentLayer {
                    if let newLayer = document.rootLayer?.addLayer() {
                        newLayer.imageData = image?.TIFFRepresentation
                        newLayer.name = "Noise Layer"
                        newLayer.blendMode = BlendMode.Tilted
                        currentLayer.combineLayerOntoSelf(newLayer)
                    }
                }
            }
        }
    }
}
