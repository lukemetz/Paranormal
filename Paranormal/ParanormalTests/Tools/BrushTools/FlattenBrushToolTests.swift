import Cocoa
import Quick
import Nimble
import Paranormal

class FlattenBrushToolTests: QuickSpec {
    override func spec() {
        describe("AngleBrushTool") {
            var editorViewController : EditorViewController!
            var document : Document?
            var editorView : EditorView?
            var angleTool : AngleBrushTool!

            beforeEach {
                editorViewController = EditorViewController(nibName: "Editor", bundle: nil)
                editorView = editorViewController.view as? EditorView
                let documentController = DocumentController()
                for doc in documentController.documents {
                    documentController.removeDocument(doc as NSDocument)
                }

                documentController.createDocumentFromUrl(nil)
                document = documentController.documents[0] as? Document

                editorViewController.document = document

                angleTool = AngleBrushTool()
                expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
            }

            describe("Flattening makes an area flatter") {
                beforeEach {
                    document?.currentColor = NSColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
                    document?.brushSize = 9.0;
                    document?.brushOpacity = 1.0;

                    angleTool.mouseDownAtPoint(NSPoint(x: 20, y: 20),
                        editorViewController: editorViewController)
                    angleTool.mouseDraggedAtPoint(NSPoint(x: 60, y: 60),
                        editorViewController: editorViewController)
                    angleTool.mouseUpAtPoint(NSPoint(x: 40, y: 40),
                        editorViewController: editorViewController)
                    angleTool?.stopUsingTool()
                    expect(angleTool.drawingKernel?.doneDrawing()).toEventually(beTrue())

                    document?.computeDerivedData()
                    expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
                }

                // Race condition is reappearing here. No idea why.
                xit("Without opacity") {
                    document?.brushSize = 5.0;
                    let flattenTool = FlattenBrushTool()

                    flattenTool.mouseDownAtPoint(NSPoint(x: 20, y: 20),
                        editorViewController: editorViewController)
                    flattenTool.mouseDraggedAtPoint(NSPoint(x: 60, y: 60),
                        editorViewController: editorViewController)
                    flattenTool.mouseUpAtPoint(NSPoint(x: 40, y: 40),
                        editorViewController: editorViewController)
                    flattenTool.stopUsingTool()
                    expect(flattenTool.drawingKernel?.doneDrawing()).toEventually(beTrue())
                    expect(flattenTool.editLayer).toEventually(beNil())

                    // kick the editor and document into updating
                    document?.computeDerivedData()
                    expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
                    let image = document?.computedNormalImage

                    var color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 0, y:0))
                    expect(color).to(beColor(127, 127, 255, 255))

                    color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 40, y:40))
                    expect(color).to(beColor(127, 127, 255, 255))
                }

                it("With opacity") {
                    document?.brushSize = 5.0;
                    document?.brushOpacity = 0.5;
                    let flattenTool = FlattenBrushTool()

                    flattenTool.mouseDownAtPoint(NSPoint(x: 20, y: 20),
                        editorViewController: editorViewController)
                    flattenTool.mouseDraggedAtPoint(NSPoint(x: 60, y: 60),
                        editorViewController: editorViewController)
                    flattenTool.mouseUpAtPoint(NSPoint(x: 40, y: 40),
                        editorViewController: editorViewController)
                    flattenTool.stopUsingTool()

                    expect(flattenTool.drawingKernel?.doneDrawing()).toEventually(beTrue())
                    expect(flattenTool.editLayer).toEventually(beNil())

                    // kick the editor and document into updating
                    document?.computeDerivedData()
                    expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
                    let image = document?.computedNormalImage

                    var color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 0, y:0))
                    expect(color).to(beColor(127, 127, 255, 255))

                    color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 40, y:40))
                    expect(color).to(beColor(217, 128, 218, 255))
                }
            }
        }
    }
}
