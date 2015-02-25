import Foundation

import Foundation

public class FlattenBrushTool : BrushTool {

    override init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Flatten
    }
}
