//
//  ImageEditorView.swift
//  Paranormal
//
//  Created by Diana Vermilya on 11/1/14.
//  Copyright (c) 2014 spritebuilder. All rights reserved.
//

import Foundation
import Cocoa
import AppKit


class ImageEditorView : NSImageView {

    @IBOutlet var delegate : NSResponder?

    override func mouseDown(theEvent: NSEvent) {
        delegate?.mouseDown(theEvent)
    }

    override func mouseDragged(theEvent: NSEvent) {
        delegate?.mouseDragged(theEvent)
    }

    override func mouseUp(theEvent: NSEvent) {
        delegate?.mouseUp(theEvent)
    }
}
