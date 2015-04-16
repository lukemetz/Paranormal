import Foundation
import GPUImage
import OpenGL

class PNOperationFilter : GPUImageFilterGroup {
    var operationFilter : FilterWithSizeUniforms?

    override init() {
        super.init()
    }

    init(singleShaderName: String!) {
        super.init()
        let singleOperationFilter = FilterWithSizeUniforms(shaderName: singleShaderName)
        self.operationFilter = singleOperationFilter

        self.addFilter(singleOperationFilter)
        initialFilters = [singleOperationFilter]
        terminalFilter = singleOperationFilter
    }
}
