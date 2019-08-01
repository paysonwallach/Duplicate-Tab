//
//  main.swift
//  Duplicate Tab Update Helper
//
//  Created by Payson Wallach on 29.07.19.
//  Copyright © 2019 Payson Wallach. All rights reserved.
//

import Cocoa

autoreleasepool {
    let application = NSApplication.shared
    let delegate = AppDelegate()

    application.delegate = delegate
    application.run()
}
