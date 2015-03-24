import Foundation
import GPUImage
import OpenGL

class BlendEmphasizeFilter : BlendFilter {
    override init() {
        super.init(shaderName: "BlendEmphasize")
    }
}
