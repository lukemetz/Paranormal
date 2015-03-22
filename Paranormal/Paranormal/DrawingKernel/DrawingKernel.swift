import Foundation
import Cocoa

public protocol DrawingKernel {
    func startDraw(update : (image : NSImage) -> Void)
    func addPoint(point : CGPoint, brush : Brush)
    func stopDraw(finish : () -> Void)
    func doneDrawing() -> Bool
    func destroy()
}
