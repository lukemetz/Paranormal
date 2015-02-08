import Cocoa
import AppKit

class PreviewLayer: CCNode {
    var previewSprite : CCSprite!
    var viewSize: CGSize
    var effect: CCEffectLighting?

    init(viewSize : NSSize) {
        self.viewSize = viewSize
        super.init()
        userInteractionEnabled = true
        ThreadUtils.runCocos { () -> Void in
            initializeLayer()
            addRotatingLight()
            initializeStaticExample()
        }
    }

    class func spriteFrameForImage(image : NSImage) -> CCSpriteFrame! {
        let img = image.CGImageForProposedRect(nil, context: nil, hints: nil)?.takeUnretainedValue()

        let texture : CCTexture = CCTexture(CGImage: img, contentScale: 1.0)
        let rect = CGRectMake(0.0, 0.0, image.size.width, image.size.height)
        let spriteFrame = CCSpriteFrame(texture: texture, rectInPixels:rect,
            rotated: false, offset: CGPointMake(0.0, 0.0), originalSize: image.size)
        return spriteFrame
    }

    func updateNormalMap(image : NSImage) {
        ThreadUtils.runCocos { () -> Void in
            if let sprite = self.previewSprite? {
                sprite.normalMapSpriteFrame = PreviewLayer.spriteFrameForImage(image)
                sprite.normalMapSpriteFrame = frame
            } else {
                self.initializeSprite(self.previewSprite)
            }
        }
    }

    func updateBaseImage(image : NSImage) {
        ThreadUtils.runCocos { () -> Void in
            if let sprite = self.previewSprite? {
                sprite.texture = PreviewLayer.spriteFrameForImage(image).texture
            }
        }
    }

    func initializeLayer() {

    }
    
    func initializeSprite(newSprite : CCSprite) {
        newSprite.position = CGPointMake(viewSize.width/2, viewSize.height/2)
        
    }

    func initializeStaticExample() {
        updateBaseImage(NSImage(named: "gem-diffuse.png")!)
    }

    func addRotatingLight() {
        
    }
    
    func createStaticExample() {
        sprite = CCSprite(imageNamed:"gem-diffuse.png")
        sprite.position = CGPointMake(viewSize.width/2, viewSize.height/2)

        var normalMap: CCSpriteFrame = CCSpriteFrame(
            textureFilename:"gem-normal.png",
            rectInPixels: CGRectMake(0, 0, previewSprite.contentSize.width, previewSprite.contentSize.height),
            rotated: false, offset: CGPointMake(0, 0), originalSize: viewSize)
        previewSprite.normalMapSpriteFrame = normalMap

        PreviewLayer.resizeSpriteWithoutWarp(previewSprite, toWidth:Float(viewSize.width) - 50,
            toHeight:Float(viewSize.height) - 50)

        var background: CCSprite = CCSprite(imageNamed:"checker.png")
        PreviewLayer.resizeSprite(background, toWidth:Float(viewSize.width*2),
            toHeight:Float(viewSize.height*2))

        let groups = ["group_name"]
        let light = CCLightNode(type: CCLightType.Point, groups: groups,
            color: CCColor.whiteColor(), intensity: 0.5)
        light.position.x = previewSprite.contentSize.width / 2.0
        light.anchorPoint = CGPointMake(0.5, 0.5)

        let lightContainer = CCNode()
        lightContainer.position = CGPointMake(
            previewSprite.contentSize.width/2, previewSprite.contentSize.height/2)

        lightContainer.addChild(light)

        previewSprite.addChild(lightContainer)

        let sunIcon: CCSprite = CCSprite(imageNamed: "light64.png")
        sunIcon.contentSize = CGSizeMake(32.0, 32.0)
        light.addChild(sunIcon)

        effect = CCEffectLighting(groups: groups,
            specularColor: CCColor.whiteColor(), shininess:0.5)

        let action = CCActionRotateBy.actionWithDuration(2, angle: 180) as CCActionInterval
        lightContainer.runAction(CCActionRepeatForever(action: action))

        previewSprite.effect = effect!
        self.addChild(background)
        self.addChild(previewSprite)
    }

    // This should be moved to a move logical place
    class func resizeSprite(sprite: CCSprite, toWidth: Float, toHeight: Float) {
        sprite.scaleX = toWidth / Float(sprite.contentSize.width)
        sprite.scaleY = toHeight / Float(sprite.contentSize.height)
    }

    class func resizeSpriteWithoutWarp(sprite: CCSprite, toWidth: Float, toHeight: Float) {
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
