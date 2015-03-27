import Cocoa
import AppKit

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
}
