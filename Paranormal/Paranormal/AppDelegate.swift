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

    func removeLastItemFromEdit(selectorName : String) {
        var edit = NSApplication.sharedApplication().mainMenu?.itemWithTitle("Edit")
        if let count = edit?.submenu?.numberOfItems {
            let lastItem = edit?.submenu?.itemAtIndex(count - 1)
            if lastItem?.action == NSSelectorFromString(selectorName) {
                edit?.submenu?.removeItemAtIndex(count - 1)
            }
        }
    }
    public func applicationDidFinishLaunching(aNotification: NSNotification) {
        // At this point, the main menu is automatically loaded
        self.removeLastItemFromEdit("orderFrontCharacterPalette:")
        self.removeLastItemFromEdit("startDictation:")
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

