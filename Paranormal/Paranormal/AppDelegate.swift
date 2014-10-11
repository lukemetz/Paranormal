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


    @IBOutlet weak var glview: CCGLView!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application

        let director = CCDirector.sharedDirector() as CCDirector!;
        director.setView(self.glview);

        let scene = TestScene();
        director.runWithScene(scene);
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

