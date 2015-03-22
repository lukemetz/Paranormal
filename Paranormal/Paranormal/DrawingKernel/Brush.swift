import Foundation
import Cocoa

public class Brush {
    var size : CGFloat
    var color : NSColor
    var hardness : CGFloat

    init(size: CGFloat, color: NSColor) {
        self.size = size
        self.color = color
        self.hardness = 0.9;
    }
}
