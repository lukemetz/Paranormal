import Foundation
import Cocoa
import AppKit

public class ActiveToolSettingsViewController: PNViewController {


    @IBOutlet weak var colorPickerView: NSView!
    var colorPickerViewController: ColorPickerViewController?
    public var toolSettingsTitle: String = ""
    var toolType: ActiveTool = ActiveTool.Tilt

    init?(nibName: NSString, bundle: NSBundle?, toolType : ActiveTool) {
        super.init(nibName: nibName, bundle: bundle)

        self.toolType = toolType
        switch toolType {
        case .Smooth:
            toolSettingsTitle = "Smooth Tool Settings"
        case .Sharpen:
            toolSettingsTitle = "Sharpen Tool Settings"
        case .Flatten:
            toolSettingsTitle = "Flatten Tool Settings"
        case .Emphasize:
            toolSettingsTitle = "Emphasize Tool Settings"
        case .Plane:
            toolSettingsTitle = "Plane Tool Settings"
        case .Tilt:
            toolSettingsTitle = "Tilt Tool Settings"
        case .Invert:
            toolSettingsTitle = "Invert Tool Settings"
        default:
            toolSettingsTitle = ""
        }



    }



    override public func loadView() {
        super.loadView()

        if (toolType == ActiveTool.Plane || toolType == ActiveTool.Tilt) {
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
