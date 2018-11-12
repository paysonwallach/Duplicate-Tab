//
//  SetupView.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/25/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Cocoa
import Cartography
import SafariServices

class SetupView: NSWindow {
    let screenshotWidth: CGFloat = 300
    let screenshotHeight: CGFloat = 169
    let padding: CGFloat = 48

    convenience init() {
        self.init(contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
                  styleMask: [.titled, .closable, .miniaturizable],
                  backing: .buffered,
                  defer: false)

        let view = NSView()
        let screenshotView: NSImageView
        guard let screenshot = NSImage(named: "screenshot") else {
            fatalError("Unable to instantiate screenshot object")
        }

        screenshotView = NSImageView(image: screenshot)

        view.addSubview(screenshotView)
        constrain(screenshotView) { screenshotView  in
            screenshotView.width == screenshotWidth
            screenshotView.height == screenshotHeight
            screenshotView.centerX == screenshotView.superview!.centerX
            screenshotView.top == screenshotView.superview!.top + padding
        }

        let captionView = NSLabel()
        let captionFontSize: CGFloat = 16
        let captionViewMaxWidth: CGFloat = 350
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center

        let captionText = NSAttributedString(string: "Select \"Duplicate Tab\" in the \"Extensions\" tab of Safari Preferences to activate.",
                                             attributes: [
                                                NSAttributedString.Key.foregroundColor: NSColor.textColor,
                                                NSAttributedString.Key.font: NSFont.systemFont(ofSize: captionFontSize),
                                                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])
        let boundingRect = captionText.boundingRect(with: NSSize(width: captionViewMaxWidth,
                                                                 height: .greatestFiniteMagnitude),
                                                      options: .usesLineFragmentOrigin)

        captionView.attributedText = captionText
        captionView.preferredMaxLayoutWidth = captionViewMaxWidth

        view.addSubview(captionView)
        constrain(captionView, screenshotView) { labelView, screenshotView in
            labelView.width == ceil(boundingRect.width)
            labelView.height == ceil(boundingRect.height)
            labelView.centerX == labelView.superview!.centerX
            labelView.top == screenshotView.bottom + padding
        }

        let openExtensionsButtonTitle = "Open Safari Preferences"
        let openExtensionsButton = NSButton(title: openExtensionsButtonTitle,
                                            target: self,
                                            action: #selector(showExtensionsPreferences))

        view.addSubview(openExtensionsButton)
        constrain(captionView, openExtensionsButton) { labelView, openExtensionsButton in
            labelView.bottom == openExtensionsButton.top - padding
            openExtensionsButton.centerX == openExtensionsButton.superview!.centerX
            openExtensionsButton.bottom == openExtensionsButton.superview!.bottom - padding
        }

        self.titlebarAppearsTransparent = true
        self.contentView = view
    }

    @objc func showExtensionsPreferences() {
        let extensionBundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "Extension bundle identifier") as! String

        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier, completionHandler: nil)
    }
}
