import Foundation

public class InvertTool : BrushTool {
    public override init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Invert
    }
}
