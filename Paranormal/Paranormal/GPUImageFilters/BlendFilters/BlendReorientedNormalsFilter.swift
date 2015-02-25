import Foundation
import GPUImage
import OpenGL

class BlendReorientedNormalsFilter : BlendFilter {
    init() {
        super.init(shaderName: "BlendReorientedNormals")
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

