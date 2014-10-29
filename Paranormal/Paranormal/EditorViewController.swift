//
//  EditorViewController.swift
//  Paranormal
//
//  Created by Diana Vermilya on 10/29/14.
//  Copyright (c) 2014 spritebuilder. All rights reserved.
//

import Foundation
import Cocoa

class EditorViewController : NSViewController {
    
    @IBOutlet weak var editor: NSImageView!
    override func awakeFromNib() {
        setUpEditor()
    }
    
    func setUpEditor() {
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        var cgContext = CGBitmapContextCreate(nil, UInt(300),
            UInt(400),  UInt(8),  UInt(300*4), colorSpace, bitmapInfo)
        CGContextSetRGBFillColor(cgContext, 1, 1, 0, 1)
        CGContextFillRect(cgContext, CGRectMake(0, 0, 300, 400))
        let image = CGBitmapContextCreateImage(cgContext!)
        editor.image = NSImage(CGImage: image, size: NSSize(width: 300 , height: 400) )
    }
    
    //touchesBeganWithEvent:
    //touchesMovedWithEvent:
    //touchesCancelledWithEvent:
    //touchesEndedWithEvent:
    
}
