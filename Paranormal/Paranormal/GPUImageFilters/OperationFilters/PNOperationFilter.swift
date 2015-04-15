import Foundation
import GPUImage
import OpenGL

class PNOperationFilter : GPUImageFilterGroup {
    var operationFilter : FilterWithSizeUniforms

    init(singleShaderName: String!) {
        operationFilter = FilterWithSizeUniforms(shaderName: singleShaderName)
        super.init()

        self.addFilter(operationFilter)
        initialFilters = [operationFilter]
        terminalFilter = operationFilter
    }

    init 
}
