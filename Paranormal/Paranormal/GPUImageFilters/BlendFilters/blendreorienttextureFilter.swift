import Foundation
import GPUImage
import OpenGL

class BlendReorientTextureFilter : BlendFilter {
    override init() {
        super.init(shaderName: "BlendReorient")
    }
}
