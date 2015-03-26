import Foundation
import Paranormal
import GPUImage
import Quick
import Nimble
import Cocoa

class ShadersCompileTest : QuickSpec {
    override func spec() {
        describe("The shader") {
            func ensureShaderExists(shaderName: String) {
                let shaderPath = NSBundle.mainBundle().pathForResource(shaderName, ofType: "fsh")
                expect(shaderPath).toNot(beNil())
            }

            func test_single_input(name : String) {
                ensureShaderExists(name)
                let filter = GPUImageFilter(fragmentShaderFromFile: name)
                let path = NSBundle(forClass:
                    ShadersCompileTest.self).pathForResource("blankImage", ofType: "png")
                let image = NSImage(contentsOfFile: path!)
                let picture = GPUImagePicture(image: image)
                picture.addTarget(filter)
                filter.useNextFrameForImageCapture()
                picture.processImage()
                let res_img = filter.imageFromCurrentFramebuffer()
                expect(res_img).toNot(beNil())
            }

            func test_two_input(name : String) {
                ensureShaderExists(name)
                let filter = GPUImageTwoInputFilter(fragmentShaderFromFile: name)
                let path = NSBundle(forClass:
                    ShadersCompileTest.self).pathForResource("blankImage", ofType: "png")
                let image1 = NSImage(contentsOfFile: path!)
                let image2 = NSImage(contentsOfFile: path!)
                let picture1 = GPUImagePicture(image: image1)
                let picture2 = GPUImagePicture(image: image2)

                picture1.addTarget(filter)
                picture2.addTarget(filter)
                filter.useNextFrameForImageCapture()
                picture1.processImage()
                picture2.processImage()

                let res_img = filter.imageFromCurrentFramebuffer()
                expect(res_img).toNot(beNil())
            }

            it("ZUpInitilaize compiles") {
                test_single_input("ZUpInitialize")
            }

            it("Chamfer compiles") {
                test_single_input("Chamfer")
            }

            it("AlphaToBlack compiles") {
                test_single_input("AlphaToBlack")
            }

            it("DepthToNormal compiles") {
                test_single_input("DepthToNormal")
            }

            it("BlendReorient compiles") {
                test_two_input("BlendReorient")
            }

            it("BlendAdd compiles") {
                test_two_input("BlendAdd")
            }

            it("BlendFlatten compiles") {
                test_two_input("BlendFlatten")
            }

            it("MultiplyMaxAlpha compiles") {
                test_two_input("MultiplyMaxAlpha")
            }

            it("BlendEmphasizeCompiles") {
                test_two_input("BlendEmphasize")
            }

            it("BlendInvertCompiles") {
                test_two_input("BlendInvert")
            }
        }
    }
}
