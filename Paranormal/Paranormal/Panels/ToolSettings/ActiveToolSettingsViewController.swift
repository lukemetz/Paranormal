import Foundation
import Cocoa
import AppKit

public class ActiveToolSettingsViewController: PNViewController {

    @IBOutlet weak var colorPickerView: NSView!
    var colorPickerViewController: ColorPickerViewController?

    override public func loadView() {
        super.loadView()
        if (colorPickerView != nil) {
            colorPickerViewController =
                ColorPickerViewController(nibName: "ColorPicker", bundle: nil)
            addViewController(colorPickerViewController)
            if let view = colorPickerViewController?.view {
                ViewControllerUtils.insertSubviewIntoParent(colorPickerView, child: view)
            }
        }
    }

    public var brushSize: Float = 30.0 {
        didSet {
            document?.brushSize = brushSize
        }
    }

    public var brushOpacity: Float = 100.0 {
        didSet(value) {
            document?.brushOpacity = brushOpacity
        }
    }

    public var brushHardness: Float = 0.9 {
        didSet(value) {
            document?.brushHardness = brushHardness
        }
    }

    public var gaussianRadius: Float = 10.0 {
        didSet(value) {
            document?.gaussianRadius = gaussianRadius
        }
    }
}
