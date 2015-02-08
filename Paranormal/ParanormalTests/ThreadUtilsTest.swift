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

                it("Runs the block on a consistent thread") {
                    var thread1 : NSThread?;
                    var thread2 : NSThread?;

                    func test1() {
                        thread1 = NSThread.currentThread()
                    }

                    func test2() {
                        thread2 = NSThread.currentThread()
                    }

                    ThreadUtils.runGPUImageDestructive(test1)
                    ThreadUtils.runGPUImageDestructive(test2)

                    expect(thread1).toEventuallyNot(beNil())
                    expect(thread2).toEventuallyNot(beNil())
                    expect(thread1).toEventually(equal(thread2))
                }
            }
        }
    }
}
