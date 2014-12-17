import Foundation
import Cocoa
import AppKit

class PanelsViewController: NSViewController {
    var document: Document?

    @IBOutlet weak var previewView: NSView!
    var previewViewController: PreviewViewController?

    @IBOutlet weak var colorPickerView: NSView!
    var colorPickerViewController: ColorPickerViewController?

    override func loadView() {
        super.loadView()
        previewViewController = PreviewViewController(nibName: "Preview", bundle: nil)
        previewViewController?.document = document
        if let view = previewViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(previewView, child: view)
        }

        colorPickerViewController = ColorPickerViewController(nibName: "ColorPicker", bundle: nil)
        colorPickerViewController?.document = document
        if let view = colorPickerViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(colorPickerView, child: view)
        }
    }
}
