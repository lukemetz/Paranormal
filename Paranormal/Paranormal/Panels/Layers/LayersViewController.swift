import Foundation
import Cocoa

class LayersViewController : PNViewController {
    weak var context : NSManagedObjectContext?
    @IBOutlet var treeController: NSTreeController!

    var layers : [Layer] = []

    init?(context : NSManagedObjectContext?) {
        super.init(nibName: "Layers", bundle: nil)
        self.context = context

        layers = context?.executeFetchRequest(
            NSFetchRequest(entityName: "Layer"),
        error: nil) as [Layer]
    }

    override init() {
        super.init()
    }

    required override init?(coder: NSCoder) {
        super.init(coder:coder)
    }

    @IBAction func addLayerPressed(sender: NSButton) {
        var layer = treeController.newObject() as Layer
        layer.name = "Untitled Layer"
        layer.visible = true;
        treeController.addObject(layer)
    }
}
