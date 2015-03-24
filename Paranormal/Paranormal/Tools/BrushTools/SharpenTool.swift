import Foundation

public class SharpenTool : BrushTool {

    public override init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Sharpen
    }
}
