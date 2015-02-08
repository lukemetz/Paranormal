import Foundation
import GPUImage

// Class manages creating and execution of blocks to be run on new threads
class ThreadWrap {
    var closure : () -> Void
    init(closure : () -> Void) {
        self.closure = closure;
    }

    dynamic func threadMain() {
        self.closure()
    }

    func run() {

        let thread = NSThread(target: self,
            selector: NSSelectorFromString("threadMain"), object: nil)
        thread.start()
        while (!thread.finished) {}
    }
}

public class ThreadUtils {
    public class func runGPUImage(closure : () -> Void) {
        let t = ThreadWrap(closure)
        t.run()
    }

    class func runCocos(closure : () -> Void) {
        if NSThread.isMainThread() {
            closure()
        } else {
            NSOperationQueue.mainQueue().addOperationWithBlock(closure)
        }
    }
}
