import Foundation
import Paranormal
import Quick
import Nimble
class AutomaticGenerationTests : QuickSpec {
    override func spec() {
        fdescribe("generate") {
            it("test callback") {
                let input = NSImage(contentsOfFile: "/USers/scope/Desktop/input.png")
                let outImg = AutomaticGeneration.generatePossionHeightMap(input)
                NSImageHelper.writeToFile(outImg, path: "/Users/scope/Desktop/output.png")
                return
            }
        }
    }
}
