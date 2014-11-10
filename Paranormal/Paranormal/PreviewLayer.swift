//
//  PreviewLayer.swift
//  Paranormal
//

import Cocoa
import AppKit

class PreviewLayer: CCNode {

    var size: CGSize

    override init() {
        size = CCDirector.sharedDirector().viewSize()
        super.init()
        userInteractionEnabled = true
    }

    func createStaticExample() {
        var gemSprite: CCSprite = CCSprite(imageNamed:"gem-diffuse.png")
        resizeSpriteWithoutWarp(gemSprite, toWidth:Float(size.width),
            toHeight:Float(size.height))
        gemSprite.position = CGPointMake(size.width/2, size.height/2)
        gemSprite.opacity = 0.8

        var background: CCSprite = CCSprite(imageNamed:"checker.png")
        resizeSprite(background, toWidth:Float(size.width*2),
            toHeight:Float(size.height*2))
        var normalMap: CCSpriteFrame = CCSpriteFrame(
            textureFilename:"gem-normal.png",
            rectInPixels: CGRectMake(0, 0, size.width, size.height),
            rotated: false, offset: CGPointMake(0, 0), originalSize: size)
        var glassEffect: CCEffectGlass = CCEffectGlass(
            shininess: 0.1, refraction: 1, refractionEnvironment: background,
            reflectionEnvironment: background, normalMap:normalMap)
        gemSprite.effect = glassEffect
        self.addChild(background)
        self.addChild(gemSprite)
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
