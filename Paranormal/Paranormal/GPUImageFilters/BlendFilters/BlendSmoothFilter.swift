import Foundation
import GPUImage
import OpenGL

class BlendSmoothFilter : BlendFilter {
    var blurRadius : CGFloat = 10
    var replaceAlphaFilter : GPUImageFilter!
    var blurFilter : GPUImageGaussianBlurFilter!
    var normalizeFilter : GPUImageFilter!
    var blendAddFilter : BlendAddFilter!

    override init() {
        super.init()

        replaceAlphaFilter = GPUImageTwoInputFilter(fragmentShaderFromFile: "ReplaceAlpha")
        self.addFilter(replaceAlphaFilter)

        self.blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = blurRadius;
        self.addFilter(blurFilter)

        let normalizeFilter = GPUImageFilter(fragmentShaderFromFile: "Normalize")
        self.addFilter(normalizeFilter)

        self.blendAddFilter = BlendAddFilter()
        self.addFilter(blendAddFilter)

        blurFilter.addTarget(replaceAlphaFilter, atTextureLocation: 0)
        replaceAlphaFilter.addTarget(normalizeFilter, atTextureLocation: 1)
        normalizeFilter.addTarget(blendAddFilter, atTextureLocation: 1)

        initialFilters = [replaceAlphaFilter, blurFilter]
        terminalFilter = blendAddFilter
    }

    override func setInputs(#top: GPUImageOutput, base: GPUImageOutput) {
        base.addTarget(self.blurFilter)
        base.addTarget(self.blendAddFilter, atTextureLocation: 0)
        top.addTarget(self.replaceAlphaFilter)
    }

    override func setOpacity(opacity: Float) {
        if let filter = self.blendAddFilter.filterWithOpacity {
            filter.setFloat(GLfloat(opacity), forUniformName: "opacity")
        }
    }
}

