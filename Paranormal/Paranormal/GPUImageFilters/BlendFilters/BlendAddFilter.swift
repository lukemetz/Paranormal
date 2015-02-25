import Foundation
import GPUImage
import OpenGL

class BlendAddFilter : BlendFilter {
    init() {
        super.init(shaderName: "BlendAdd")
        setOpacity(1.0)
    }

    override init!(fragmentShaderFromString fragmentShaderString: String!) {
        super.init(fragmentShaderFromString: fragmentShaderString)
    }

    override init!(vertexShaderFromString vertexShaderString: String!,
        fragmentShaderFromString fragmentShaderString: String!) {
            super.init(vertexShaderFromString: vertexShaderString,
                fragmentShaderFromString: fragmentShaderString)
    }
}
