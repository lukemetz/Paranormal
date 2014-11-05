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
    var editorContext : CGContext!
    var tempContext : CGContext!
    var mouseSwiped : Bool = false
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
        
        editorContext = CGBitmapContextCreate(nil, UInt(width),
            UInt(height),  UInt(8),  0 , colorSpace, bitmapInfo)
        CGContextSetFillColorWithColor(editorContext, CGColorCreateGenericRGB(0, 0, 1, 0))
        CGContextFillRect(editorContext, CGRectMake(0, 0, width, height))
        
        let image = CGBitmapContextCreateImage(editorContext!)

        tempContext = CGBitmapContextCreate(nil, UInt(width),
            UInt(height),  UInt(8),  0, colorSpace, bitmapInfo)
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
        
        tempContext = CGBitmapContextCreate(nil, UInt(width),
            UInt(height),  UInt(8),  0, colorSpace, bitmapInfo)
        CGContextSetFillColorWithColor(tempContext, CGColorCreateGenericRGB(0, 0, 1, 0))
        CGContextFillRect(tempContext, CGRectMake(0, 0, width, height))
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        println("dragged")
        mouseSwiped = true
        var currentPoint : CGPoint = theEvent.locationInWindow
        println(currentPoint)
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)

        CGContextMoveToPoint(tempContext, lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(tempContext, currentPoint.x, currentPoint.y)
        CGContextSetLineCap(tempContext, kCGLineCapRound)
        CGContextSetLineWidth(tempContext, brush)
        CGContextSetRGBStrokeColor(tempContext, red, green, blue, 1.0)
        CGContextSetBlendMode(tempContext, kCGBlendModeNormal)
        
        CGContextStrokePath(tempContext)
        println(CGBitmapContextGetBitmapInfo(tempContext).rawValue)
        
        var image = CGBitmapContextCreateImage(tempContext!)
        
        var width = editor.frame.size.width
        var height = editor.frame.size.height
        
        //editor.image = NSImage(CGImage: image, size: NSSize(width: width , height: height) )
        tempEditor.image = NSImage(CGImage: image, size: NSSize(width: width , height: height) )

        lastPoint = currentPoint
        
    }
    
    override func mouseUp(theEvent: NSEvent) {
        println("UP")
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        var width = editor.frame.size.width
        var height = editor.frame.size.height
        var currentPoint : CGPoint = theEvent.locationInWindow

        var rect = CGRectMake(0, 0, width, height)
        var image = CGBitmapContextCreateImage(tempContext)
        CGContextDrawImage(editorContext, rect, image)
//        var tempLayer = CGLayerCreateWithContext(tempContext, CGSizeMake(width, height), nil)
//        CGContextDrawLayerInRect(editorContext, rect, tempLayer)
//        CGContextDrawLayerAtPoint(editorContext, CGPointMake(100, 100), tempLayer)
//        InRect(editorContext, CGRectMake(30, 30, width+30, height+30), tempLayer)


        let editorImage = CGBitmapContextCreateImage(editorContext!)
        editor.image = NSImage(CGImage: editorImage, size: NSSize(width: width , height: height) )
        tempEditor.image = nil

    }

    
}
