import Foundation
import GPUImage


private let _ThreadUtilsShared = ThreadUtils()

enum ThreadState : Int {
    case Waiting = 0
    case WorkTodo
}

public class ThreadUtils : NSObject {
    var gpuImageThread : NSThread?
    var editClosures : [() -> Void] = []
    var updateClosures : [() -> Void] = []
    var doneProcessing : Bool = true
    var lock : NSLock = NSLock()
    var conditionLock : NSConditionLock

    override init() {
        conditionLock = NSConditionLock(condition: ThreadState.Waiting.rawValue)
        super.init()
        gpuImageThread = NSThread(target: self,
            selector: NSSelectorFromString("threadMain"), object: nil)
        gpuImageThread?.start()
    }

    dynamic func threadMain() {
        while(true) { // TODO turn this off
            conditionLock.lockWhenCondition(ThreadState.WorkTodo.rawValue)
            conditionLock.unlockWithCondition(ThreadState.Waiting.rawValue)
            while (editClosures.count > 0) {
                doneProcessing = false
                lock.lock()
                let closure = editClosures.removeAtIndex(0)
                lock.unlock()
                closure()
            }

            while (updateClosures.count > 0) {
                doneProcessing = false
                lock.lock()
                let closure = updateClosures.removeLast()
                updateClosures = []
                lock.unlock()
                closure()
            }
            doneProcessing = true
        }
    }

    class var sharedInstance: ThreadUtils {
        return _ThreadUtilsShared
    }

    private class func runWork() {
        sharedInstance.conditionLock.lock()
        sharedInstance.conditionLock.unlockWithCondition(ThreadState.WorkTodo.rawValue)
    }

    public class func runGPUImage(block : () -> Void) {
        ThreadUtils.sharedInstance.doneProcessing = false
        sharedInstance.lock.lock()
        ThreadUtils.sharedInstance.updateClosures.append(block)
        sharedInstance.lock.unlock()
        runWork()

    }

    public class func runGPUImageDestructive(block : () -> Void) {
        ThreadUtils.sharedInstance.doneProcessing = false
        sharedInstance.lock.lock()
        ThreadUtils.sharedInstance.editClosures.append(block)
        sharedInstance.lock.unlock()
        runWork()
    }

    class func runCocos(closure : () -> Void) {
        if NSThread.isMainThread() {
            closure()
        } else {
            NSOperationQueue.mainQueue().addOperationWithBlock(closure)
        }
    }

    public class func doneProcessingGPUImage() -> Bool {
        return sharedInstance.doneProcessing;
    }
}
