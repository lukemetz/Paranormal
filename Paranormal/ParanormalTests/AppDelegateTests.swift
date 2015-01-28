import Cocoa
import Quick
import Nimble
import Paranormal
import Foundation

class AppDelegateTests: QuickSpec {
    override func spec() {
        describe("AppDelegate") {
            describe("applicationDidLoad") {
                func editDoesNotContainString(name : String) {
                    let sharedApp = NSApplication.sharedApplication()
                    let emptyNotification = NSNotification(name: "Blank", object: nil)
                    let delegate = sharedApp.delegate as AppDelegate
                    delegate.applicationDidFinishLaunching(emptyNotification)
                    let edit = NSApplication.sharedApplication().mainMenu?.itemWithTitle("Edit")
                    let submenu = edit?.submenu;
                    for item in submenu!.itemArray {
                        let cast_item = item as NSMenuItem
                        expect(cast_item.title).toNot(contain(name))
                    }
                }

                it("Menu bar does not have the 'Edit --> Start Dictation' item") {
                    editDoesNotContainString("Start Dictation")
                }

                it("Menu bar does not have 'Edit --> Special Characters' item") {
                    editDoesNotContainString("Special Characters")
                }
            }
        }
    }
}
