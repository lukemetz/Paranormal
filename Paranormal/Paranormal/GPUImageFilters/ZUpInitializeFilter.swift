import Foundation
import GPUImage
import OpenGL

class ZUpInitializeFilter : GPUImageFilter {
    override init() {
        super.init(fragmentShaderFromFile: "ZUpInitialize")
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
