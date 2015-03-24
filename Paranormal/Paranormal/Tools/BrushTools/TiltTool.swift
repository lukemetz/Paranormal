import Foundation

public class TiltTool: BrushTool {

    public override init() {
        super.init()
    }

    override func initializeEditLayer() {
        // In the current implementation, Tilt and Tilted are identical
        // TODO: Get the drawing kernel to handle alphas right with .Tilt
        editLayer?.blendMode = .Tilted
    }
}
