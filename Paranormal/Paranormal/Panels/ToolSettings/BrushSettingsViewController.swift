import Foundation
import Cocoa
import AppKit

public class BrushSettingsViewController: PNViewController {

    @IBOutlet weak var colorPickerView: NSView!
    var colorPickerViewController: ColorPickerViewController?

    override public func loadView() {
        super.loadView()

        colorPickerViewController = ColorPickerViewController(nibName: "ColorPicker", bundle: nil)
        subPNViewControllers.append(colorPickerViewController)
        if let view = colorPickerViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(colorPickerView, child: view)
        }
    }


    public var brushSize: Float = 4 {
        didSet(value) {
            updateBrushSize()
        }
    }

    public var brushOpacity: Float = 100 {
        didSet(value) {
            updateBrushOpacity()
        }
    }

    func updateBrushSize() {
        document?.brushSize = brushSize
    }

    func updateBrushOpacity() {
        document?.brushOpacity = brushOpacity
    }

}
