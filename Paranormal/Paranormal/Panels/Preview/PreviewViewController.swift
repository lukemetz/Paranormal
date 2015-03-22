import Foundation
import Appkit
import GPUImage

class PreviewViewController : PNViewController, PreviewViewDelegate {
    @IBOutlet weak var glView: PreviewView!
    var currentPreviewLayer: PreviewLayer?

    var scene : PreviewScene?
    override var document : Document? {
        didSet {
            updateComputedEditorImage(nil)
            updateCoreData(nil)
        }
    }

    func renderedPreviewImage() -> NSImage? {
        return self.currentPreviewLayer?.renderedPreviewImage()
    }

    override func loadView() {
        super.loadView()

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateComputedEditorImage:",
            name: PNDocumentNormalImageChanged,
            object: nil)

        self.setupPreview()
    }

    func setupPreview() {
        // Run this in the main thread as to not have conflicts with GPUImage
        ThreadUtils.runCocos { () -> Void in
            let director = CCDirector.sharedDirector() as CCDirector!
            director.view = self.glView

            self.scene = PreviewScene() // Non fail-able

            let previewLayer = PreviewLayer(viewSize: director.viewSize())
            self.scene?.addChild(previewLayer)
            self.currentPreviewLayer = previewLayer
            director.presentScene(self.scene!)
        }
    }

    func updateComputedEditorImage(notification: NSNotification?) {
        ThreadUtils.runCocos { () -> Void in
            if let image = self.document?.computedExportImage {
                self.currentPreviewLayer?.updateNormalMap(image)
            }
        }
    }

    func updateCoreData(notification: NSNotification?) {
        ThreadUtils.runCocos { () -> Void in
            if let baseImage = self.document?.baseImage {
                self.currentPreviewLayer?.updateBaseImage(baseImage)
            }
        }
    }

    func previewViewDidLayout() {

    }
}
