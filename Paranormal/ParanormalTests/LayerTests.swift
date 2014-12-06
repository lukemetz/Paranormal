import Cocoa
import XCTest
import CoreGraphics

class LayerTests: XCTestCase {
    var coord : NSPersistentStoreCoordinator!
    var managedObjectContext : NSManagedObjectContext!
    var model : NSManagedObjectModel!
    var store : NSPersistentStore!

    override func setUp() {
        super.setUp()

        model = NSManagedObjectModel.mergedModelFromBundles(nil)
        coord = NSPersistentStoreCoordinator(managedObjectModel: model)
        store = coord.addPersistentStoreWithType(NSInMemoryStoreType,
            configuration: nil,
            URL: nil,
            options: nil,
            error: nil)

        managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coord
    }

    override func tearDown() {
        super.tearDown()
        coord = nil
        managedObjectContext = nil
        model = nil
        store = nil
    }

    func dummyLayer() -> Layer {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        var context = CGBitmapContextCreate(nil, 5, 5, 8, 0, colorSpace, bitmapInfo)
        CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0, 0, 1, 1))
        CGContextFillRect(context, CGRectMake(0, 0, 5, 5))
        let cgImage = CGBitmapContextCreateImage(context)
        let nsImage = NSImage(CGImage: cgImage, size: NSSize(width: 5, height: 5))

        let layerDescription = NSEntityDescription.entityForName("Layer",
            inManagedObjectContext: managedObjectContext)!

        let layer = Layer(entity: layerDescription,
            insertIntoManagedObjectContext: managedObjectContext)

        layer.imageData = nsImage.TIFFRepresentation!
        layer.name = "dummy layer"
        return layer
    }

    func testLayerContext() {
        let layer = dummyLayer()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        var context = CGBitmapContextCreate(nil, 5, 5, 8, 0, colorSpace, bitmapInfo)

        let originalData = layer.imageData?.copy() as NSData

        CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1, 1, 1, 1))
        CGContextFillRect(context, CGRectMake(0, 0, 5, 5))

        layer.drawToContext(context)
        layer.updateFromContext(context)
        XCTAssert(layer.imageData == originalData,
            "drawToContext + updateFromContext changes context back")

        CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1, 0, 1, 1))
        CGContextFillRect(context, CGRectMake(0, 0, 5, 5))
        layer.updateFromContext(context)

        XCTAssert(layer.imageData != originalData, "updateFromContext does update imageData")

        CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0, 0, 1, 1))
        CGContextFillRect(context, CGRectMake(0, 0, 5, 5))
        layer.updateFromContext(context)

        XCTAssert(layer.imageData == originalData, "updateFromContext changes imagedata back")
    }

    func testAddLayer() {
        let dummy = dummyLayer()
        let layer = dummy.addLayer()
        // The set up creates 1 default layer entity
        let layerFetch = NSFetchRequest(entityName: "Layer")
        let layerResult : NSArray? =
        managedObjectContext.executeFetchRequest(layerFetch, error: nil)
        XCTAssert(layerResult?.count == 2, "3 Layers after adding a layer")
        XCTAssert(dummy.layers.count == 1, "Root Layer has 2 children")
    }
}
