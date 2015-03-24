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
            var plane : NSButton?
            var smooth : NSButton?
            var pan : NSButton?
            var zoom : NSButton?
            var flatten : NSButton?

            var buttons : [NSButton?]!

            var expectOnlyButtonSelected : (NSButton?) -> Void = {(button) in
                for x in buttons {
                    if (x == button) {
                        expect(x?.state).to(equal(1))
                    }else{
                        expect(x?.state).to(equal(0))
                    }
                }
            }

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

                smooth = windowController?.toolsViewController?.smooth
                plane = windowController?.toolsViewController?.brush
                pan = windowController?.toolsViewController?.pan
                zoom = windowController?.toolsViewController?.zoom
                flatten = windowController?.toolsViewController?.flatten

                buttons = [smooth, plane, pan, flatten, zoom]
            }

            describe("planeBrushPressed") {
                it("sets the active tool on the editorViewController to be an AngleBrushTool") {
                    windowController?.toolsViewController?.angleBrushPressed(plane!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? AngleBrushTool).toNot(beNil())
                }
                it("tests to see if plane is only button pressed") {
                    windowController?.toolsViewController?.angleBrushPressed(plane!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(plane)
                }
            }

            describe("flattenBrushPressed") {
                it("sets the active tool on the editorViewController to be a FlattenBrushTool") {
                    windowController?.toolsViewController?.flattenBrushPressed(flatten!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? FlattenBrushTool).toNot(beNil())
                }
                it("tests to see if flatten is only button pressed") {
                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(flatten)
                }
            }

            describe("panPressed") {
                it("sets the active tool on the editorViewController to be a PanTool") {
                    windowController?.toolsViewController?.panPressed(pan!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? PanTool).toNot(beNil())
                }
                it("tests to see if pan is only button pressed") {
                    windowController?.toolsViewController?.panPressed(pan!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(pan)
                }
            }
        }
    }
}
