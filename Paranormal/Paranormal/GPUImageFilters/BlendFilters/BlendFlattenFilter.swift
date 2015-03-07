import Foundation
import GPUImage
import OpenGL

class BlendFlattenFilter : BlendFilter {
    override init() {
        super.init(shaderName: "BlendFlatten")
    }
}

