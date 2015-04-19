import Foundation
import Appkit
import GPUImage

public class PreviewViewController : PNViewController, PreviewViewDelegate {
    @IBOutlet weak var glView: PreviewView!
    var currentPreviewLayer: PreviewLayer?

    var scene : PreviewScene?
    override public var document : Document? {
        willSet(oldDocument) {
            if document != oldDocument {
                updateComputedEditorImage(nil)
                updatePreviewData()
            }
        }
    }

    func renderedPreviewImage() -> NSImage? {
        return self.currentPreviewLayer?.renderedPreviewImage()
    }

    func updatePreviewSprite() {
        updateBaseImage(keepNormalMap: false)
    }

    func updatePreviewSpriteImage() {
        updateBaseImage(keepNormalMap: true)
    }

    func updateBaseImage(#keepNormalMap: Bool) {
        ThreadUtils.runCocos { () -> Void in
            if let mode = self.document?.editorViewMode {
                switch mode {
                case .Normal, .Preview:
                    if let baseImage = self.document?.baseImage {
                        self.currentPreviewLayer?.updateBaseImage(baseImage,
                            keepNormalMap: keepNormalMap)
                    }
                case .Lighting:
                    if let grayImage = self.document?.grayImage {
                        self.currentPreviewLayer?.updateBaseImage(grayImage,
                            keepNormalMap: keepNormalMap)
                    }
                }
            }
        }
    }

    override public func loadView() {
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

    func updatePreviewData() {
        ThreadUtils.runGPUImage { () -> Void in
            if let diffuseImage = self.document?.baseImage {
                self.document?.grayImage = PreviewSpriteUtils.grayImageWithAlphaSource(
                    diffuseImage, brightness: 0.7)
            }
            self.updatePreviewSprite()
        }
    }

    func previewViewDidLayout() {

    }
}
