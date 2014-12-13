import Foundation
import Cocoa
import AppKit

class ColorPickerViewController: NSViewController {
    var document: Document?
//    var phi: CGFloat = 0.0
//    var the: CGFloat = 0.0
    var x: Float32 = 0.0
    var y: Float32 = 0.0
    var z: Float32 = 0.0
    var deg: Float32 = 0
    var pit: Float32 = 0
    
    @IBOutlet weak var DegreeText: NSTextField!

    @IBOutlet weak var PitchText: NSTextField!


    @IBAction func getDegree(sender: AnyObject) {
        deg = DegreeText.floatValue
        x = sin(deg)*cos(pit)
        y = sin(deg)*sin(pit)
        z = cos(deg)
    }

    @IBAction func getPitch(sender: AnyObject) {
        pit = PitchText.floatValue
        x = sin(deg)*cos(pit)
        y = sin(deg)*sin(pit)
        z = cos(deg)
        println(pit)
    }

    func calcColor(){
        x = sin(1)
        println(x)
    }

}

