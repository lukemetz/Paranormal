import Foundation
import Cocoa
import AppKit

class ColorPickerViewController: NSViewController {
    var document: Document?
    var deg: Float32 = 0 {
        willSet(value) {
            updateColoronDocument()
        }
    }
    var pit: Float32 = 0 {
        willSet(value) {
            updateColoronDocument()
        }
    }

    func updateColoronDocument() {
        let x = sin(deg)*cos(pit)
        let y = sin(deg)*sin(pit)
        let z = cos(deg)
        document?.currentColor = NSColor(red: CGFloat(x),
            green: CGFloat(y), blue: CGFloat(z), alpha: 1.0)
//        TODO: figure out whats going on when changing deg and pit value
//        println("-")
//        println(deg)
//        println(pit)
//
//        println("Print doc color")
//        println(document?.currentColor)
    }

    @IBAction func test(sender: AnyObject) {
        println(deg)
        println(pit)
    }

}

