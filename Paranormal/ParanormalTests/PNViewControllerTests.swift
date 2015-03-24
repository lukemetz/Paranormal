import Foundation
import Cocoa
import Paranormal
import Quick
import Nimble

class PNViewControllerTests: QuickSpec {
    override func spec() {
        describe("PNViewController") {
            it("Recursivly sets the document on child view controllers") {
                var c1 = PNViewController()
                var c2 = PNViewController()
                var c3 = PNViewController()
                c1.addViewController(c2)
                c2.addViewController(c3)

                expect(c1.document).to(beNil())
                expect(c2.document).to(beNil())
                expect(c3.document).to(beNil())

                let document = Document(type: "Paranormal", error: nil)!

                c1.document = document
                expect(c1.document).to(equal(document))
                expect(c2.document).to(equal(document))
                expect(c3.document).to(equal(document))
            }
        }
    }
}
