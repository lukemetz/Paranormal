import Foundation
import Cocoa

protocol DrawingKernel {
    func startDraw(update : (image : NSImage) -> Void)
    func addPoint(point : CGPoint, brush : Brush)
    func stopDraw(finish : () -> Void)
}
