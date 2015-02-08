import Cocoa
import AppKit

class PreviewScene: CCScene {
    override func onEnter() {
        super.onEnter()
        userInteractionEnabled = true
    }

    override func onExit() {
        super.onExit()
    }

    func keyDown(event:NSEvent) {
        println(event.keyCode)
    }
}
