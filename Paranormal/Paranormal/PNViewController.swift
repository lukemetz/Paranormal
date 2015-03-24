import Foundation
import Cocoa

public class PNViewController : NSViewController {
    public var subPNViewControllers : [PNViewController?] = []

    func setDocumentRecursive(document : Document?) {
        for child in subPNViewControllers {
            child?.document = document
            child?.setDocumentRecursive(document)
        }
    }

    public var document: Document? {
        didSet {
            setDocumentRecursive(document)
        }
    }

    public func addViewController(viewController : PNViewController?) {
        subPNViewControllers.append(viewController)
        setDocumentRecursive(document)
    }
}
