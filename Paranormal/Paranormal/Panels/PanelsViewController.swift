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
        ThreadUtils.runCocos { () -> Void in
            self.previewViewController = PreviewViewController(nibName: "Preview", bundle: nil)

            self.subPNViewControllers.append(self.previewViewController)
            if let view = self.previewViewController?.view {
                ViewControllerUtils.insertSubviewIntoParent(self.previewView, child: view)
            }
        }

        colorPickerViewController = ColorPickerViewController(nibName: "ColorPicker", bundle: nil)
        subPNViewControllers.append(colorPickerViewController)
        if let view = colorPickerViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(colorPickerView, child: view)
        }
    }
}
