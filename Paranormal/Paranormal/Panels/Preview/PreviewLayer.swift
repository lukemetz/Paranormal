import Cocoa
import AppKit

class PreviewLayer: CCNode {
    var previewSprite : CCSprite!
    var background : CCSprite?
    var container : CCNode?
    var lightContainer : CCNode? // TODO: Support having a list of different lights
    var light : CCLightNode?
    var lightIcon : CCSprite?
    var viewSize : CGSize
    var sceneSize : CGSize!
    let padding = 0.2
    var effect : CCEffectLighting?
    let scheduler = CCScheduler()
    var rotateAction : CCAction!

    init(viewSize : NSSize) {
        self.viewSize = viewSize
        super.init()
        self.anchorPoint = CGPointMake(0.0, 0.0)
        userInteractionEnabled = true
    }

    func renderedPreviewImage() -> NSImage? {
        return PreviewSpriteUtils.renderedImageForSprite(self.previewSprite)
    }

    private func beginPreviewWithSprite(sprite: CCSprite) {
        ThreadUtils.runCocos { () -> Void in
            self.updateSceneSize()

            self.background = CCSprite(imageNamed: "checker.png")
            self.addChild(self.background)

            self.container = CCNode() // non-failable
            self.addChild(self.container)

            self.container!.addChild(sprite)

            self.addRotatingLight(self.container!)

            self.updateNodePositions()

            // Schedules a redraw of the current preview view, per frame
            self.scheduler.scheduleTarget(self)
        }
    }

    func updateNodePositions() {
        self.updateSceneSize()
        let spriteSize = self.previewSprite.contentSize

        if let container = self.container {
            container.position = CGPointMake(
            sceneSize.width  / 2 - spriteSize.width  / 2,
            sceneSize.height / 2 - spriteSize.height / 2)
        }
        if let background = self.background {
            background.anchorPoint = CGPointMake(0.5, 0.5)
            background.position = CGPointMake(sceneSize.width / 2, sceneSize.height / 2)
            PreviewSpriteUtils.resizeSprite(background,
                toWidth:  self.sceneSize.width  * 2,
                toHeight: self.sceneSize.height * 2)
        }
        if let sprite = self.previewSprite {
            sprite.anchorPoint = CGPointMake(0.0, 0.0)
            sprite.position = CGPointMake(0.0, 0.0)
        }
        if let lightContainer = self.lightContainer {
            lightContainer.position = CGPointMake(spriteSize.width / 2, spriteSize.height / 2)
        }
        if let light = self.light {
            light.anchorPoint = CGPointMake(0.5, 0.5)
            light.position = CGPointMake(0.0, previewSprite.contentSize.width * 0.6)
        }
        if let lightIcon = self.lightIcon {
            let lightSize = sceneSize.width * 0.15
            lightIcon.scale = Float(lightSize / lightIcon.contentSize.width)
        }
    }

    func updateSceneSize() {
        var sceneAspectRatio = viewSize.width / viewSize.height
        var widthRestricted: Bool = (
            previewSprite.contentSize.width  / viewSize.width >
            previewSprite.contentSize.height / viewSize.height)
        if widthRestricted {
            let sceneWidth = previewSprite.contentSize.width * CGFloat(1.0 + self.padding)
            sceneSize = CGSizeMake(sceneWidth,
                sceneWidth / sceneAspectRatio)
            self.scale = Float(self.viewSize.width / sceneWidth)
        } else {
            let sceneHeight = previewSprite.contentSize.height * CGFloat(1.0 + self.padding)
            sceneSize = CGSizeMake(sceneHeight * sceneAspectRatio,
                sceneHeight)
            self.scale = Float(self.viewSize.height / sceneHeight)
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

    func updateBaseImage(image : NSImage, keepNormalMap: Bool) {
        ThreadUtils.runCocos { () -> Void in
            if let sprite = self.previewSprite? {
                if let parent = sprite.parent {
                    // TODO: Deal with children (for now, there are none)
                    let oldNormalFrame = sprite.normalMapSpriteFrame
                    parent.removeChild(sprite, cleanup: true)
                    self.previewSprite = CCSprite(
                        texture: PreviewSpriteUtils.spriteTextureForImage(image))
                    parent.addChild(self.previewSprite)
                    if keepNormalMap {
                        self.previewSprite.normalMapSpriteFrame = oldNormalFrame
                    }
                } else {
                    log.error("Attempting to change a sprite which has not been added to the scene")
                }
                if let effect = self.effect {
                    self.previewSprite.effect = effect
                }
                self.updateNodePositions()
            } else {
                // New session begun, initialize sprite
                self.previewSprite = CCSprite(texture:
                    PreviewSpriteUtils.spriteTextureForImage(image))
                self.beginPreviewWithSprite(self.previewSprite)
            }
        }
    }

    func addRotatingLight(container: CCNode) {
        let groups = ["group_name"]
        self.lightContainer = CCNode() // non-failable
        container.addChild(lightContainer, z: 1)

        self.light = CCLightNode(type: CCLightType.Point, groups: groups,
            color: CCColor.whiteColor(), intensity: 0.3)
        light!.depth = 20.0
        lightContainer!.addChild(light) // non-failable

        self.lightIcon = CCSprite(imageNamed: "light64.png")
        light!.addChild(lightIcon)

        effect = CCEffectLighting(groups: groups,
            specularColor: CCColor.whiteColor(), shininess:0.01)

        let actionInterval = CCActionRotateBy.actionWithDuration(2, angle: 180) as CCActionInterval
        rotateAction = CCActionRepeatForever(action: actionInterval)
        lightContainer!.runAction(rotateAction)

        previewSprite.effect = effect!
    }

    override func update(delta: CCTime) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            PNPreviewNeedsRedraw, object: nil)
    }

    func stopAnimation() {
        lightContainer?.stopAction(rotateAction)
    }

    func resumeAnimation() {
        lightContainer?.runAction(rotateAction)
    }

    func ccKeyDown(event: NSEvent) -> Bool {
        NSLog("key down: \(event.keyCode)")
        return true
    }
}
