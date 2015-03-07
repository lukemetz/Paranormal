import Foundation
import GPUImage
import OpenGL

class BlendAddFilter : BlendFilter {
    override init() {
        super.init(shaderName: "BlendAdd")
        setOpacity(1.0)
    }
}
