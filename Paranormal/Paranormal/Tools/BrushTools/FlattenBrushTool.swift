import Foundation

import Foundation

public class FlattenBrushTool : BrushTool {

    override public init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Flatten
    }
}
