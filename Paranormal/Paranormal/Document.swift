//
//  Document.swift
//  Paranormal
//
//  Created by Scope on 10/11/14.
//  Copyright (c) 2014 spritebuilder. All rights reserved.
//

import Cocoa

class Document: NSPersistentDocument {

    override init() {
        super.init()

        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.

    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }
}
