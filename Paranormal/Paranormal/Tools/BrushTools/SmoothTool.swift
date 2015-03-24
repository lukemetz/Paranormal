import Foundation

public class SmoothTool : BrushTool {

    public override init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Smooth
    }
}
