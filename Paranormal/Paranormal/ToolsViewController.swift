import Foundation
import Cocoa
import AppKit

class ToolsViewController: NSViewController {
    var document: Document?

    @IBAction func chamferPressed(sender: NSButton) {
        let chamfer = ChamferTool()
        if let doc = document {
            chamfer.preform(doc)
        }
    }
}
