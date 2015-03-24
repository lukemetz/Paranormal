import Foundation
import GPUImage
import OpenGL

class BlendSmoothFilter : BlendFilter {
    var blurRadius : CGFloat = 10
    var replaceAlphaFilter : GPUImageFilter!
    var blurFilter : GPUImageGaussianBlurFilter!
    var blendAddFilter : BlendAddFilter!

    override init() {
        super.init()

        replaceAlphaFilter = GPUImageTwoInputFilter(fragmentShaderFromFile: "ReplaceAlpha")
        self.addFilter(replaceAlphaFilter)

        self.blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = blurRadius;
        self.addFilter(blurFilter)

        self.blendAddFilter = BlendAddFilter()
        self.addFilter(blendAddFilter)

        blurFilter.addTarget(replaceAlphaFilter, atTextureLocation: 0)
        replaceAlphaFilter.addTarget(blendAddFilter, atTextureLocation: 1)

        initialFilters = [replaceAlphaFilter, blurFilter]
        terminalFilter = blendAddFilter
    }

    override func setInputs(#top: GPUImageOutput, base: GPUImageOutput) {

        base.addTarget(self.blurFilter)
        base.addTarget(self.blendAddFilter, atTextureLocation: 0)
        top.addTarget(self.replaceAlphaFilter, atTextureLocation: 1)
    }
}

