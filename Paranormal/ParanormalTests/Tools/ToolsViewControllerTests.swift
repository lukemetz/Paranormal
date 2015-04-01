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
            var emphasize : NSButton?
            var flatten : NSButton?
            var smooth : NSButton?
            var sharpen : NSButton?
            var tilt : NSButton?
            var invert : NSButton?
            var zoom : NSButton?
            var pan : NSButton?

            var buttons : [NSButton?]!

            var expectOnlyButtonSelected : (NSButton?) -> Void = {(currentbutton) in
                for button in buttons {
                    if (button == currentbutton) {
                        expect(button?.bordered).to(beTrue())
                    }else{
                        expect(button?.bordered).to(beFalse())
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

                plane = windowController?.toolsViewController?.plane
                emphasize = windowController?.toolsViewController?.emphasize
                flatten = windowController?.toolsViewController?.flatten
                smooth = windowController?.toolsViewController?.smooth
                sharpen = windowController?.toolsViewController?.sharpen
                tilt = windowController?.toolsViewController?.tilt
                invert = windowController?.toolsViewController?.invert
                zoom = windowController?.toolsViewController?.zoom
                pan = windowController?.toolsViewController?.pan


                buttons = [plane, emphasize, flatten, smooth, sharpen, tilt, invert, zoom, pan]
            }

            describe("planePressed") {
                it("sets the active tool on the editorViewController to be an PlaneTool") {
                    windowController?.toolsViewController?.planePressed(plane!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? PlaneTool).toNot(beNil())
                }
                it("tests to see if plane is only button pressed") {
                    windowController?.toolsViewController?.planePressed(plane!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(plane)
                }
            }

            describe("emphasizePressed") {
                it("sets the active tool on the editorViewController to be an EmphasizeTool") {
                    windowController?.toolsViewController?.emphasizePressed(emphasize!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? EmphasizeTool).toNot(beNil())
                }
                it("tests to see if emphasize is only button pressed") {
                    windowController?.toolsViewController?.emphasizePressed(emphasize!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(emphasize)
                }
            }

            describe("flattenPressed") {
                it("sets the active tool on the editorViewController to b a FlattenTool") {
                    windowController?.toolsViewController?.flattenPressed(flatten!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? FlattenTool).toNot(beNil())
                }
                it("tests to see if flatten is only button pressed") {
                    windowController?.toolsViewController?.flattenPressed(flatten!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(flatten)
                }
            }

            describe("smoothPressed") {
                it("sets the active tool on the editorViewController to b a SmoothTool") {
                    windowController?.toolsViewController?.smoothPressed(smooth!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? SmoothTool).toNot(beNil())
                }
                it("tests to see if smooth is only button pressed") {
                    windowController?.toolsViewController?.smoothPressed(smooth!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(smooth)
                }
            }

            describe("sharpenPressed") {
                it("sets the active tool on the editorViewController to b a SharpenTool") {
                    windowController?.toolsViewController?.sharpenPressed(sharpen!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? SharpenTool).toNot(beNil())
                }
                it("tests to see if sharpen is only button pressed") {
                    windowController?.toolsViewController?.sharpenPressed(sharpen!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(sharpen)
                }
            }

            describe("tiltPressed") {
                it("sets the active tool on the editorViewController to b a TiltTool") {
                    windowController?.toolsViewController?.tiltPressed(tilt!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? TiltTool).toNot(beNil())
                }
                it("tests to see if tilt is only button pressed") {
                    windowController?.toolsViewController?.tiltPressed(tilt!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(tilt)
                }
            }

            describe("invertPressed") {
                it("sets the active tool on the editorViewController to be a InvertTool") {
                    windowController?.toolsViewController?.invertPressed(invert!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? InvertTool).toNot(beNil())
                }
                it("tests to see if invert is only button pressed") {
                    windowController?.toolsViewController?.invertPressed(invert!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(invert)
                }
            }

            describe("zoomPressed") {
                it("sets the active tool on the editorViewController to be a ZoomTool") {
                    windowController?.toolsViewController?.zoomPressed(zoom!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expect(activeTool as? ZoomTool).toNot(beNil())
                }
                it("tests to see if zoom is only button pressed") {
                    windowController?.toolsViewController?.zoomPressed(zoom!)

                    let activeTool = windowController?.editorViewController?.activeEditorTool
                    expectOnlyButtonSelected(zoom)
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
