import Cocoa
import AppKit

class PreviewLayer: CCNode {
    var sprite : CCSprite!
    var viewSize: CGSize
    var effect: CCEffectLighting?

    override init() {
        viewSize = CCDirector.sharedDirector().viewSize()
        super.init()
        userInteractionEnabled = true
        createStaticExample()
    }

    func spriteFrameForImage(image : NSImage) -> CCSpriteFrame! {
        let source = CGImageSourceCreateWithData(image.TIFFRepresentation, nil)
        let img =  CGImageSourceCreateImageAtIndex(source, 0, nil)

        let texture : CCTexture = CCTexture(CGImage: img, contentScale: 1.0)
        let rect = CGRectMake(0.0, 0.0, image.size.width, image.size.height)
        let spriteFrame = CCSpriteFrame(texture: texture, rectInPixels:rect,
            rotated: false, offset: CGPointMake(0.0, 0.0), originalSize: image.size)
        return spriteFrame
    }

    func updateNormalMap(image : NSImage) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            if let sprite = self.sprite? {
                sprite.normalMapSpriteFrame = self.spriteFrameForImage(image)
            }
        }
    }

    func updateBaseImage(image : NSImage) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            if let sprite = self.sprite? {
                sprite.texture = self.spriteFrameForImage(image).texture
            }
        }
    }

    func createStaticExample() {
        sprite = CCSprite(imageNamed:"gem-diffuse.png")
        sprite.position = CGPointMake(viewSize.width/2, viewSize.height/2)

        var normalMap: CCSpriteFrame = CCSpriteFrame(
            textureFilename:"gem-normal.png",
            rectInPixels: CGRectMake(0, 0, sprite.contentSize.width, sprite.contentSize.height),
            rotated: false, offset: CGPointMake(0, 0), originalSize: viewSize)
        sprite.normalMapSpriteFrame = normalMap

        resizeSpriteWithoutWarp(sprite, toWidth:Float(viewSize.width) - 50,
            toHeight:Float(viewSize.height) - 50)

        var background: CCSprite = CCSprite(imageNamed:"checker.png")
        resizeSprite(background, toWidth:Float(viewSize.width*2),
            toHeight:Float(viewSize.height*2))

        let groups = ["group_name"]
        let light = CCLightNode(type: CCLightType.Point, groups: groups,
            color: CCColor.whiteColor(), intensity: 0.5)
        light.position.x = sprite.contentSize.width / 2.0
        light.anchorPoint = CGPointMake(0.5, 0.5)

        let lightContainer = CCNode()
        lightContainer.position = CGPointMake(
            sprite.contentSize.width/2, sprite.contentSize.height/2)

        lightContainer.addChild(light)

        sprite.addChild(lightContainer)

        let sunIcon: CCSprite = CCSprite(imageNamed: "light64.png")
        sunIcon.contentSize = CGSizeMake(32.0, 32.0)
        light.addChild(sunIcon)

        effect = CCEffectLighting(groups: groups,
            specularColor: CCColor.whiteColor(), shininess:0.5)

        let action = CCActionRotateBy.actionWithDuration(2, angle: 180) as CCActionInterval
        lightContainer.runAction(CCActionRepeatForever(action: action))

        sprite.effect = effect!
        self.addChild(background)
        self.addChild(sprite)
    }

    // This should be moved to a move logical place
    func resizeSprite(sprite: CCSprite, toWidth: Float, toHeight: Float) {
        sprite.scaleX = toWidth / Float(sprite.contentSize.width)
        sprite.scaleY = toHeight / Float(sprite.contentSize.height)
    }

    func resizeSpriteWithoutWarp(sprite: CCSprite, toWidth: Float, toHeight: Float) {
        let scale = min(toWidth / Float(sprite.contentSize.width),
            toHeight / Float(sprite.contentSize.height))
        sprite.scaleX = scale
        sprite.scaleY = scale
    }

    func ccKeyDown(event: NSEvent) -> Bool {
        NSLog("key down: \(event.keyCode)")
        return true
    }
}
