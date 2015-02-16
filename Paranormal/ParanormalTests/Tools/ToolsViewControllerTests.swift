import Cocoa
import Quick
import Nimble
import Paranormal

class ToolsViewControllerTests: QuickSpec {
    override func spec() {
        describe("ToolsViewController") {
            var document : Document?
            var editorView : EditorView?
            var activeTool : EditorActiveTool?
            var windowController : WindowController?

            beforeEach {
                let documentController = DocumentController()
                document = documentController
                    .makeUntitledDocumentOfType("Paranormal", error: nil) as? Document
                documentController.addDocument(document!)
                document?.makeWindowControllers()

                windowController = document?.singleWindowController

                windowController?.editorViewController?.view
                windowController?.toolsViewController?.view
                windowController?.editorViewController?.activeEditorTool = nil
            }

            describe("brushPressed") {
                it("sets the active tool on the editorViewController to be a BrushTool") {
                    windowController?.toolsViewController?.brushPressed(NSButton())

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? BrushTool).toNot(beNil())
                }
            }

            describe("panPressed") {
                it("sets the active tool on the editorViewController to be a PanTool") {
                    windowController?.toolsViewController?.panPressed(NSButton())

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? PanTool).toNot(beNil())
                }
            }
        }
    }
}
