import Foundation
import Cocoa
import AppKit

class ToolsViewController: NSViewController {
    var document: Document?

    @IBAction func chamferPressed(sender: NSButton) {
        let chamfer = ChamferTool()
        if let doc = document {
            chamfer.perform(doc)
        }
    }

    @IBAction func noisePressed(sender: NSButton) {
        let noise = NoiseTool()
        if let doc = document {
            noise.perform(doc)
        }
    }
}
