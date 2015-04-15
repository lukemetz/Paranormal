import Foundation
import GPUImage
import OpenGL

class ChamferOperationFilter : GPUImageFilterGroup {
//    var chamferFilter : FilterWithSizeUniforms?

    init(radius: Float, depth: Float, shape: Float) {
        super.init()

        let operationFilter = FilterWithSizeUniforms(shaderName: "Chamfer")
        operationFilter.setFloat(GLfloat(radius), forUniformName: "radius")
        operationFilter.setFloat(GLfloat(depth), forUniformName: "depth")
        operationFilter.setFloat(GLfloat(shape), forUniformName: "shape")

        self.addFilter(operationFilter)
        initialFilters = [operationFilter]
        terminalFilter = operationFilter
    }
}
