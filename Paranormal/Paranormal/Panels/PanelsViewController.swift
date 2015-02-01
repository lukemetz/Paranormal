import Foundation
import Cocoa
import AppKit

public class PanelsViewController: PNViewController {

    @IBOutlet weak var previewView: NSView!
    var previewViewController: PreviewViewController?

    @IBOutlet weak var colorPickerView: NSView!
    var colorPickerViewController: ColorPickerViewController?

    override public func loadView() {
        super.loadView()
        previewViewController = PreviewViewController(nibName: "Preview", bundle: nil)
        subPNViewControllers.append(previewViewController)
        if let view = previewViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(previewView, child: view)
        }

        colorPickerViewController = ColorPickerViewController(nibName: "ColorPicker", bundle: nil)
        subPNViewControllers.append(colorPickerViewController)
        if let view = colorPickerViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(colorPickerView, child: view)
        }
    }
}
