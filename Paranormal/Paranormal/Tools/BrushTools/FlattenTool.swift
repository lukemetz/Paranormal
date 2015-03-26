import Foundation

public class FlattenTool : BrushTool {

    override public init() {
        super.init()
    }

    override func initializeEditLayer() {
        editLayer?.blendMode = .Flatten
    }
}
