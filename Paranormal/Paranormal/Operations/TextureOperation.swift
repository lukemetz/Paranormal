import Foundation
import CoreGraphics
import GPUImage
import Appkit

class TextureOperation {
    // TODO: Make a controller and a UI for adding an operation,
    // make this a subclass of PNOperation.
    var document : Document

    init(document: Document) {
        self.document = document
    }

    func perform() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["png", "jpg", "jpeg"]
        panel.beginWithCompletionHandler { (status) -> Void in
            if status == NSFileHandlingPanelOKButton{
                if let url = panel.URL {
                    let image = NSImage(contentsOfURL: url)
                    if let currentLayer = self.document.currentLayer {
                        if let newLayer = self.document.rootLayer?.addLayer() {
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
}
