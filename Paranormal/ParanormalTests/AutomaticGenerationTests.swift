import Foundation
import Paranormal
import Quick
import Nimble
import GPUImage

class AutomaticGenerationTests : QuickSpec {
    override func spec() {
        fdescribe("generate") {
            var editorViewController : EditorViewController!
            var document : Document!
            var editorView : EditorView?
            var tool : AngleBrushTool!

            beforeEach {
                let documentController = DocumentController()
                for doc in documentController.documents {
                    documentController.removeDocument(doc as NSDocument)
                }
                let url = NSURL(fileURLWithPath: "/Users/scope/Desktop/sprite.png")
                documentController.createDocumentFromUrl(url)
                document = documentController.documents[0] as? Document
            }

            it("test callback") {
                var done = false
                let t = AutomaticTool(document: document)
                t.setup(document)

                let input = document.baseImage
                ThreadUtils.runGPUImageDestructive({ () -> Void in
                    let alphaMask = GPUImageFilter(fragmentShaderFromFile: "AlphaToBlack")
                    let mask = alphaMask.imageByFilteringImage(input)
                    NSImageHelper.writeToFile(mask, path: "/Users/scope/Desktop/inputO.png")
                    let outImg = AutomaticGeneration.generatePossionHeightMap(mask)
                    NSImageHelper.writeToFile(outImg, path: "/Users/scope/Desktop/output.png")

                    done = true;
                })
                while(!done) {}
                while(!ThreadUtils.doneProcessingGPUImage() ) {}
                return
            }
        }
    }
}
