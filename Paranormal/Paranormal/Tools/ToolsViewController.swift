import Foundation
import Cocoa
import AppKit

public class ToolsViewController: PNViewController {
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

    @IBAction public func brushPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.activeEditorTool = FlattenBrushTool()
        }
    }

    @IBAction public func panPressed(sender: NSButton) {
        if let doc = document {
            editorViewController?.activeEditorTool = PanTool()
        }
    }
}
