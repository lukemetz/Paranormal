import Foundation
import Appkit

class PreviewViewController : NSViewController {
    @IBOutlet weak var glView: PreviewView!

    override func viewDidLayout() {
        // FIXME
        // The following is needed. OpenGL context is not loaded otherwise.
        let _ = glView.openGLContext
        let director = CCDirector.sharedDirector() as CCDirector!

        director.setView(glView as CCGLView)
        let scene = PreviewScene()
        director.runWithScene(scene)
    }
}