import Cocoa
import GPUImage

let PNDocumentComputedEditorChanged = "PNDocumentComptedEditorChanged"

class Document: NSPersistentDocument {
    var singleWindowController : WindowController?

    var currentColor : NSColor = NSColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)

    var rootLayer : Layer? {
        return documentSettings?.rootLayer
    }

    var currentLayer : Layer? {
        return rootLayer?.layers.objectAtIndex(0) as Layer?
    }

    var documentSettings : DocumentSettings? {
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

    func mergeTwoNormals(# base: NSImage, detail: NSImage) -> NSImage? {
        // Apply the filter
        let blend = BlendReorientedNormalsFilter()
        let baseSource = GPUImagePicture(image: base)
        baseSource.addTarget(blend)

        let detailSource = GPUImagePicture(image: detail)
        detailSource.addTarget(blend)

        blend.useNextFrameForImageCapture()
        baseSource.processImage()
        detailSource.processImage()

        return blend.imageFromCurrentFramebuffer()
    }

    func combineLayer(parentLayer: Layer?) -> NSImage? {
        var accum : NSImage? = nil
        for layer in (parentLayer?.layers.array as [Layer]) {
            if accum == nil {
                accum = layer.toImage()
            } else {
                if let detail = layer.toImage() {
                    accum = mergeTwoNormals(base: accum!, detail: detail)
                }
            }
        }
        return accum
    }

    var computedEditorImage : NSImage? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(
                PNDocumentComputedEditorChanged, object: self.computedEditorImage)
        }
    }

    var computedExportImage : NSImage? {
        return computedEditorImage
    }

    // TODO cache this
    var baseImage : NSImage? {
        if let path = documentSettings?.baseImage {
            let image = NSImage(contentsOfFile: path)
            if image == nil {
                log.error("Tried to create image from path" + path + " but failed")
                return nil
            }
            return image
        } else {
            log.info("No base image specified. Using blank image.")
            // If there is no base image, try to make a gray image.
            if let docSettings = documentSettings? {
                let width = docSettings.width
                let height = docSettings.height

                let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

                var context = CGBitmapContextCreate(nil, UInt(width),
                    UInt(height), 8, 0, colorSpace, bitmapInfo)
                let color = CGColorCreateGenericRGB(0.9, 0.5, 0.5, 1.0)
                CGContextSetFillColorWithColor(context, color)
                let rect = CGRectMake(0, 0, CGFloat(height), CGFloat(width))
                CGContextFillRect(context, rect)
                let cgImage = CGBitmapContextCreateImage(context)

                let size = NSSize(width: CGFloat(width), height: CGFloat(height))
                return NSImage(CGImage: cgImage, size:size)
            }
        }

        return nil
    }

    override init() {
        super.init()

        setUpDefaultDocument()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCoreData:",
            name: NSManagedObjectContextObjectsDidChangeNotification, object: nil)
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

        documentSettings.rootLayer = layer

        let defaultLayer = layer.addLayer()
        defaultLayer?.name = "Default Layer"

        // Set up default layer
        let width = documentSettings.width
        let height = documentSettings.height
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

    func updateCoreData(notification: NSNotification) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.computedEditorImage = self.combineLayer(self.rootLayer)
        }
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController
        // has loaded the document's window.

    }

    override class func autosavesInPlace() -> Bool {
        return false
    }

    override func makeWindowControllers() {
        addWindowController(singleWindowController!)
    }
}
