import Cocoa
import AppKit

class PreviewScene: CCScene {

    override init() {
        super.init()
        userInteractionEnabled = true
        var previewLayer = PreviewLayer()
        previewLayer.createStaticExample()
        self.addChild(previewLayer)
    }

    func keyDown(event:NSEvent) {
        for child in self.children
        {
            if child is PreviewLayer // Only handling the one case for now
            {
                child.keyDown(event)
            }
        }
    }

    override func onEnter() {
        super.onEnter()
    }

    override func onExit() {
        super.onExit()
    }
}
