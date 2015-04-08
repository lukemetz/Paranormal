import Foundation
import Cocoa
import AppKit

public class PanelsViewController: PNViewController {

    @IBOutlet weak var previewView: NSView!

    @IBOutlet weak var toolSettingsView: NSView!
    public var previewViewController: PreviewViewController?
    public var toolSettingsViewController : ToolSettingsViewController?
    var activeToolSettingsView: NSView?

    override public func loadView() {
        super.loadView()
        ThreadUtils.runCocos { () -> Void in
            self.previewViewController = PreviewViewController(nibName: "Preview", bundle: nil)

            self.addViewController(self.previewViewController)
            if let view = self.previewViewController?.view {
                ViewControllerUtils.insertSubviewIntoParent(self.previewView, child: view)
            }
        }
        displayActiveToolSettings(ActiveTool.Plane)
    }

    public func displayActiveToolSettings(tool : ActiveTool) -> ToolSettingsViewController? {
        activeToolSettingsView?.removeFromSuperview()
        toolSettingsViewController =
            ToolSettingsViewController(nibName: "ToolSettings", bundle: nil, toolType:tool)
        addViewController(toolSettingsViewController)
        if let view = toolSettingsViewController?.view {
            ViewControllerUtils.insertSubviewIntoParent(toolSettingsView, child: view)
            activeToolSettingsView = view
        }
        return toolSettingsViewController
    }
}
