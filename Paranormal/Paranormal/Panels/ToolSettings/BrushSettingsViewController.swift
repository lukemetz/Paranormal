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


    public var brushSize: CGFloat = 4 {
        didSet(value) {
            updateBrushSize()
        }
    }

    public var brushOpacity: CGFloat = 100 {
        didSet(value) {
            updateBrushOpacity()
        }
    }

    func updateBrushSize() {
        document?.currentBrushSize = brushSize
    }

    func updateBrushOpacity() {
        document?.currentBrushOpacity = brushOpacity
    }

}
