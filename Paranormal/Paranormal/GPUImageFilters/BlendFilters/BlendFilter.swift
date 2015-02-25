import Foundation
import GPUImage
import OpenGL

class BlendFilter :  GPUImageTwoInputFilter {
    init(shaderName: String) {
        super.init(fragmentShaderFromFile: shaderName)
    }

    func setOpacity(opacity : Float) {
        setFloat(GLfloat(opacity), forUniformName: "opacity")
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

