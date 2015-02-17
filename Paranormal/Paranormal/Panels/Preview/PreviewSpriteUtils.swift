import Cocoa
import AppKit

class PreviewSpriteUtils: NSObject{

    class func resizeSprite(sprite: CCSprite, toWidth: CGFloat, toHeight: CGFloat) {
        sprite.scaleX = Float(toWidth) / Float(sprite.contentSize.width)
        sprite.scaleY = Float(toHeight) / Float(sprite.contentSize.height)
    }

    class func resizeSpriteWithoutWarp(sprite: CCSprite, toWidth: CGFloat, toHeight: CGFloat) {
        let scale = min(Float(toWidth) / Float(sprite.contentSize.width),
            Float(toHeight) / Float(sprite.contentSize.height))
        sprite.scaleX = scale
        sprite.scaleY = scale
    }

    class func spriteTextureForImage(image : NSImage) -> CCTexture! {
        let img = image.CGImageForProposedRect(nil, context: nil, hints: nil)?.takeUnretainedValue()
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
}
