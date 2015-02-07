import Foundation
import GPUImage

// Class manages creating and execution of blocks to be run on new threads
class ThreadWrap {
    var block : () -> Void
    init(block : () -> Void) {
        self.block = block;
    }

    dynamic func threadMain() {
        self.block()
    }

    func run() {

        let thread = NSThread(target: self,
            selector: NSSelectorFromString("threadMain"), object: nil)
        thread.start()
        while (!thread.finished) {}
    }
}

public class ThreadUtils {
    public class func runGPUImage(block : () -> Void) {
        let t = ThreadWrap(block)
        t.run()
    }

    class func runCocos(block : () -> Void) {
        if NSThread.isMainThread() {
            block()
        } else {
            NSOperationQueue.mainQueue().addOperationWithBlock(block)
        }
    }
}
