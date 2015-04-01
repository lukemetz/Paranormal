import Foundation
import Paranormal
import Quick
import Nimble

class PNEditorHelper {
    class func waitForEditorImageInDocument(document: Document) {
        // Kick the editor a couple times to make sure
        // everything has been updated properly
        let editorController = document.singleWindowController?.editorViewController
            as EditorViewController?
        expect(editorController?.editor.image).toEventuallyNot(beNil()) //wait for image
        expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
        document.computeDerivedData()
        expect(ThreadUtils.doneProcessingGPUImage()).toEventually(beTrue())
        expect(editorController?.editor.image).toEventuallyNot(beNil()) //wait for image
    }
}
