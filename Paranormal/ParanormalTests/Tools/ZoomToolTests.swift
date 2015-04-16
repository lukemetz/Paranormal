import Cocoa
import Quick
import Nimble
import Paranormal

class ZoomToolTests: QuickSpec {
    override func spec() {
        describe("ZoomTool") {
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

            var getScale : () -> CGVector = {
                let pt = getTranslate()
                let point = CGPointApplyAffineTransform(CGPoint(x: 1, y:1), editorView!.transform)
                return CGVector(dx: point.x - pt.dx, dy: point.y - pt.dy)
            }

            describe("When clicking on the canvas") {
                beforeEach() {
                    editorViewController?
                        .setZoomAroundApplicationSpacePoint(NSPoint(x:0, y:0), scale: 2.0)
                    editorViewController?.translateView(4.0, 8.0)
                }

                xit("scales the editorView around the click point") {
                    let zoomTool = ZoomTool()
                    zoomTool.mouseDownAtPoint(NSPoint(x:30, y:30),
                        editorViewController: editorViewController!)
                    zoomTool.mouseUpAtPoint(NSPoint(x:30, y:30),
                        editorViewController: editorViewController!)
                    expect(getScale()).to(equal(CGVector(dx: 3, dy: 3)))
                    expect(getTranslate()).to(equal(CGVector(dx:-26.0, dy:-22)))
                }

                xit("Triggers a PNNotificationZoomChanged notification") {
                    var ranNotification = false
                    NSNotificationCenter.defaultCenter()
                    .addObserverForName(PNNotificationZoomChanged, object: nil, queue: nil,
                        usingBlock: { (n) -> Void in
                            ranNotification = true
                    })
                    let zoomTool = ZoomTool()
                    zoomTool.mouseDownAtPoint(NSPoint(x:30, y:30),
                        editorViewController: editorViewController!)
                    zoomTool.mouseUpAtPoint(NSPoint(x:30, y:30),
                        editorViewController: editorViewController!)

                    expect(ranNotification).toEventually(beTrue(()))
                }
            }
        }
    }
}
