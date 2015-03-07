import Foundation
import GPUImage
import OpenGL

class BlendTiltFilter : BlendFilter {
    override init() {
        super.init(shaderName: "BlendReorient")
    }

    override func setInputs(top: GPUImageOutput, base: GPUImageOutput) {
        // Reverse the blendReorient filter's inputs
        base.addTarget(self, atTextureLocation: 1)
        top.addTarget(self, atTextureLocation: 0)
    }
}
