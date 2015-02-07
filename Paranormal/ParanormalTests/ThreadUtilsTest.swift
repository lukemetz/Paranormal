import Foundation
import Paranormal
import Quick
import Nimble
class ThreadUtilsTest : QuickSpec {
    override func spec() {
        describe("ThreadUtilsTest") {
            describe("runGPUImage") {
                it("Runs the block on a different thread") {
                    var toBeTrue = false
                    func testFunc() {
                        toBeTrue = true
                        expect(NSThread.currentThread()).toNot(equal(NSThread.mainThread()))
                    }

                    ThreadUtils.runGPUImage(testFunc)
                    expect(toBeTrue).toEventually(beTrue())
                }
            }
        }
    }
}
