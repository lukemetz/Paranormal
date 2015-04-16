import Foundation

public let PNNotificationZoomChanged = "PNNotificationZoomChanged"

public class StatusBarViewController : PNViewController {

    @IBOutlet public weak var zoomTextField: NSTextField!

    override public func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "zoomUpdated:",
            name: PNNotificationZoomChanged, object: nil)
    }

    @IBAction public func zoomSentFromGUI(sender: NSTextField) {
        let zoomAmount = sender.floatValue / 100.0
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

    @IBAction public func setEditorViewMode(sender: NSMatrix) {
        if let newViewMode = EditorViewMode(rawValue: sender.selectedColumn) {
            document?.editorViewMode = newViewMode
        } else {
            log.error("editor mode set to unknown value \(sender.selectedColumn)")
        }
    }

    @IBAction public func lightToggled(sender: NSButton) {
        let panelsViewController = document?.singleWindowController?.panelsViewController
        let previewViewController = panelsViewController?.previewViewController
        if sender.integerValue == 0 {
            previewViewController?.currentPreviewLayer?.stopAnimation()
        } else {
            previewViewController?.currentPreviewLayer?.resumeAnimation()
        }
    }
}
