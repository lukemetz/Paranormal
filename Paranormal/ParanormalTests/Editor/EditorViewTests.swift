import Cocoa
import Quick
import Nimble
import Paranormal

class EditorViewTests: QuickSpec {
    override func spec() {
        describe("EditorView") {
            var editorViewController : EditorViewController?
            var document : Document?
            var editorView : EditorView!

            beforeEach {
                editorViewController = EditorViewController(nibName: "Editor", bundle: nil)
                editorView = editorViewController?.view as? EditorView
            }

            describe("Point Transforms") {
                it ("imageToApplication and applicationToImage are inverses") {
                    let translate = CGAffineTransformTranslate(CGAffineTransformIdentity, 10, 10)
                    let transform = CGAffineTransformScale(translate, 2, 2)
                    editorView.transform = transform

                    let image = CGPoint(x: 20, y: 32)
                    let application = editorView.imageToApplication(image)
                    let image_test = editorView.applicationToImage(application)

                    expect(image_test).to(equal(image))
                }
            }
        }
    }
}
