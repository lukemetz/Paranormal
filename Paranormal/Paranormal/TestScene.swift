import Foundation
import CoreGraphics

class TestScene : CCScene {

    override init()
    {
        super.init()

        // Enable touch handling on scene node
        userInteractionEnabled = true

        var background:CCNodeColor = CCNodeColor(color:
          CCColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0))
        addChild(background)
    }

    deinit
    {
        // clean up code goes here
    }

    override func onEnter()
    {
        // always call super onEnter first
        super.onEnter()

        // In pre-v3, touch enable and scheduleUpdate was called here
        // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
        // Per frame update is automatically enabled, if update is overridden
    }

    override func onExit()
    {
        // always call super onExit last
        super.onExit()
    }
}
