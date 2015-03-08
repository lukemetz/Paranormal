import Foundation
import GPUImage
import OpenGL

class BlendFilter : GPUImageFilterGroup {

    var filterWithOpacity : GPUImageFilter?

    override init() {
        super.init()
    }

    init(shaderName: String) {
        super.init()
        let singleShader = GPUImageTwoInputFilter(fragmentShaderFromFile: shaderName)
        self.addFilter(singleShader)
        self.filterWithOpacity = singleShader
        initialFilters = [singleShader]
        terminalFilter = singleShader
    }

    func setOpacity(opacity: Float) {
        if let filter = self.filterWithOpacity {
            filter.setFloat(GLfloat(opacity), forUniformName: "opacity")
        }
    }

    func setInputs(#top: GPUImageOutput, base: GPUImageOutput) {
        base.addTarget(self, atTextureLocation: 0)
        top.addTarget(self, atTextureLocation: 1)
    }
}
