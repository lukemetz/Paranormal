import Foundation
import GPUImage
import OpenGL

class BlendSharpenFilter : BlendFilter {
    var sharpness : CGFloat = 2.0
    var replaceAlphaFilter : GPUImageFilter!
    var sharpFilter : GPUImageSharpenFilter!
    var blendAddFilter : BlendAddFilter!

    override init() {
        super.init()

        replaceAlphaFilter = GPUImageTwoInputFilter(fragmentShaderFromFile: "ReplaceAlpha")
        self.addFilter(replaceAlphaFilter)

        self.sharpFilter = GPUImageSharpenFilter()
        sharpFilter.sharpness = sharpness;
        self.addFilter(sharpFilter)

        self.blendAddFilter = BlendAddFilter()
        self.addFilter(blendAddFilter)

        sharpFilter.addTarget(replaceAlphaFilter, atTextureLocation: 0)
        replaceAlphaFilter.addTarget(blendAddFilter, atTextureLocation: 1)

        initialFilters = [replaceAlphaFilter, sharpFilter]
        terminalFilter = blendAddFilter
    }

    override func setInputs(#top: GPUImageOutput, base: GPUImageOutput) {

        base.addTarget(self.sharpFilter)
        base.addTarget(self.blendAddFilter, atTextureLocation: 0)
        top.addTarget(self.replaceAlphaFilter, atTextureLocation: 1)
    }
}
