//
//  PreviewScene.swift
//  Paranormal
//
//  Created by Kevin O'Toole on 11/1/14.
//  Copyright (c) 2014 spritebuilder. All rights reserved.
//

import Cocoa

class PreviewScene: CCScene {
    
    override init()
    {
        super.init()
        
        userInteractionEnabled = true
        
        var background:CCNodeColor = CCNodeColor(color:
            CCColor(red: 0.2, green: 0.2, blue: 0.8, alpha: 1.0))
        addChild(background)
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
