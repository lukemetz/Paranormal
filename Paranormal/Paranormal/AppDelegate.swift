import Cocoa
import XCGLogger

let log = XCGLogger.defaultInstance()

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    public var documentController : DocumentController
    public override init() {
        documentController = DocumentController()
        super.init()
    }

    public func applicationDidFinishLaunching(aNotification: NSNotification) {
        // At this point, the main menu is automatically loaded
    }

    public func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    public func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
        return true
    }

    public func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}

