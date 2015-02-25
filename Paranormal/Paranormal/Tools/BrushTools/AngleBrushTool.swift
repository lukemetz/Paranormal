import Foundation

import Foundation

public class AngleBrushTool : BrushTool {

    override init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Add
    }
}
