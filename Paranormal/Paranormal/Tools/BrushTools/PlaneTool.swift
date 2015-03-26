import Foundation

import Foundation

public class PlaneTool : BrushTool {

    public override init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Add
    }
}
