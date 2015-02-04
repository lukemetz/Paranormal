import Foundation
import GPUImage
import OpenGL

class BlendReorientedNormalsFilter :  GPUImageTwoInputFilter {
    override init() {
        super.init(fragmentShaderFromFile: "BlendReorientedNormals")
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

