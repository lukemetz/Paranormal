import Cocoa
import GPUImage

let PNDocumentNormalImageChanged = "PNDocumentNormalImageChanged"
let PNPreviewNeedsRedraw = "PNPreviewNeedsRedraw"

public class Document: NSPersistentDocument {
    public var singleWindowController : WindowController?
    public var toolSettings : ToolSettings = ToolSettings()

    // User preferences / user facing data
    public var editorViewMode : EditorViewMode = EditorViewMode.Normal {
        didSet {
            if let previewController =
                    self.singleWindowController?.panelsViewController?.previewViewController {
                previewController.updatePreviewSpriteImage()
            }
        }
    }

    public var rootLayer : Layer? {
        return documentSettings?.rootLayer
    }

    public var currentLayer : Layer? {
        return rootLayer?.layers.objectAtIndex(0) as Layer?
    }

    public var documentSettings : DocumentSettings? {
        let fetch = NSFetchRequest(entityName: "DocumentSettings")
        var error : NSError?
        let documentSettings = managedObjectContext.executeFetchRequest(fetch, error: &error)
        if let unwrapError = error {
            let alert = NSAlert(error: unwrapError)
            alert.runModal()
        }
        if documentSettings?.count == 0 {
            return nil
        } else {
            return documentSettings?[0] as? DocumentSettings
        }
    }

    public var computedNormalImage : NSImage? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(
                PNDocumentNormalImageChanged, object: self.computedNormalImage)
        }
    }

    public var computedPreviewImage : NSImage? {
        var previewcontroller = singleWindowController?.panelsViewController?.previewViewController
        return previewcontroller?.renderedPreviewImage()
    }

    public var computedEditorImage : NSImage? {
        switch self.editorViewMode {
        case .Normal:
            return computedNormalImage
        case .Preview, .Lighting:
            return computedPreviewImage
        }
    }

    public var computedExportImage : NSImage? {
        return computedNormalImage
    }

    // TODO cache this
    var baseImage : NSImage? {
        if let path = documentSettings?.baseImage {
            if let image = NSImage(contentsOfFile: path) {
                return image
            }
            log.info("Tried to create image from path" + path + " but failed. Using default image.")
        }
        // If there is no base image, try to make a gray image.
        if let docSettings = documentSettings? {
            return PreviewSpriteUtils.grayImage(width: UInt(docSettings.width),
                height: UInt(docSettings.height), brightness: 0.5)
        }
        else {
            log.error("Failed to initialize document")
            return nil
        }
    }

    var grayImage : NSImage?

    override init() {
        super.init()

        let coordinator = managedObjectContext.persistentStoreCoordinator;

        managedObjectContext =  NSManagedObjectContext(concurrencyType:
            NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.undoManager = undoManager
        managedObjectContext.stalenessInterval = 0

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCoreData:",
            name: NSManagedObjectContextObjectsDidChangeNotification, object: nil)
    }

    func updateCoreData(notification: NSNotification) {
        if rootLayer != nil {
            computeDerivedData()
        }
    }

    public func computeDerivedData() {
        ThreadUtils.runGPUImage { () -> Void in
            self.computedNormalImage = self.rootLayer?.renderLayer()
        }
    }

    // Create a default document with correct managed objects.
    func setUpDefaultDocument() {
        let refractionDescription = NSEntityDescription.entityForName("Refraction",
            inManagedObjectContext: managedObjectContext)!
        let refraction = Refraction(entity: refractionDescription,
            insertIntoManagedObjectContext: managedObjectContext)
        refraction.indexOfRefraction = 0.8

        let documentSettingsDescription = NSEntityDescription.entityForName("DocumentSettings",
            inManagedObjectContext: managedObjectContext)!
        let documentSettings = DocumentSettings(entity: documentSettingsDescription,
            insertIntoManagedObjectContext: managedObjectContext)

        let layerDescription = NSEntityDescription.entityForName("Layer",
            inManagedObjectContext: managedObjectContext)!
        let layer = Layer(entity: layerDescription,
            insertIntoManagedObjectContext: managedObjectContext)
        layer.name = "Root Layer"
        layer.visible = true

        let width = documentSettings.width
        let height = documentSettings.height
        layer.fillWithEmpty(NSSize(width: Int(width), height: Int(height)))

        documentSettings.rootLayer = layer

        let defaultLayer = layer.addLayer()
        defaultLayer?.name = "Default Layer"

        // Set up default layer

        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(nil, UInt(width),
            UInt(height), 8, 0, colorSpace, bitmapInfo)
        defaultLayer?.updateFromContext(context)

        managedObjectContext.processPendingChanges()

        undoManager?.removeAllActions()
    }

    convenience init?(type typeName: String, error outError: NSErrorPointer) {
        self.init()
    }


    override public func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController
        // has loaded the document's window.

    }

    override public class func autosavesInPlace() -> Bool {
        return false
    }

    override public func makeWindowControllers() {
        addWindowController(singleWindowController!)
    }

    public func setActiveEditorTool(tool: ActiveTool) {
        let panelVC = singleWindowController?.panelsViewController
        panelVC?.displayActiveToolSettings(tool)
        let editorVC = singleWindowController?.editorViewController
        editorVC?.activeEditorTool = PNToolUtils.toolForToolMode(tool)
    }
}
