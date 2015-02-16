import Foundation
import Cocoa
import AppKit

public class ToolsViewController: PNViewController {
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
            document?.singleWindowController?.editorViewController?.activeEditorTool = BrushTool()
        }
    }

    @IBAction public func panPressed(sender: NSButton) {
        if let doc = document {
            document?.singleWindowController?.editorViewController?.activeEditorTool = PanTool()
        }
    }
}
