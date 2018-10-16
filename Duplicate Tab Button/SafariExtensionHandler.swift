//
//  SafariExtensionHandler.swift
//  Duplicate-Tab-Button
//
//  Created by Payson Wallach on 10/13/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    override func toolbarItemClicked(in window: SFSafariWindow) {
        getURL(in: window) { (url) in
            guard let url = url else {
                return
            }
            
            window.openTab(with: url, makeActiveIfPossible: false, completionHandler: { _ in
                return
            })
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping (Bool, String) -> Void) {
        getURL(in: window) { (url) in
            if url != nil {
                validationHandler(true, "")
            } else {
                validationHandler(false, "")
            }
        }
    }
    
    private func getURL(in window: SFSafariWindow, completionHandler: @escaping (URL?) -> Void) {
        window.getActiveTab { (tab) in
            guard let tab = tab else {
                return
            }
            
            tab.getActivePage(completionHandler: { (activePage) in
                guard let activePage = activePage else {
                    return
                }
                
                activePage.getPropertiesWithCompletionHandler({ (properties) in
                    guard let properties = properties else {
                        return
                    }
                    
                    completionHandler(properties.url)
                })
            })
        }
    }
}
