import Cocoa
import GPUImage

class Document: NSPersistentDocument {
    var singleWindowController : WindowController?

    var currentColor : NSColor = NSColor.blackColor()

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
        return documentSettings?[0] as? DocumentSettings
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
        return combineLayer(rootLayer)
    }

    var computedExportImage : NSImage? {
        return computedEditorImage
    }

    override init() {
        super.init()
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
