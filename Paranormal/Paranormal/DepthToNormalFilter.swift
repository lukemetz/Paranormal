import Foundation
import GPUImage
import OpenGL

class DepthToNormalFilter : GPUImageFilter {
    override init() {
        super.init(fragmentShaderFromFile: "DepthToNormal")
    }

    override init!(fragmentShaderFromString fragmentShaderString: String!) {
        super.init(fragmentShaderFromString: fragmentShaderString)
    }

    override init!(vertexShaderFromString vertexShaderString: String!,
        fragmentShaderFromString fragmentShaderString: String!) {

        super.init(vertexShaderFromString: vertexShaderString,
            fragmentShaderFromString: fragmentShaderString)
    }

    override func setupFilterForSize(filterFrameSize: CGSize) {
        super.setupFilterForSize(filterFrameSize)

        setFloat(GLfloat(1.0/filterFrameSize.height), forUniformName: "texelHeight")
        setFloat(GLfloat(1.0/filterFrameSize.width), forUniformName: "texelWidth")
    }
}