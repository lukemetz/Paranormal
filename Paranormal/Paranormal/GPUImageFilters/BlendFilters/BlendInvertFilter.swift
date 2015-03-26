import Foundation
import GPUImage
import OpenGL

class BlendInvertFilter : BlendFilter {
    override init() {
        super.init(shaderName: "BlendInvert")
    }
}

