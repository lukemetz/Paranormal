//
//  EditorViewController.swift
//  Paranormal
//
//  Created by Diana Vermilya on 10/29/14.
//  Copyright (c) 2014 spritebuilder. All rights reserved.
//

import Foundation
import Cocoa
import AppKit

class EditorViewController : NSViewController {
    
    @IBOutlet weak var editor: NSImageView!
    @IBOutlet weak var tempEditor: NSImageView!
    var context : CGContext!
    var mouseSwiped : Bool?
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var red : CGFloat = 0.0/255.0;
    var green : CGFloat =  0.0/255.0;
    var blue : CGFloat =  0.0/255.0;
    var brush : CGFloat = 10.0;
    var opacity : CGFloat = 1.0;
    

    
    
    
    override func awakeFromNib() {
        setUpEditor()
        println("initialized")
    }
    
    func setUpEditor() {
        var width = editor.frame.size.width
        var height = editor.frame.size.height
        
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        
        var cgContext = CGBitmapContextCreate(nil, UInt(width),
            UInt(height),  UInt(8),  UInt(width*4), colorSpace, bitmapInfo)
        CGContextSetRGBFillColor(cgContext, 1, 1, 0, 1)
        //CGContextFillRect(cgContext, CGRectMake(0, 0, width, height))
        let image = CGBitmapContextCreateImage(cgContext!)
        

        
        editor.image = NSImage(CGImage: image, size: NSSize(width: width , height: height) )
        tempEditor.image = NSImage(CGImage: image, size: NSSize(width: width , height: height) )

        context = CGBitmapContextCreate(nil, UInt(width),
            UInt(height),  UInt(8),  UInt(width*4), colorSpace, bitmapInfo)
        
    }
    
    
    override func mouseDown(theEvent: NSEvent) {
        println("mouse down!")
        mouseSwiped = false
        lastPoint = theEvent.locationInWindow
        println(lastPoint)
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        var width = editor.frame.size.width
        var height = editor.frame.size.height
        
        context = CGBitmapContextCreate(nil, UInt(width),
            UInt(height),  UInt(8),  UInt(width*4), colorSpace, bitmapInfo)
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        println("dragged")
        mouseSwiped = true
        var currentPoint : CGPoint = theEvent.locationInWindow
        println(currentPoint)
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

//        var cgContext = CGBitmapContextCreate(nil, UInt(self.view.frame.size.width),
//            UInt(self.view.frame.size.height),  UInt(8),  UInt(300*4), colorSpace, bitmapInfo)
        CGContextMoveToPoint(context, lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y)
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, brush)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        CGContextStrokePath(context)
        println(CGBitmapContextGetBitmapInfo(context).rawValue)
        
        var image = CGBitmapContextCreateImage(context!)
        
        var width = editor.frame.size.width
        var height = editor.frame.size.height
        
        //editor.image = NSImage(CGImage: image, size: NSSize(width: width , height: height) )
        tempEditor.image = NSImage(CGImage: image, size: NSSize(width: width , height: height) )

        lastPoint = currentPoint
        
    }
    
    override func mouseUp(theEvent: NSEvent) {
        println("UP")
        
        
    }
    
    //touchesMovedWithEvent:
    //touchesCancelledWithEvent:
    //touchesEndedWithEvent:
    
}
