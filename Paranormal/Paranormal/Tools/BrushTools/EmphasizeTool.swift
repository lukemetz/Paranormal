import Foundation

public class EmphasizeTool : BrushTool {

    override public init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Emphasize
    }
}
