import Foundation
import Cocoa
import AppKit

public class PanelsViewController: PNViewController {

    @IBOutlet weak var previewView: NSView!
    var previewViewController: PreviewViewController?

    @IBOutlet weak var toolSettingsView: NSView!
    public var toolSettingsViewController: ToolSettingsViewController?

    override public func loadView() {
        super.loadView()
        ThreadUtils.runCocos { () -> Void in
            self.previewViewController = PreviewViewController(nibName: "Preview", bundle: nil)

            self.addViewController(self.previewViewController)
            if let view = self.previewViewController?.view {
                ViewControllerUtils.insertSubviewIntoParent(self.previewView, child: view)
            }
        }

        toolSettingsViewController =
            ToolSettingsViewController(nibName: "ToolSettings", bundle: nil)
        addViewController(toolSettingsViewController)
        if let view = toolSettingsViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(toolSettingsView, child: view)
        }
    }
}
