//
//  AppDelegate.swift
//  Paranormal
//
//  Created by Scope on 10/11/14.
//  Copyright (c) 2014 spritebuilder. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window : WindowController!;
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // At this point, the main menu is automatically loaded
        // Load the Window and WindowController
        window = WindowController(windowNibName: "Application")
        window.loadWindow()
        window.showWindow(self);

        // TODO move this to a windowdidload or something
        // inside window controller
        window.setUpCocos()
        window.setUpEditor()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

