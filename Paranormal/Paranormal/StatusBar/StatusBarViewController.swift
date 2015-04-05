import Foundation

public let PNNotificationZoomChanged = "PNNotificationZoomChanged"

public class StatusBarViewController : PNViewController {

    @IBOutlet weak var zoomTextField: NSTextField!

    override public func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "zoomUpdated:",
            name: PNNotificationZoomChanged, object: nil)
    }

    @IBAction public func zoomSentFromGUI(sender: NSTextField) {        let zoomAmount = sender.floatValue / 100.0
        if let editViewCont = document?.singleWindowController?.editorViewController {
            let center = CGPoint(x: editViewCont.editor.frame.width / 2.0,
                y: editViewCont.editor.frame.height / 2.0)
            editViewCont.setZoomAroundApplicationSpacePoint(center, scale: CGFloat(zoomAmount))
        }

        NSNotificationCenter.defaultCenter()
            .postNotificationName(PNNotificationZoomChanged,
                object: nil, userInfo: ["zoom" : zoomAmount])
    }

    func zoomUpdated(notification: NSNotification) {
        zoomTextField.floatValue = (notification.userInfo?["zoom"] as Float)*100
    }
}
