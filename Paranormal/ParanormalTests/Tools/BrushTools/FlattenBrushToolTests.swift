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
            var flattenTool : FlattenBrushTool!
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

                editorViewController?.activeEditorTool = FlattenBrushTool()
                flattenTool = editorViewController.activeEditorTool! as FlattenBrushTool
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

                    document?.computeDerivedData()
                    expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
                }

                it("Without opacity") {
                    document?.brushSize = 5.0;

                    flattenTool.mouseDownAtPoint(NSPoint(x: 20, y: 20),
                        editorViewController: editorViewController)
                    flattenTool.mouseDraggedAtPoint(NSPoint(x: 60, y: 60),
                        editorViewController: editorViewController)
                    flattenTool.mouseUpAtPoint(NSPoint(x: 40, y: 40),
                        editorViewController: editorViewController)

                    // kick the editor and document into updating
                    document?.computeDerivedData()
                    expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
                    let image = document?.computedEditorImage

                    NSImageHelper.writeToFile(image!, path: "/Users/scope/Desktop/test_num1.png")

                    var color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 0, y:0))
                    expect(color.redComponent).to(equal(127))
                    expect(color.greenComponent).to(equal(127))
                    expect(color.blueComponent).to(equal(255))
                    expect(color.alphaComponent).to(equal(255))

                    color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 40, y:40))
                    expect(color.redComponent).to(equal(127))
                    expect(color.greenComponent).to(equal(127))
                    expect(color.blueComponent).to(equal(255))
                    expect(color.alphaComponent).to(equal(255))
                }

                it("With opacity") {
                    document?.brushSize = 5.0;
                    document?.brushOpacity = 0.5;

                    flattenTool.mouseDownAtPoint(NSPoint(x: 20, y: 20),
                        editorViewController: editorViewController)

                    flattenTool.mouseDraggedAtPoint(NSPoint(x: 60, y: 60),
                        editorViewController: editorViewController)

                    flattenTool.mouseUpAtPoint(NSPoint(x: 40, y: 40),
                        editorViewController: editorViewController)

                    // kick the editor and document into updating
                    document?.computeDerivedData()
                    expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
                    let image = document?.computedEditorImage

                    var color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 0, y:0))
                    expect(color.redComponent).to(equal(127))
                    expect(color.greenComponent).to(equal(127))
                    expect(color.blueComponent).to(equal(255))
                    expect(color.alphaComponent).to(equal(255))

                    color = NSImageHelper.getPixelColor(image!,
                        pos: NSPoint(x: 40, y:40))
                    expect(color.redComponent).to(equal(217))
                    expect(color.greenComponent).to(equal(128))
                    expect(color.blueComponent).to(equal(218))
                    expect(color.alphaComponent).to(equal(255))
                }
            }
        }
    }
}
