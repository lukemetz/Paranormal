import Foundation
import Cocoa

class PreviewSettings : NSViewController {
    var context : NSManagedObjectContext?

    init?(context : NSManagedObjectContext?) {
        super.init(nibName: "PreviewSettings", bundle: nil)

        self.context = context
    }

    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }

    @IBAction func onSliderChange(sender: NSSlider) {
        println(sender)
    }
}