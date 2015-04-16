import Foundation
import Cocoa
import AppKit
import Darwin

public class ColorPickerViewController: PNViewController {
    @IBOutlet weak var degreeSlider: NSSlider!
    @IBOutlet weak var degreeTextBox: NSTextField!
    @IBOutlet weak var pitchSlider: NSSlider!
    @IBOutlet weak var pitchTextBox: NSTextField!

    @IBAction func setDegreeFromSlider(sender: NSSlider) {
        document?.toolSettings.colorAsAngles.direction = degreeSlider.floatValue
        updateColorPicker()
    }

    @IBAction func setDegreeFromTextBox(sender: NSTextField) {
        document?.toolSettings.colorAsAngles.direction = degreeTextBox.floatValue
        updateColorPicker()
    }

    @IBAction func setPitchFromSlider(sender: NSSlider) {
        document?.toolSettings.colorAsAngles.pitch = pitchSlider.floatValue
        updateColorPicker()
    }

    @IBAction func setPitchFromTextbox(sender: NSTextField) {
        document?.toolSettings.colorAsAngles.pitch = pitchTextBox.floatValue
        updateColorPicker()
    }

    public func updateColorPicker() {
        if let doc = document {
            degreeSlider.floatValue = doc.toolSettings.colorAsAngles.direction
            degreeTextBox.floatValue = doc.toolSettings.colorAsAngles.direction
            pitchSlider.floatValue = doc.toolSettings.colorAsAngles.pitch
            pitchTextBox.floatValue = doc.toolSettings.colorAsAngles.pitch
        }
    }
}
