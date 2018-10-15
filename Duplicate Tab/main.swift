//
//  main.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/15/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Cocoa

autoreleasepool {
    let application = NSApplication.shared
    let delegate = AppDelegate()

    application.delegate = delegate
    application.run()
}
