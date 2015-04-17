import Foundation
import Cocoa
import AppKit

public class ToolsViewController: PNViewController {

    @IBOutlet public weak var plane: NSButton!
    @IBOutlet public weak var emphasize: NSButton!
    @IBOutlet public weak var flatten: NSButton!
    @IBOutlet public weak var smooth: NSButton!
    @IBOutlet public weak var sharpen: NSButton!
    @IBOutlet public weak var tilt: NSButton!
    @IBOutlet public weak var pan: NSButton!

    // On the object to make sure the controller isn't released
    var chamferDialogController : ChamferDialogController?

    var buttons: [NSButton] { return [
        plane, emphasize, flatten, smooth, sharpen, tilt, pan] }

    private func turnoff( buttons: [NSButton]){
        for button in buttons {
            button.bordered = false
        }
    }

    private func keepSelectedState (button: NSButton){
        turnoff(buttons)
        button.bordered = true
        button.state = 1
    }

    public func selectButton( button : NSButton ){
        keepSelectedState(button)
    }

    func setActiveTool(tool: ActiveTool) {
        if let doc = document {
            doc.setActiveEditorTool(tool)
        }
    }

    var editorViewController : EditorViewController? {
        return document?.singleWindowController?.editorViewController?
    }

    @IBAction public func planePressed(sender: NSButton) {
        setActiveTool(ActiveTool.Plane)
        selectButton(sender)
    }

    @IBAction public func emphasizePressed(sender: NSButton) {
        setActiveTool(ActiveTool.Emphasize)
        selectButton(sender)
    }

    @IBAction public func flattenPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Flatten)
        selectButton(sender)
    }

    @IBAction public func smoothPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Smooth)
        selectButton(sender)
    }

    @IBAction public func sharpenPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Sharpen)
        selectButton(sender)
    }

    @IBAction public func tiltPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Tilt)
        selectButton(sender)
    }

    @IBAction public func invertPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Invert)
        selectButton(sender)
    }

    @IBAction public func zoomPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Zoom)
        selectButton(sender)
    }

    @IBAction public func panPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Pan)
        selectButton( sender )
    }

    @IBAction public func chamferPressed(sender: NSButton) {
        if let doc = document {
            let chamfer = ChamferTool(document: doc)
            if let window = doc.singleWindowController?.window {
                chamferDialogController = ChamferDialogController(
                    parentWindow: window, tool: chamfer)
                if let chamferDialog : NSWindow = chamferDialogController?.window {
                    NSApp.beginSheet(chamferDialog, modalForWindow: window,
                        modalDelegate: self, didEndSelector: nil, contextInfo: nil)
                }
            }
        }
    }

    @IBAction public func noisePressed(sender: NSButton) {
        let noise = NoiseTool()
        if let doc = document {
            noise.perform(doc)
        }
    }
}
