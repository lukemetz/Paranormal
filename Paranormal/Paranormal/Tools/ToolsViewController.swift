import Foundation
import Cocoa
import AppKit

public class ToolsViewController: PNViewController {

    @IBOutlet public weak var smooth: NSButton!
    @IBOutlet public weak var brush: NSButton!
    @IBOutlet public weak var pan: NSButton!
    @IBOutlet public weak var zoom: NSButton!
    @IBOutlet public weak var flatten: NSButton!

    // On the object to make sure the controller isn't released
    var chamferDialogController : ChamferDialogController?

    var buttons: [NSButton] { return [smooth, brush, pan, flatten, zoom] }

    private func turnoff( buttons: [NSButton]){
        for button in buttons {
            button.bordered = false
        }
    }

    private func keepSelectedState (button: NSButton, buttonlist: [NSButton]){
        button.bordered = true
        button.state = 1
        turnoff(buttonlist)
    }

    public func selectButton( button : NSButton ){
        var rest = buttons.filter { $0 != button }
        keepSelectedState(button, buttonlist: rest)
    }

    @IBAction func smoothPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.activeEditorTool = SmoothTool()
            document?.setActiveEditorTool(ActiveTool.Smooth)

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
            document?.setActiveEditorTool(ActiveTool.Flatten)
        }
        selectButton( sender )
    }

    @IBAction public func angleBrushPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(AngleBrushTool())
            document?.setActiveEditorTool(ActiveTool.Plane)
        }
        selectButton( sender )
    }

    @IBAction public func panPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(PanTool())
            document?.setActiveEditorTool(ActiveTool.Pan)
        }
        selectButton( sender )
    }

    @IBAction public func zoomPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(ZoomTool())
            document?.setActiveEditorTool(ActiveTool.Zoom)
        }
        selectButton( sender )
    }

}
