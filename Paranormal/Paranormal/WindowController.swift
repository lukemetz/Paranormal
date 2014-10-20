//
//  WindowController.swift
//  Paranormal
//
//  Created by Luke Scope on 10/16/14.
//  Copyright (c) 2014 spritebuilder. All rights reserved.
//


import Foundation
import Cocoa

class WindowController: NSWindowController {
    @IBOutlet weak var previewView: NSView!

    @IBOutlet weak var glView: CCGLView!
    var preview : NSView?

    override init(window: NSWindow?) {
        super.init(window:window)
        // Get view out of PreviewSettings nib
        var array : NSArray?;
        let bool = NSBundle.mainBundle().loadNibNamed("PreviewSettings",
            owner: self, topLevelObjects: &array)

        if bool && array != nil {
            for view in array! {
                if view is NSView {
                    preview = view as? NSView
                }
            }
        }
    }

    func setUpCocos() {
        // Set up Cocos2d
        let director = CCDirector.sharedDirector() as CCDirector!;
        director.setView(glView);

        let scene = TestScene();
        director.runWithScene(scene);
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if preview != nil && previewView != nil {
            previewView?.addSubview(preview!)

            // Place the view at the top
            let rect : NSRect! = preview?.frame
            let container : NSRect! = previewView?.frame
            preview?.frame = NSRect(x: 0,
                                    y: container.height - rect.height,
                                width: rect.width,
                               height: rect.height)
        }
    }

    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }

    override init()
    {
        super.init()
    }

    override var document : AnyObject? {
        set(document) {
            // Tear down UI or something
            super.document = document
            // Update the UI
        }

        get {
            return super.document
        }
    }
}