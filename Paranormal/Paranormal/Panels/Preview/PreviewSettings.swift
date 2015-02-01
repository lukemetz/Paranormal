import Foundation
import Cocoa

class PreviewSettings : NSViewController {

    var refractionModel : Refraction?;

    init?(context : NSManagedObjectContext?) {
        super.init(nibName: "PreviewSettings", bundle: nil)
        let fetch = NSFetchRequest(entityName: "Refraction")
        let res = context?.executeFetchRequest(fetch, error: nil)
        refractionModel = res?[0] as? Refraction
    }

    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }

    @IBAction func onSliderChange(sender: NSSlider) {
        println(refractionModel?.indexOfRefraction)
    }
}
