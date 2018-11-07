//
//  SafariExtensionHandler.swift
//  Duplicate-Tab-Button
//
//  Created by Payson Wallach on 10/13/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    override func contextMenuItemSelected(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil) {
        if command == "duplicate-tab" {
            page.getPropertiesWithCompletionHandler({ properties in
                guard let properties = properties else {
                    Logs.shared.error("Unable to get reference to page properties")
                    return
                }
                
                guard let url = properties.url else {
                    Logs.shared.error("Unable to get reference to url")
                    return
                }
                
                SFSafariApplication.getActiveWindow(completionHandler: { window in
                    guard let window = window else {
                        return
                    }
                    
                    window.openTab(with: url, makeActiveIfPossible: true) { _ in
                        return
                    }
                })
            })
        }
    }
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]? = nil) {
        if messageName == "updateScrollPosition" {
            UserDefaults.standard.set(userInfo, forKey: "scrollPosition")
        } else if let scrollPosition = UserDefaults.standard.object(forKey: "scrollPosition") as? [String : Any] {
            page.dispatchMessageToScript(withName: "setScrollPositions", userInfo: scrollPosition)
        } else {
            Logs.shared.error("Unable to get reference to scroll position")
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        getURL(in: window) { url in
            guard let url = url else {
                Logs.shared.error("Unable to get reference to url")
                return
            }
            
            window.openTab(with: url, makeActiveIfPossible: true) { _ in
                return
            }
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping (Bool, String) -> Void) {
        getURL(in: window) { url in
            if url == nil {
                validationHandler(false, "")
            } else {
                validationHandler(true, "")
            }
        }
    }
    
    override func validateContextMenuItem(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil, validationHandler: @escaping (Bool, String?) -> Void) {
        page.getPropertiesWithCompletionHandler { properties in
            guard let properties = properties else {
                return
            }
            
            if properties.url == nil {
                validationHandler(true, nil)
            } else {
                validationHandler(false, nil)
            }
        }
    }
    
    private func getURL(in window: SFSafariWindow, completionHandler: @escaping (URL?) -> Void) {
        window.getActiveTab { tab in
            guard let tab = tab else {
                return
            }
            
            tab.getActivePage(completionHandler: { page in
                guard let page = page else {
                    Logs.shared.error("Unable to get reference to page")
                    return
                }
                
                page.getPropertiesWithCompletionHandler({ properties in
                    guard let properties = properties else {
                        Logs.shared.error("Unable to get reference to page properties")
                        return
                    }
                    
                    completionHandler(properties.url)
                })
            })
        }
    }
}
