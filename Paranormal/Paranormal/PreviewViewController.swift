import Foundation
import Appkit
import GPUImage

class PreviewViewController : NSViewController, PreviewViewDelegate {
    @IBOutlet weak var glView: PreviewView!

    var scene : PreviewScene?
    var document : Document?
    var currentPreviewLayer: PreviewLayer?

    override func loadView() {
        super.loadView()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCoreData:",
            name: NSManagedObjectContextObjectsDidChangeNotification, object: nil)
    }

    func updateCoreData(notification: NSNotification) {
        // TODO only update when specific objects need to be updated
        if let image = document?.computedExportImage {
            currentPreviewLayer?.updateNormalMap(image)
        }
        if let baseImage = document?.baseImage {
            currentPreviewLayer?.updateBaseImage(baseImage)
        }
    }

    func previewViewDidLayout() {
        // Run this in the main thread as to not have conflicts with GPUImage
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            if self.scene == nil {
                let director = CCDirector.sharedDirector() as CCDirector!
                director.view = self.glView as CCGLView

                // Set up share group to allow for gpu memory sharing
                // Needed if sharing resources between GL contexts.
                let shareGroup = CGLGetShareGroup(director.view.openGLContext.CGLContextObj)
                let gpuImageContext = GPUImageContext.sharedImageProcessingContext()
                gpuImageContext.useSharegroup(UnsafeMutablePointer(shareGroup))

                self.scene = PreviewScene() // Non fail-able

                let previewLayer = PreviewLayer()
                self.scene?.addChild(previewLayer)
                self.currentPreviewLayer = previewLayer
                director.runWithScene(self.scene!)

                // Hack to get cocos2d view to appear correctly.
                director.view.reshape()
            }
        }
    }
}

