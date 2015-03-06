import Foundation
import GPUImage

class ChamferFilter : GPUImageFilter {

    var depth : Float = 15.0
    var radius : Float = 20.0

    override init() {
        super.init(fragmentShaderFromFile: "Chamfer")
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
            self.setFloat(GLfloat(self.depth), forUniformName: "depth")
            self.setFloat(GLfloat(self.radius), forUniformName: "radius")
        }
    }
}
