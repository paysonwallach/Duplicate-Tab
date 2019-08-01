//
//  UserDefaults+isFirstLaunch.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 29/7/19.
//  Copyright © 2019 Payson Wallach. All rights reserved.
//

import Cocoa

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaults.standard.bool(
            forKey: AppDelegate.hasBeenLaunchedBeforeKeyPath
        )
        
        if isFirstLaunch {
            UserDefaults.standard.set(
                true,
                forKey: AppDelegate.hasBeenLaunchedBeforeKeyPath
            )
        }
        
        return isFirstLaunch
    }
}

