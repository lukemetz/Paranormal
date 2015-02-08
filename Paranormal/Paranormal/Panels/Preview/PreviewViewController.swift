import Foundation
import Appkit
import GPUImage

class PreviewViewController : PNViewController, PreviewViewDelegate {
    @IBOutlet weak var glView: PreviewView!

    var scene : PreviewScene?
    override var document : Document? {
        didSet {
            updateComputedEditorImage(nil)
            updateCoreData(nil)
        }
    }
    var currentPreviewLayer: PreviewLayer?

    override func loadView() {
        super.loadView()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCoreData:",
            name: NSManagedObjectContextObjectsDidChangeNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateComputedEditorImage:",
            name: PNDocumentComputedEditorChanged,
            object: nil)
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
        // Run this in the main thread as to not have conflicts with GPUImage
        ThreadUtils.runCocos { () -> Void in
            if self.scene == nil {
                let director = CCDirector.sharedDirector() as CCDirector!
                director.view = self.glView

                // Set up share group to allow for gpu memory sharing
                // Needed if sharing resources between GL contexts.
                let shareGroup = CGLGetShareGroup(director.view.openGLContext.CGLContextObj)
                let gpuImageContext = GPUImageContext.sharedImageProcessingContext()
                gpuImageContext.useSharegroup(UnsafeMutablePointer(shareGroup))

                self.scene = PreviewScene() // Non fail-able

                let previewLayer = PreviewLayer(viewSize: director.viewSize())
                self.scene?.addChild(previewLayer)
                self.currentPreviewLayer = previewLayer
                director.runWithScene(self.scene!)

                // Hack to get cocos2d view to appear correctly.
                director.view.reshape()
            }
        }
    }
}
