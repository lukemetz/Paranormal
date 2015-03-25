import Foundation
import Cocoa

public class Brush {
    var size : CGFloat
    var color : NSColor
    var hardness : CGFloat

    init(size: CGFloat, color: NSColor, hardness: CGFloat) {
        self.size = size
        self.color = color
        self.hardness = hardness;
    }
}
