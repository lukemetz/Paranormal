import Foundation
import Cocoa
import AppKit

public class ToolSettingsViewController: PNViewController {

    @IBOutlet weak var childView : NSView!
    var smoothToolSettingsViewController : ActiveToolSettingsViewController? =
    ActiveToolSettingsViewController(nibName: "SmoothToolSettings", bundle: nil)
    var sharpenToolSettingsViewController : ActiveToolSettingsViewController? =
    ActiveToolSettingsViewController(nibName: "SharpenToolSettings", bundle: nil)
    var flattenToolSettingsViewController : ActiveToolSettingsViewController? =
    ActiveToolSettingsViewController(nibName: "FlattenToolSettings", bundle: nil)
    var emphasizeToolSettingsViewController : ActiveToolSettingsViewController? =
    ActiveToolSettingsViewController(nibName: "EmphasizeToolSettings", bundle: nil)
    var planeToolSettingsViewController : ActiveToolSettingsViewController? =
    ActiveToolSettingsViewController(nibName: "PlaneToolSettings", bundle: nil)
    var tiltToolSettingsViewController : ActiveToolSettingsViewController? =
    ActiveToolSettingsViewController(nibName: "TiltToolSettings", bundle: nil)



    var activeToolSettingsView: NSView?

    override public func loadView() {
        super.loadView()
        displayActiveEditorToolSettings(ActiveTool.Plane)
    }

    public func displayActiveEditorToolSettings(tool : ActiveTool) {
        var controller : ActiveToolSettingsViewController?

        activeToolSettingsView?.removeFromSuperview()

        switch tool {
        case .Smooth:
            controller = smoothToolSettingsViewController
        case .Sharpen:
            controller = sharpenToolSettingsViewController
        case .Flatten:
            controller = flattenToolSettingsViewController
        case .Emphasize:
            controller = emphasizeToolSettingsViewController
        case .Plane:
            controller = planeToolSettingsViewController
        case .Tilt:
            controller = tiltToolSettingsViewController
        default:
            controller = tiltToolSettingsViewController
        }
        self.addViewController(controller)
        if let view = controller?.view {
            ViewControllerUtils.insertSubviewIntoParent(childView, child: view)
            activeToolSettingsView = view
        }
    }
}
