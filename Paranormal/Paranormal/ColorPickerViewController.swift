import Foundation
import Cocoa
import AppKit
import Darwin

class ColorPickerViewController: NSViewController {
    var document: Document?
    var deg: Float32 = 0 {
        didSet(value) {
            updateColorOnDocument()
        }
    }
    var pit: Float32 = 0 {
        didSet(value) {
            updateColorOnDocument()
        }
    }

    func updateColorOnDocument() {
        let dir = deg * Float(M_PI) / 180.0
        let pitt = pit * Float(M_PI) / 180.0
        let x = sin(dir) * sin(pitt) * 0.5 + 0.5
        let y = cos(dir) * sin(pitt) * 0.5 + 0.5
        let z = cos(pitt) * 0.5 + 0.5
        document?.currentColor = NSColor(red: CGFloat(x),
            green: CGFloat(y), blue: CGFloat(z), alpha: 1.0)
    }
}
