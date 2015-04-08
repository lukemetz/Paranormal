import Foundation
import Cocoa
import AppKit

public class ToolSettingsViewController: PNViewController {

    @IBOutlet weak var sizeSlider: NSSlider!
    @IBOutlet weak var strengthSlider: NSSlider!
    @IBOutlet weak var hardnessSlider: NSSlider!

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

    override public func viewDidLoad() {
        super.viewDidLoad()
        updateSettingsSliders()
    }

    @IBAction func updateSize(sender: NSSlider) {
        document?.toolSettings.size = sizeSlider.floatValue
    }

    @IBAction func updateStrength(sender: NSSlider) {
        document?.toolSettings.strength = strengthSlider.floatValue
    }

    @IBAction func updateHardness(sender: NSSlider) {
        document?.toolSettings.hardness = hardnessSlider.floatValue
    }

    public func updateSettingsSliders() {
        if let doc = document {
            sizeSlider.floatValue = doc.toolSettings.size
            strengthSlider.floatValue = doc.toolSettings.strength
            hardnessSlider.floatValue = doc.toolSettings.hardness
        }

        if let cpController = colorPickerViewController? {
            cpController.updateColorPicker()
        }
    }
}
