import Foundation
import Cocoa

class ChamferDialogController : NSWindowController, NSOpenSavePanelDelegate {
    // TOOD: make a common PNOperationDialogController base class
    var parentWindow : NSWindow?
    var chamferOperation : ChamferOperation?
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

    init(parentWindow: NSWindow, chamfer: ChamferOperation) {
        super.init(window: nil)
        self.chamferOperation = chamfer
        self.parentWindow = parentWindow
        self.createChamferLayer()
    }

    override init() {
        super.init()
    }

    func createChamferLayer() {
        if let chamfer = chamferOperation {
            chamfer.create()
        }
    }

    func updatePreview() {
        if let chamfer = chamferOperation {
            chamfer.updatePreview(radius: radius, depth: depth, shape: shape)
        }
    }

    @IBAction func confirm(sender: NSButton) {
        if let chamfer = chamferOperation {
            chamfer.confirm()
        }
        closeSheet()
    }

    @IBAction func cancel(sender: NSButton) {
        if let chamfer = chamferOperation {
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
