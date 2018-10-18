//
//  SetupWindow.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/18/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Cocoa

class SetupWindow: NSWindow {
    convenience init() {
        let setupPageController = SetupPageController()
        self.init(contentViewController: setupPageController)
        
        title = ""
        styleMask = [.titled, .closable, .miniaturizable]
        titlebarAppearsTransparent = true
        center()
        makeKeyAndOrderFront(nil)
    }
}
