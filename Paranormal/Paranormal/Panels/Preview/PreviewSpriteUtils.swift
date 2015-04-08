import Cocoa
import AppKit
import GPUImage

class PreviewSpriteUtils: NSObject {

    class func scaleSprite(sprite: CCSprite, scale: Float) {
        sprite.scaleX = scale
        sprite.scaleY = scale
    }

    class func resizeSprite(sprite: CCSprite, toWidth: CGFloat, toHeight: CGFloat) {
        sprite.scaleX = Float(toWidth) / Float(sprite.contentSize.width)
        sprite.scaleY = Float(toHeight) / Float(sprite.contentSize.height)
    }

    class func resizeSpriteWithoutWarp(sprite: CCSprite, toWidth: CGFloat, toHeight: CGFloat) {
        let scale = min(Float(toWidth) / Float(sprite.contentSize.width),
            Float(toHeight) / Float(sprite.contentSize.height))
        scaleSprite(sprite, scale: scale)
    }

    class func spriteTextureForImage(image : NSImage) -> CCTexture! {
        let img = NSImageHelper.CGImageFrom(image)
        let texture : CCTexture = CCTexture(CGImage: img, contentScale: 1.0)
        return texture
    }

    class func spriteFrameForImage(image : NSImage) -> CCSpriteFrame! {
        let texture = spriteTextureForImage(image)
        let rect = CGRectMake(0.0, 0.0, image.size.width, image.size.height)
        let spriteFrame = CCSpriteFrame(texture: texture, rectInPixels:rect,
            rotated: false, offset: CGPointMake(0.0, 0.0), originalSize: image.size)
        return spriteFrame
    }

    class func renderedImageForSprite(sprite : CCSprite, size: CGSize? = nil) -> NSImage! {
        // Assumes the sprite's anchor point and position are both (0, 0)
        let rendererSize = CGSizeMake(sprite.contentSize.width,
                                      sprite.contentSize.height)
        let renderer  = CCRenderTexture(
            width:  Int32(rendererSize.width),
            height: Int32(rendererSize.height))
        renderer.contentScale = 1.0

        renderer.begin()
        sprite.visit()
        renderer.end()

        let cgImage: CGImage = renderer.newCGImage().takeUnretainedValue()
        if let resizeSize = size {
            return NSImage(CGImage: cgImage, size: resizeSize)
        } else {
            return NSImage(CGImage: cgImage, size: sprite.contentSize)
        }
    }

    class func grayImage(#width: UInt, height: UInt, brightness: Float) -> NSImage {
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

        var context = CGBitmapContextCreate(nil, width, height,
            8, 0, colorSpace, bitmapInfo)
        let color = CGColorCreateGenericRGB(
            CGFloat(brightness), CGFloat(brightness), CGFloat(brightness), 1.0)
        CGContextSetFillColorWithColor(context, color)
        let rect = CGRectMake(0, 0, CGFloat(width), CGFloat(height))
        CGContextFillRect(context, rect)
        let cgImage = CGBitmapContextCreateImage(context)

        let size = NSSize(width: CGFloat(width), height: CGFloat(height))
        let grayNSImage = NSImage(CGImage: cgImage, size: size)
        return grayNSImage
    }

    class func grayImageWithAlphaSource(source: NSImage, brightness: Float) -> NSImage {
        // Needs to be called on a GPUImageThread
        let replaceAlphaFilter = GPUImageTwoInputFilter(fragmentShaderFromFile: "ReplaceAlpha")

        let grayRectangle = self.grayImage(width: UInt(source.size.width),
            height: UInt(source.size.height), brightness: brightness)
        let grayPicture = GPUImagePicture(image: grayRectangle)
        grayPicture.addTarget(replaceAlphaFilter, atTextureLocation: 0)

        let alphaPicture = GPUImagePicture(image: source)
        alphaPicture.addTarget(replaceAlphaFilter)

        replaceAlphaFilter.useNextFrameForImageCapture()
        grayPicture.processImage()
        alphaPicture.processImage()

        return replaceAlphaFilter.imageFromCurrentFramebuffer()
    }
}
