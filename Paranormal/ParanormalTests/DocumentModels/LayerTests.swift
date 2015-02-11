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
        describe("updateFromContext and drawToContext") {
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
        }

        describe("addLayer") {
            it("Adds a layer correctly") {
                let dummy = dummyLayer()
                let layer = dummy.addLayer()
                // The set up creates 1 default layer entity
                let layerFetch = NSFetchRequest(entityName: "Layer")
                let layerResult : NSArray? =
                managedObjectContext.executeFetchRequest(layerFetch, error: nil)
                expect(layerResult?.count).to(equal(2))
                expect(dummy.layers.count).to(equal(1))
                expect(layer?.parent).to(equal(dummy))
            }

            it("The new layer has image data") {
                let dummy = dummyLayer()
                let layer = dummy.addLayer()
                expect(layer?.imageData).toNot(beNil())
                expect(layer?.toImage()?.size).to(equal(NSSize(width:5, height:5)))
            }
        }

        describe("removeLayer") {
            it("Removes a layer") {
                let dummy = dummyLayer()
                let layer = dummy.addLayer()
                dummy.removeLayer(layer!)

                let layerFetch = NSFetchRequest(entityName: "Layer")
                let layerResult : NSArray? =
                managedObjectContext.executeFetchRequest(layerFetch, error: nil)
                expect(layerResult?.count).to(equal(1))
                expect(dummy.layers.count).to(equal(0))
            }
        }

        describe("createEditLayer") {
            it("Should create a layer above the current layer") {
                let dummy = dummyLayer()
                let layer = dummy.addLayer()
                let layer_after = dummy.addLayer()
                expect(dummy.layers.count).to(equal(2))
                let editLayer = layer?.createEditLayer()
                expect(dummy.layers.count).to(equal(3))
                expect(dummy.layers.indexOfObject(editLayer!)).to(equal(1))
            }

            it("Should have some image data of the right size") {
                let dummy = dummyLayer()
                let layer = dummy.addLayer()
                let edit = layer!.createEditLayer()!

                expect(edit.imageData).toNot(beNil())
                let image = edit.toImage()
                expect(image).toNot(beNil())
                expect(image!.size).to(equal(layer?.toImage()?.size))
            }
        }

        describe("renderLayer") {
            it("smoke test multi layers") {
                var ran = false;
                ThreadUtils.runGPUImage({ () -> Void in
                    let dummy = dummyLayer()
                    let layer1 = dummy.addLayer()
                    let layer2 = dummy.addLayer()
                    let layer3 = dummy.addLayer()
                    let edit = layer1!.createEditLayer()!

                    let render = dummy.renderLayer()
                    expect(render).toNot(beNil())
                    expect(render!.size.width).toNot(equal(0))
                    expect(render!.size.height).toNot(equal(0))
                    ran = true
                })
                expect(ran).toEventually(beTrue())
            }

            it("smoke 1 layer") {
                var ran = false;
                ThreadUtils.runGPUImage({ () -> Void in
                    let dummy = dummyLayer()
                    let layer = dummy.addLayer()

                    let render = dummy.renderLayer()
                    expect(render).toNot(beNil())
                    expect(render!.size.width).toNot(equal(0))
                    expect(render!.size.height).toNot(equal(0))
                    ran = true
                })
                expect(ran).toEventually(beTrue())
            }
        }
    }
}
