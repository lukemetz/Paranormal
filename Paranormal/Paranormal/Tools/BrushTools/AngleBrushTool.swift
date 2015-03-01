import Foundation

import Foundation

public class AngleBrushTool : BrushTool {

    public override init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Add
    }
}
