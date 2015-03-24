import Foundation
import GPUImage
import OpenGL

class GaussianChamferFilter : GPUImageFilterGroup {
    override init() {
        super.init()

        let alphaMask = GPUImageFilter(fragmentShaderFromFile: "AlphaToBlack")
        self.addFilter(alphaMask)

        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = 10.0;
        self.addFilter(blurFilter)

        let multiply = GPUImageTwoInputFilter(fragmentShaderFromFile: "MultiplyMaxAlpha")
        self.addFilter(multiply)

        let depthToNormal = DepthToNormalFilter()
        self.addFilter(depthToNormal)

        alphaMask.addTarget(blurFilter)
        blurFilter.addTarget(multiply)
        alphaMask.addTarget(multiply)

        multiply.addTarget(depthToNormal)
        initialFilters = [alphaMask]
        terminalFilter = depthToNormal
    }
}

