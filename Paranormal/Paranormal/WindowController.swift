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
    @IBOutlet weak var editor: NSImageView!
    @IBOutlet weak var previewView: NSView!

    @IBOutlet weak var glView: CCGLView!
    var preview : NSView?
    var cgContext : CGContextRef?

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

    func setUpEditor(){
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        cgContext = CGBitmapContextCreate(nil, UInt(300) , UInt(400) ,  UInt(8),  UInt(300*4), colorSpace, bitmapInfo)
        CGContextSetRGBFillColor(cgContext, 1, 1, 0, 1)
        CGContextFillRect(cgContext, CGRectMake(0, 0, 300, 400))
        let image = CGBitmapContextCreateImage(cgContext!)
        editor.image = NSImage(CGImage: image, size: NSSize(width: 300 , height: 400) )
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