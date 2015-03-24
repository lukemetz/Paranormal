import Foundation
import GPUImage

class ChamferFilter : GPUImageFilter {

    var depth : Float = 2.0
    var radius : Float = 20.0
    var shape : Float = 0.0

    override init() {
        super.init(fragmentShaderFromFile: "Chamfer")
    }

    convenience init(radius: Float, depth: Float, shape: Float) {
        self.init()
        self.depth = depth
        self.radius = radius
        self.shape = shape
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
            self.setFloat(GLfloat(self.shape), forUniformName: "shape")
        }
    }
}
