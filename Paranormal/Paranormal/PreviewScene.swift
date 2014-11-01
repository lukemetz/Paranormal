//
//  PreviewScene.swift
//  Paranormal
//
//  Created by Kevin O'Toole on 11/1/14.
//  Copyright (c) 2014 spritebuilder. All rights reserved.
//

import Cocoa
import AppKit

class PreviewScene: CCScene {
    
    var size: CGSize
    
    override init()
    {
        size = CCDirector.sharedDirector().viewSize()
        super.init()
        userInteractionEnabled = true
        createStaticExample()
    }
    
    func createStaticExample()
    {
        var gemSprite: CCSprite = CCSprite(imageNamed:"gem-diffuse.png")
        resizeSpriteWithoutWarp(gemSprite, toWidth:Float(size.width/2), toHeight:Float(size.height/2))
        gemSprite.position = CGPointMake(size.width/4, size.height/4)
        gemSprite.opacity = 0.8
        
        var background: CCSprite = CCSprite(imageNamed:"checker.png")
        resizeSprite(background, toWidth:Float(size.width), toHeight:Float(size.height))
        var normalMap: CCSpriteFrame = CCSpriteFrame(textureFilename:"gem-normal.png", rectInPixels: CGRectMake(0, 0, size.width, size.height), rotated: false, offset: CGPointMake(0, 0), originalSize: size)
        var glassEffect: CCEffectGlass = CCEffectGlass(shininess: 0.1, refraction: 0.9, refractionEnvironment: background, reflectionEnvironment: background, normalMap:normalMap)
        gemSprite.effect = glassEffect
        self.addChild(background)
        self.addChild(gemSprite)
    }
    
    func ccKeyDown(event: NSEvent) -> Bool
    {
        NSLog("key down: %@", event.characters!)
//        if (event.modifierFlags & NSNumericPadKeyMask){}
//        { // arrow keys have this mask
//            arrow: NSString = event.charactersIgnoringModifiers
//            keyChar: unichar = 0
//        }
//        if ( [theArrow length] == 0 )
//        return YES;            // reject dead keys
//        if ( [theArrow length] == 1 ) {
//        keyChar = [theArrow characterAtIndex:0];
//        if ( keyChar == NSLeftArrowFunctionKey ) {
//        CCLOG(@"Left Arrow pressed");
//                    CGPoint movePosition = ccp(-1,0);
//                    [self movePenguin:movePosition];
//        return YES;
//        }
//        if ( keyChar == NSRightArrowFunctionKey ) {
//        CCLOG(@"Right Arrow pressed");
//                    CGPoint movePosition = ccp(1,0);
//                    [self movePenguin:movePosition];
//                    return YES;
//    }
//    if ( keyChar == NSUpArrowFunctionKey ) {
//				CCLOG(@"Up Arrow Pressed");
//				CGPoint movePosition = ccp(0,1);
//				[self movePenguin:movePosition];
//				
//    return YES;
//    }
//    if ( keyChar == NSDownArrowFunctionKey ) {
//				CGPoint movePosition = ccp(0,-1);
//				[self movePenguin:movePosition];
//				CCLOG(@"Down Arrow Pressed");
//    return YES;
//    }
//    }
//    }
//    return NO;
        return true
    }

    
    // This should be moved to a move logical place
    func resizeSprite(sprite: CCSprite, toWidth: Float, toHeight: Float)
    {
        sprite.scaleX = toWidth / Float(sprite.contentSize.width)
        sprite.scaleY = toHeight / Float(sprite.contentSize.height)
    }
    
    func resizeSpriteWithoutWarp(sprite: CCSprite, toWidth: Float, toHeight: Float)
    {
        let scale = min(toWidth / Float(sprite.contentSize.width),
                        toHeight / Float(sprite.contentSize.height))
        sprite.scaleX = scale
        sprite.scaleY = scale
    }
    
    override func onEnter()
    {
        super.onEnter()
    }
    
    override func onExit()
    {
        super.onExit()
    }
}
