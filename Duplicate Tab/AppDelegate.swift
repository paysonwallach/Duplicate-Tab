//
//  AppDelegate.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/15/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    let mainWindowController = MainWindowController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController.showWindow(self)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
