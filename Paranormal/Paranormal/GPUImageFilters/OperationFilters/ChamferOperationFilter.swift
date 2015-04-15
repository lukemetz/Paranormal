import Foundation
import GPUImage
import OpenGL

class ChamferOperationFilter : PNOperationFilter {
    init(radius: Float, depth: Float, shape: Float) {
        super.init(singleShaderName: "Chamfer")
        if let chamferFilter = self.operationFilter {
            chamferFilter.setFloat(GLfloat(radius), forUniformName: "radius")
            chamferFilter.setFloat(GLfloat(depth), forUniformName: "depth")
            chamferFilter.setFloat(GLfloat(shape), forUniformName: "shape")
        }
    }
}
