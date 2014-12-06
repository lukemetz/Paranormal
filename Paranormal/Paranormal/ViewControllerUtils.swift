import Foundation
import Cocoa

class ViewControllerUtils{
    // Insert view into parent and set up constraints such that it resizes how parent element
    // resizes.
    class func insertSubviewIntoParent(parent: NSView, child: NSView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(child)

        let horizontalContraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: ["view" : child])
        parent.addConstraints(horizontalContraints)

        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: ["view" : child])

        parent.addConstraints(verticalConstraints)
        child.updateConstraints()
        parent.updateConstraints()
    }
}
