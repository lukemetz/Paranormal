import Foundation
import CoreGraphics
import GPUImage
import Appkit

class ChamferOperation : PNOperation {
    // These need to match the .xib's defaults
    // TOOD: dry it up
    let defaultRadius : Float = 20.0
    var defaultDepth : Float = 2.0
    var defaultShape : Float = 0.0

    init(document: Document) {
        super.init(document: document, filter: ChamferOperationFilter(
            radius: defaultRadius, depth: defaultDepth, shape: defaultShape))
    }

    func updatePreview(#radius: Float, depth: Float, shape: Float) {
        self.operationFilter = ChamferOperationFilter(
            radius: radius, depth: depth, shape: shape)
    }
}
