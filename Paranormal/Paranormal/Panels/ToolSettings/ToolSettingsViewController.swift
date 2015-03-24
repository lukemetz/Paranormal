import Foundation
import Cocoa
import AppKit

public class ToolSettingsViewController: PNViewController {

    @IBOutlet weak var childView : NSView!
    var smoothToolSettingsViewController : ActiveToolSettingsViewController? =
    ActiveToolSettingsViewController(nibName: "SmoothToolSettings", bundle: nil)
    var planeToolSettingsViewController : ActiveToolSettingsViewController? =
    ActiveToolSettingsViewController(nibName: "PlaneToolSettings", bundle: nil)


    var activeToolSettingsView: NSView?

    override public func loadView() {
        super.loadView()
        displayActiveEditorToolSettings(ActiveTool.Plane)
    }

    public func displayActiveEditorToolSettings(tool : ActiveTool) {
        var controller : ActiveToolSettingsViewController?

        activeToolSettingsView?.removeFromSuperview()

        switch tool {
        case .Plane:
            controller = planeToolSettingsViewController
        case .Smooth:
            controller = smoothToolSettingsViewController
        default:
            controller = planeToolSettingsViewController
        }
        self.addViewController(controller)
        if let view = controller?.view {
            ViewControllerUtils.insertSubviewIntoParent(childView, child: view)
            activeToolSettingsView = view
        }
    }
}
