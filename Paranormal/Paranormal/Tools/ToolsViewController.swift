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
    @IBOutlet public weak var invert: NSButton!
    @IBOutlet public weak var pan: NSButton!
    @IBOutlet public weak var zoom: NSButton!

    // On the object to make sure the controller isn't released
    var chamferDialogController : ChamferDialogController?

    var buttons: [NSButton] { return [
        plane, emphasize, flatten, smooth, sharpen, tilt, pan, zoom, invert] }

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

    @IBAction func smoothPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Smooth)
        selectButton(sender)
    }

    @IBAction func sharpenPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Sharpen)
        selectButton(sender)
    }

    @IBAction public func flattenBrushPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Flatten)
        selectButton(sender)
    }

    @IBAction func emphasizePressed(sender: NSButton) {
        setActiveTool(ActiveTool.Emphasize)
        selectButton(sender)
    }

    @IBAction public func planeBrushPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(PlaneBrushTool())
            doc.setActiveEditorTool(ActiveTool.Plane)
        }

        selectButton( sender )
    }

    @IBAction public func tiltPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Tilt)
        selectButton(sender)
    }

    @IBAction func invertPressed(sender: NSButton) {
        setActiveTool(ActiveTool.Invert)
        selectButton(sender)
    }

    @IBAction public func panPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(PanTool())
            doc.setActiveEditorTool(ActiveTool.Pan)
        }
        selectButton( sender )
    }

    @IBAction func zoomPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(ZoomTool())
            document?.setActiveEditorTool(ActiveTool.Zoom)
        }
        selectButton( sender )
    }
}
