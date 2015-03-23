import Foundation
import Cocoa
import AppKit

public class ToolsViewController: PNViewController {

    @IBOutlet weak var smooth: NSButton!
    @IBOutlet weak var brush: NSButton!
    @IBOutlet weak var pan: NSButton!
    @IBOutlet weak var zoom: NSButton!
    @IBOutlet weak var flatten: NSButton!

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
        }
        selectButton( sender )
    }

    @IBAction public func angleBrushPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(AngleBrushTool())
        }
        selectButton( sender )
    }

    @IBAction public func panPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(PanTool())
        }
        selectButton( sender )
    }

    @IBAction public func zoomPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.changeActiveTool(ZoomTool())
        }
        selectButton( sender )
    }

}
