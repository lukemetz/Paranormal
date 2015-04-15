import Foundation
import GPUImage

class FilterWithSizeUniforms : GPUImageFilter {
    init(shaderName: String!) {
        super.init(fragmentShaderFromString: shaderName);
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
        runSynchronouslyOnVideoProcessingQueue {
            GPUImageContext.setActiveShaderProgram(self.valueForKey("filterProgram") as GLProgram!)
            self.setFloat(GLfloat(1.0/filterFrameSize.height), forUniformName: "texelHeight")
            self.setFloat(GLfloat(1.0/filterFrameSize.width), forUniformName: "texelWidth")
        }
    }
}
