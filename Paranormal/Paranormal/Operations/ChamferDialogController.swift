import Foundation
import Cocoa

class ChamferDialogController : NSWindowController, NSOpenSavePanelDelegate {
    var parentWindow : NSWindow?
    var chamferTool : ChamferTool?
    var radius : Float = 20.0
    var depth : Float = 2.0
    var shape : Float = 0.0

    @IBAction func radiusSet(sender: NSSlider) {
        self.radius = sender.floatValue
        self.updatePreview()
    }

    @IBAction func depthSet(sender: NSSlider) {
        self.depth = sender.floatValue
        self.updatePreview()
    }

    @IBAction func shapeSet(sender: NSSlider) {
        self.shape = sender.floatValue
        self.updatePreview()
    }

    override var windowNibName : String! {
        return "ChamferDialog"
    }

    init(parentWindow: NSWindow, tool: ChamferTool) {
        super.init(window: nil)
        self.chamferTool = tool
        self.parentWindow = parentWindow
        self.updatePreview()
    }

    override init() {
        super.init()
    }

    func updatePreview() {
        if let chamfer = chamferTool {
            chamfer.previewChamfer(radius: radius, depth: depth, shape: shape)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(
            NSManagedObjectContextObjectsDidChangeNotification,
            object: nil)
    }

    @IBAction func confirm(sender: NSButton) {
        if let chamfer = chamferTool {
            chamfer.finalizePreview()
        }
        closeSheet()
    }

    @IBAction func cancel(sender: NSButton) {
        if let chamfer = chamferTool {
            chamfer.cancel()
        }
        closeSheet()
    }

    func closeSheet() {
        if let unwrapParentWindow = parentWindow {
            NSApp.endSheet(window!)
            window?.orderOut(unwrapParentWindow)
        }
    }

    override init(window: NSWindow?) {
        super.init(window:window)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
