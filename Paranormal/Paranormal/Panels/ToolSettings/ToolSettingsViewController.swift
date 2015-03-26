import Foundation
import Cocoa
import AppKit

public class ToolSettingsViewController: PNViewController {

    @IBOutlet weak var childView : NSView!
    var smoothToolSettingsViewController : ActiveToolSettingsViewController? =
        ActiveToolSettingsViewController(nibName: "PlaneToolSettings",
        bundle: nil, toolType:ActiveTool.Smooth)
    var sharpenToolSettingsViewController : ActiveToolSettingsViewController? =
        ActiveToolSettingsViewController(nibName: "PlaneToolSettings",
        bundle: nil, toolType:ActiveTool.Sharpen)
    var flattenToolSettingsViewController : ActiveToolSettingsViewController? =
        ActiveToolSettingsViewController(nibName: "PlaneToolSettings",
        bundle: nil, toolType:ActiveTool.Flatten)
    var emphasizeToolSettingsViewController : ActiveToolSettingsViewController? =
        ActiveToolSettingsViewController(nibName: "PlaneToolSettings",
        bundle: nil, toolType:ActiveTool.Emphasize)
    var planeToolSettingsViewController : ActiveToolSettingsViewController? =
        ActiveToolSettingsViewController(nibName: "PlaneToolSettings",
        bundle: nil, toolType:ActiveTool.Plane)
    var tiltToolSettingsViewController : ActiveToolSettingsViewController? =
        ActiveToolSettingsViewController(nibName: "PlaneToolSettings",
        bundle: nil, toolType:ActiveTool.Tilt)
    var invertToolSettingsViewController : ActiveToolSettingsViewController? =
        ActiveToolSettingsViewController(nibName: "PlaneToolSettings",
        bundle: nil, toolType:ActiveTool.Invert)


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
        case .Invert:
            controller = invertToolSettingsViewController
        default:
            controller = nil
        }
        self.addViewController(controller)
        if let c = controller {
            if let view = controller?.view {
                ViewControllerUtils.insertSubviewIntoParent(childView, child: view)
                activeToolSettingsView = view
            }
        }
    }
}
