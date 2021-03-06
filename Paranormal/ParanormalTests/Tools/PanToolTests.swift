import Cocoa
import Quick
import Nimble
import Paranormal

class PanToolTests: QuickSpec {
    override func spec() {
        describe("PanTool") {
            var editorViewController : EditorViewController?
            var document : Document?
            var editorView : EditorView?

            beforeEach {
                editorViewController = EditorViewController(nibName: "Editor", bundle: nil)
                editorView = editorViewController?.view as? EditorView

                document = DocumentController()
                    .makeUntitledDocumentOfType("Paranormal", error: nil) as? Document
                editorViewController?.document = document
            }

            var getTranslate : () -> CGVector = {
                let point = CGPointApplyAffineTransform(CGPoint(x: 0, y:0), editorView!.transform)
                return CGVector(dx: point.x, dy: point.y)
            }

            context("editorViewController scale is set to 1") {
                beforeEach() {
                    let _ = editorViewController?
                        .setZoomAroundApplicationSpacePoint(NSPoint(x:0, y:0), scale: 1.0)
                }

                it("translate the editorView translation field") {
                    let panTool = PanTool()
                    panTool.mouseDownAtPoint(NSPoint(x:30, y:30),
                        editorViewController: editorViewController!)
                    expect(getTranslate()).to(equal(CGVector(dx: 0, dy: 0)))

                    panTool.mouseDraggedAtPoint(NSPoint(x:40, y:130),
                        editorViewController: editorViewController!)
                    expect(getTranslate()).to(equal(CGVector(dx: 10, dy: 100)))

                    // The editorview now translates its points to give you back in transformed
                    panTool.mouseDraggedAtPoint(NSPoint(x:40, y:40),
                        editorViewController: editorViewController!)
                    expect(getTranslate()).to(equal(CGVector(dx: 20, dy: 110)))
                    panTool.mouseUpAtPoint(NSPoint(x:20, y:20),
                        editorViewController: editorViewController!)

                    expect(getTranslate()).to(equal(CGVector(dx: 10, dy: 100)))
                }
            }

            context("editorViewController scale is set to 2") {
                beforeEach() {
                    let _ = editorViewController?
                        .setZoomAroundApplicationSpacePoint(NSPoint(x:0, y:0),
                            scale: 2.0)                }

                it("translate the editorView translation field") {
                    let panTool = PanTool()
                    panTool.mouseDownAtPoint(NSPoint(x:30, y:30),
                        editorViewController: editorViewController!)
                    expect(getTranslate()).to(equal(CGVector(dx: 0, dy: 0)))

                    panTool.mouseDraggedAtPoint(NSPoint(x:40, y:130),
                        editorViewController: editorViewController!)
                    expect(getTranslate()).to(equal(CGVector(dx: 20, dy: 200)))

                    // The editorview now translates its points to give you back in transformed
                    panTool.mouseDraggedAtPoint(NSPoint(x:40, y:40),
                        editorViewController: editorViewController!)
                    expect(getTranslate()).to(equal(CGVector(dx: 40.0, dy: 220)))

                    panTool.mouseUpAtPoint(NSPoint(x:20, y:20),
                        editorViewController: editorViewController!)

                    expect(getTranslate()).to(equal(CGVector(dx: 20, dy: 200)))
                }
            }
        }
    }
}
