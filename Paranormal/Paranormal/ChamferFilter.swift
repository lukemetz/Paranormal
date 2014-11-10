import Foundation
import GPUImage
import OpenGL

class ChamferFilter : GPUImageFilterGroup {
    override init() {
        super.init()

        let alphaMask = GPUImageFilter(fragmentShaderFromFile: "MaskAlpha")
        self.addFilter(alphaMask)

        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = 10.0;
        self.addFilter(blurFilter)

        let multiply = GPUImageMultiplyBlendFilter()
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

