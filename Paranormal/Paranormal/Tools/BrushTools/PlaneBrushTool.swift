import Foundation

import Foundation

public class PlaneBrushTool : BrushTool {

    public override init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Add
    }
}
