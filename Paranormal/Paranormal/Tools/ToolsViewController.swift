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
    @IBOutlet public weak var zoom: NSButton!

    // On the object to make sure the controller isn't released
    var chamferDialogController : ChamferDialogController?

    var buttons: [NSButton] { return [
        plane, emphasize, flatten, smooth, sharpen, tilt, pan, zoom] }

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

    // TODO: Refactor all of these to use the same function, using one argument (ActiveTool)
    @IBAction func smoothPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.activeEditorTool = SmoothTool()
            doc.setActiveEditorTool(ActiveTool.Smooth)

        }
        selectButton( sender )
    }

    @IBAction func sharpenPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.activeEditorTool = SharpenTool()
            doc.setActiveEditorTool(ActiveTool.Sharpen)
        }
        selectButton( sender )
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

    @IBAction public func flattenBrushPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(FlattenBrushTool())
            doc.setActiveEditorTool(ActiveTool.Flatten)
        }
        selectButton( sender )
    }

    @IBAction func emphasizePressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(EmphasizeTool())
            doc.setActiveEditorTool(ActiveTool.Emphasize)
        }
        selectButton( sender )
    }

    @IBAction public func angleBrushPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(AngleBrushTool())
            doc.setActiveEditorTool(ActiveTool.Plane)
        }
        selectButton( sender )
    }

    @IBAction public func tiltPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(TiltTool())
            doc.setActiveEditorTool(ActiveTool.Tilt)
        }
        selectButton( sender )
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

    @IBAction public func automaticPressed(sender: NSButton) {
        if let doc = document {
            let tool = AutomaticTool()
            tool.setup(doc)
            editorViewController?.activeEditorTool = tool
        }
        selectButton( sender )
    }
}
