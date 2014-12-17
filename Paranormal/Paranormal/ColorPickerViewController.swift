import Foundation
import Cocoa
import AppKit
import Darwin

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
        let dir = deg * Float(M_PI) / 180.0
        let pitt = pit * Float(M_PI) / 180.0
        let x = sin(dir) * sin(pitt) * 0.5 + 0.5
        let y = cos(dir) * sin(pitt) * 0.5 + 0.5
        let z = cos(pitt)
        document?.currentColor = NSColor(red: CGFloat(x),
            green: CGFloat(y), blue: CGFloat(z), alpha: 1.0)
        println("x")
        println(x)
        println("y")
        println(y)
        println("z")
        println(z)
    }

    @IBAction func test(sender: AnyObject) {
//        println(deg)
//        println(pit)
    }

}

