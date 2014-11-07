import Foundation
import Cocoa
import GPUImage

class WindowController: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var previewSettingsView: NSView!
    @IBOutlet weak var glView: CCGLView!
    @IBOutlet weak var layersView: NSView!

    var cgContext : CGContextRef?
    var previewSettings : PreviewSettings?
    var layersViewController : LayersViewController?

    @IBOutlet weak var testView: NSImageView!
    
    override init(window: NSWindow?) {
        super.init(window:window)
    }

    func setUpCocos() {
        let director = CCDirector.sharedDirector() as CCDirector!
        director.setView(glView)

        let scene = TestScene()
        director.runWithScene(scene)
    }

    func tearDownCocos() {
        let director = CCDirector.sharedDirector() as CCDirector!
        // TODO correctly shutdown cocos2D
        //director.end()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updatePreviewSettings() {
        previewSettings = PreviewSettings(context: document?.managedObjectContext)

        if let preview = previewSettings?.view {
            for sub in previewSettingsView.subviews {
                sub.removeFromSuperview()
            }
            previewSettingsView.addSubview(preview)

            // Place the view at the top
            let rect : NSRect! = preview.frame
            let container : NSRect! = previewSettingsView?.frame
            preview.frame = NSRect(x: 0,
                y: container.height - rect.height,
                width: rect.width,
                height: rect.height)
        }
    }

    func updateLayers() {
        layersViewController = LayersViewController(context: document?.managedObjectContext)
        if let layers = layersViewController?.view {
            for sub in layersView.subviews {
                sub.removeFromSuperview()
            }
            layersView.addSubview(layers)
        }
    }

    override func windowDidLoad() {
        setUpCocos()
        updatePreviewSettings()

        let img = testView.image
        println(img)
        var stillImageSource = GPUImagePicture(image: img!)
        // var stillImageFilter = GPUImageSepiaFilter()
        let stillImageFilter = GPUImageFilter(fragmentShaderFromFile: "ZUpInitialize")

        stillImageSource.addTarget(stillImageFilter)
        stillImageFilter.useNextFrameForImageCapture()
        stillImageSource.processImageWithCompletionHandler { () -> Void in
            //testView.image = stillImageFilter.imageFromCurrentFramebuffer()
            let retImg = stillImageFilter.imageFromCurrentFramebuffer()
            //let retImg = stillImageFilter.imageByFilteringImage(img)
            println(retImg)
            self.testView.image = retImg
        }



        /*
        UIImage *inputImage = [UIImage imageNamed:@"Lambeau.jpg"];

        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
        GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];

        [stillImageSource addTarget:stillImageFilter];
        [stillImageFilter useNextFrameForImageCapture];
        [stillImageSource processImage];

        UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
        */
    }

    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }

    override init() {
        super.init()
    }

    override var document : AnyObject? {
        // TODO this needs to now hold an array or something as
        // we are using a single window
        set(document) {
            super.document = document

            // Don't update if the view doesn't have pices loaded
            // or if there is no document such as when closing
            if (previewSettingsView != nil && layersView != nil &&
                document != nil) {

                updatePreviewSettings()
                updateLayers()
            }
        }

        get {
            return super.document
        }
    }

    func windowWillClose(notification: NSNotification) {
        document?.close()
        tearDownCocos()
    }

    func windowWillReturnUndoManager(window: NSWindow) -> NSUndoManager? {
        let doc = document as Document?
        return doc?.undoManager
    }
}
