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

    override func onEnter() {
        super.onEnter()
    }

    override func onExit() {
        super.onExit()
    }
    
    func keyDown(event:NSEvent) {
        println(event.keyCode)
    }
}
