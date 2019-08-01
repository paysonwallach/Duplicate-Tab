//
//  AppDelegate.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/15/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Cocoa
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Properties

    static let hasBeenLaunchedBeforeKeyPath = "HasBeenLaunchedBefore"

    let applicationName = Bundle.main.object(
        forInfoDictionaryKey: "CFBundleName") as! String
    let updateHelperBundleIdentifier = Bundle.main.object(
        forInfoDictionaryKey: "UpdateHelperBundleIdentifier") as! String

    var setupView: NSWindow!

    // MARK: - Class Methods

    func applicationWillFinishLaunching(_ notification: Notification) {
        let mainMenu = NSMenu(title: "MainMenu")

        var menuItem = mainMenu.addItem(withTitle: "Application",
                                        action: nil,
                                        keyEquivalent: "")
        var submenu = NSMenu(title: "Application")

        populateApplicationMenu(submenu)
        mainMenu.setSubmenu(submenu, for: menuItem)

        menuItem = mainMenu.addItem(withTitle: "Window",
                                    action: nil,
                                    keyEquivalent: "")
        submenu = NSMenu(title: NSLocalizedString("Window", comment: "Window menu"))
        populateWindowMenu(submenu)
        mainMenu.setSubmenu(submenu, for: menuItem)
        NSApp.windowsMenu = submenu

        menuItem = mainMenu.addItem(withTitle: "Help",
                                    action: nil,
                                    keyEquivalent: "")
        submenu = NSMenu(title: NSLocalizedString("Help", comment: "View menu"))
        populateHelpMenu(submenu)
        mainMenu.setSubmenu(submenu, for: menuItem)

        NSApp.mainMenu = mainMenu
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if UserDefaults.isFirstLaunch() {
            SMLoginItemSetEnabled(updateHelperBundleIdentifier as CFString,
                                  true)
        }

        launchUpdateHelper()

        presentSetupView()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    // MARK: - Main Menu

    func populateApplicationMenu(_ menu: NSMenu) {
        var title = NSLocalizedString("About", comment: "About menu item") + " " + applicationName
        var menuItem = menu.addItem(withTitle: title,
                                    action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                                    keyEquivalent: "")

        menu.addItem(NSMenuItem.separator())

        title = NSLocalizedString("Services", comment: "Services menu item")
        menuItem = menu.addItem(withTitle: title,
                                action: nil,
                                keyEquivalent: "")

        let servicesMenu = NSMenu(title: "Services")

        menu.setSubmenu(servicesMenu, for: menuItem)

        NSApp.servicesMenu = servicesMenu

        menu.addItem(NSMenuItem.separator())

        title = NSLocalizedString("Hide", comment: "Hide menu item") + " " + applicationName
        menuItem = menu.addItem(withTitle: title,
                                action: #selector(NSApplication.hide(_:)),
                                keyEquivalent: "h")

        title = NSLocalizedString("Hide Others", comment: "Hide Others menu item")
        menuItem = menu.addItem(withTitle: title,
                                action: #selector(NSApplication.hideOtherApplications(_:)),
                                keyEquivalent: "h")
        menuItem.keyEquivalentModifierMask = [.command, .option]

        title = NSLocalizedString("Show All", comment: "Show All menu item")
        menuItem = menu.addItem(withTitle: title,
                                action: #selector(NSApplication.unhideAllApplications(_:)),
                                keyEquivalent: "")

        menu.addItem(NSMenuItem.separator())

        title = NSLocalizedString("Quit", comment: "Quit menu item") + " " + applicationName
        menuItem = menu.addItem(withTitle: title,
                                action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q")
    }

    func populateWindowMenu(_ menu: NSMenu) {
        var title = NSLocalizedString("Minimize", comment: "Minimize menu item")
        menu.addItem(withTitle: title,
                     action: #selector(NSWindow.performMiniaturize(_:)),
                     keyEquivalent: "m")

        title = NSLocalizedString("Zoom", comment: "Zoom menu item")
        menu.addItem(withTitle: title,
                     action: #selector(NSWindow.performZoom(_:)),
                     keyEquivalent: "")

        menu.addItem(NSMenuItem.separator())

        title = NSLocalizedString("Bring All to Front", comment: "Bring All to Front menu item")
        menu.addItem(withTitle: title,
                     action: #selector(NSApplication.arrangeInFront(_:)),
                     keyEquivalent: "")
    }

    func populateHelpMenu(_ menu: NSMenu) {
        let title = applicationName + " " + NSLocalizedString("Help", comment: "Help menu item")

        menu.addItem(withTitle: title,
                     action: #selector(NSApplication.showHelp(_:)),
                     keyEquivalent: "?")
    }

    // MARK: - SetupView

    func presentSetupView() {
        setupView = SetupView()

        setupView.center()
        setupView.makeKeyAndOrderFront(NSApp)

        NSApp.activate(ignoringOtherApps: true)
    }

    // MARK: - Update Helper

    func launchUpdateHelper() {
        let updateHelperIsNotRunning =
            NSWorkspace.shared.runningApplications.filter {
                $0.bundleIdentifier == updateHelperBundleIdentifier
            }.isEmpty

        if updateHelperIsNotRunning {
            NSWorkspace.shared.launchApplication(
                withBundleIdentifier: updateHelperBundleIdentifier,
                options: [],
                additionalEventParamDescriptor: nil,
                launchIdentifier: nil
            )
        }
    }
}
