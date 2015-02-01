import Cocoa
import XCTest
import CoreGraphics
import Nimble
import Quick
import Paranormal

class LayerTests: QuickSpec {
    override func spec() {
        var coord : NSPersistentStoreCoordinator!
        var managedObjectContext : NSManagedObjectContext!
        var model : NSManagedObjectModel!
        var store : NSPersistentStore!

        beforeEach {
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

        afterEach {
            coord = nil
            managedObjectContext = nil
            model = nil
            store = nil
        }

        let dummyLayer : () -> Layer = {
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
            // Hack to fix backwards compatibility with NSImage(CGImage:...) constructor
            if let nsImage = (nsImage as NSObject) as? NSImage {
                layer.imageData = nsImage.TIFFRepresentation!
            }
            layer.name = "dummy layer"
            return layer
        }

        it("Can copy data to and from a context") {
            let layer = dummyLayer()

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
            var context = CGBitmapContextCreate(nil, 5, 5, 8, 0, colorSpace, bitmapInfo)

            let originalData = layer.imageData?.copy() as NSData

            CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1, 1, 1, 1))
            CGContextFillRect(context, CGRectMake(0, 0, 5, 5))

            layer.drawToContext(context)
            layer.updateFromContext(context)
            expect(layer.imageData).to(equal(originalData))

            CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1, 0, 1, 1))
            CGContextFillRect(context, CGRectMake(0, 0, 5, 5))
            layer.updateFromContext(context)

            expect(layer.imageData).toNot(equal(originalData))

            CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0, 0, 1, 1))
            CGContextFillRect(context, CGRectMake(0, 0, 5, 5))
            layer.updateFromContext(context)

            expect(layer.imageData).to(equal(originalData))
        }

        it("Adds a layer correctly") {
            let dummy = dummyLayer()
            let layer = dummy.addLayer()
            // The set up creates 1 default layer entity
            let layerFetch = NSFetchRequest(entityName: "Layer")
            let layerResult : NSArray? =
            managedObjectContext.executeFetchRequest(layerFetch, error: nil)
            expect(layerResult?.count).to(equal(2))
            expect(dummy.layers.count).to(equal(1))
        }
    }
}
