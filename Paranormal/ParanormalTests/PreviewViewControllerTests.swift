import Cocoa
import Paranormal
import Quick
import Nimble

class PreviewViewControllerTests: QuickSpec {
    override func spec(){
        describe("PreviewViewController"){
            describe("on initialize"){
                var document : Document!
                var documentController: DocumentController!
                var director: CCDirector!

                beforeEach {
                    document = Document(type: "Paranormal", error: nil)!
                    documentController = DocumentController()
                    director = CCDirector.sharedDirector()
                }

                it(""){
                    
                }

            }
        }
    }
}