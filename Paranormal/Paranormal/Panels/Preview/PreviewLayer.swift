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
    }

    private func runPreviewWithSprite(previewSprite: CCSprite) {
        ThreadUtils.runCocos { () -> Void in
            previewSprite.position = CGPointMake(self.viewSize.width/2, self.viewSize.height/2)
            PreviewSpriteUtils.resizeSpriteWithoutWarp(previewSprite,
                toWidth:Float(self.viewSize.width) - 50, toHeight:Float(self.viewSize.height) - 50)
            self.addChild(previewSprite)
            self.addRotatingLight()
        }
    }

    func updateNormalMap(image : NSImage) {
        ThreadUtils.runCocos { () -> Void in
            if let sprite = self.previewSprite? {
                let frame = PreviewSpriteUtils.spriteFrameForImage(image)
                sprite.normalMapSpriteFrame = frame
            }
        }
    }

    func updateBaseImage(image : NSImage) {
        ThreadUtils.runCocos { () -> Void in
            if let sprite = self.previewSprite? {
                sprite.texture = PreviewSpriteUtils.spriteFrameForImage(image).texture
            } else {
                // New document set, initialize sprite
                self.previewSprite =
                    CCSprite(texture: PreviewSpriteUtils.spriteTextureForImage(image))
                self.runPreviewWithSprite(self.previewSprite)
            }
        }
    }

    func addRotatingLight() {
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
    }

    func ccKeyDown(event: NSEvent) -> Bool {
        NSLog("key down: \(event.keyCode)")
        return true
    }
}
