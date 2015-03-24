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
        let chamfer = ChamferTool()
        if let doc = document {
            chamfer.perform(doc)
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

    @IBAction public func zoomPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(ZoomTool())
            document?.setActiveEditorTool(ActiveTool.Zoom)
        }
        selectButton( sender )
    }

}
