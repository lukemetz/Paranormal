import Cocoa
import Quick
import Nimble
import Paranormal

class AngleBrushToolTest: QuickSpec {
    override func spec() {
        describe("AngleBrushTool") {
            var editorViewController : EditorViewController!
            var document : Document?
            var editorView : EditorView?
            var tool : AngleBrushTool!

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

                editorViewController?.activeEditorTool = AngleBrushTool()
                tool = editorViewController.activeEditorTool! as AngleBrushTool
                expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
            }

            describe("Drawing lays down angle correctly") {
                it("Without opacity") {
                    document?.currentColor = NSColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
                    document?.brushSize = 5.0;
                    document?.brushOpacity = 1.0;

                    tool.mouseDownAtPoint(NSPoint(x: 20, y: 20),
                        editorViewController: editorViewController)

                    tool.mouseDraggedAtPoint(NSPoint(x: 60, y: 60),
                        editorViewController: editorViewController)

                    tool.mouseUpAtPoint(NSPoint(x: 40, y: 40),
                        editorViewController: editorViewController)
                    expect(tool.drawingKernel?.doneDrawing()).toEventually(beTrue())

                    // kick the editor and document into updating
                    document?.computeDerivedData()
                    expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
                    let image = document?.computedEditorImage

                    var color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 0, y:0))
                    expect(color).to(beColor(127, 127, 255, 255))

                    color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 40, y:40))
                    expect(color).to(beColor(255, 128, 128, 255))

                    color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 40, y:41))
                    expect(color).to(beColor(255, 128, 128, 255))

                    color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 40, y:46))
                    expect(color).to(beColor(127, 127, 255, 255))
                }
            }

            it("With opacity") {
                document?.currentColor = NSColor(red: 1.0, green: 127.0 / 255.0,
                    blue: 127.0 / 255.0, alpha: 1.0)
                document?.brushSize = 5.0;
                document?.brushOpacity = 0.5;

                tool.mouseDownAtPoint(NSPoint(x: 20, y: 20),
                    editorViewController: editorViewController)

                tool.mouseDraggedAtPoint(NSPoint(x: 60, y: 60),
                    editorViewController: editorViewController)

                tool.mouseUpAtPoint(NSPoint(x: 40, y: 40),
                    editorViewController: editorViewController)
                tool.stopUsingTool()
                expect(tool.drawingKernel?.doneDrawing()).toEventually(beTrue())

                // kick the editor and document into updating
                document?.computeDerivedData()
                expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
                let image = document?.computedEditorImage

                var color = NSImageHelper.getPixelColor(image!,
                    pos: NSPoint(x: 0, y:0))
                expect(color).to(beColor(127, 127, 255, 255))

                color = NSImageHelper.getPixelColor(image!,
                    pos: NSPoint(x: 40, y:40))
                expect(color).to(beColor(218, 127, 218, 255))
            }
        }
    }
}
