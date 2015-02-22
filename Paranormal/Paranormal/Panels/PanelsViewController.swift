import Foundation
import Cocoa
import AppKit

public class PanelsViewController: PNViewController {

    @IBOutlet weak var previewView: NSView!
    var previewViewController: PreviewViewController?

    @IBOutlet weak var brushSettingsView: NSView!
    var brushSettingsViewController: BrushSettingsViewController?

    override public func loadView() {
        super.loadView()
        ThreadUtils.runCocos { () -> Void in
            self.previewViewController = PreviewViewController(nibName: "Preview", bundle: nil)

            self.subPNViewControllers.append(self.previewViewController)
            if let view = self.previewViewController?.view {
                ViewControllerUtils.insertSubviewIntoParent(self.previewView, child: view)
            }
        }

        brushSettingsViewController =
            BrushSettingsViewController(nibName: "BrushSettings", bundle: nil)
        subPNViewControllers.append(brushSettingsViewController)
        if let view = brushSettingsViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(brushSettingsView, child: view)
        }
    }
}
