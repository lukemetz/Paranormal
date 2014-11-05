//
//  PreviewView.swift
//  Paranormal
//
//  Created by Kevin O'Toole on 11/4/14.
//  Copyright (c) 2014 spritebuilder. All rights reserved.
//

import Cocoa

class PreviewView: CCGLView {

    var director: CCDirector!

    required init?(coder:NSCoder)
    {
        director = CCDirector.sharedDirector()
        super.init(coder:coder)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }

    override func keyDown(event: NSEvent)
    {
        NSLog("view key down: \(event.keyCode)")
        if let scene: PreviewScene = director.runningScene as? PreviewScene
        {
            scene.keyDown(event)
        }
    }

    override func mouseDown(event: NSEvent)
    {
        NSLog("Mouse down")
    }
}
