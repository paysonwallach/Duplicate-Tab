//
//  SetupViewController.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/15/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Cocoa

class SetupViewController: NSViewController {
    let width: CGFloat = 600
    let height: CGFloat = 400
    let padding: CGFloat = 48

    var image: NSImage? = nil
    var caption = ""

    override func loadView() {
        let frame = NSRect(x: 0, y: 0, width: width, height: height)

        self.view = NSView(frame: frame)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = image else {
            return
        }

        let captionLabel = NSLabel()
        let imageView = NSImageView(image: image)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1.0, constant: 300),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1.0, constant: 169),
            NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view,
                               attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view,
                               attribute: .top, multiplier: 1.0, constant: 42)
            ])

        captionLabel.text = caption
        captionLabel.textAlignment = .center
        captionLabel.font = NSFont.systemFont(ofSize: 16)
        captionLabel.shadowOffset = .zero

        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captionLabel)
        view.addConstraints([
            NSLayoutConstraint(item: captionLabel, attribute: .width, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1.0, constant: 300),
            NSLayoutConstraint(item: captionLabel, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1.0, constant: 20),
            NSLayoutConstraint(item: captionLabel, attribute: .centerX, relatedBy: .equal, toItem: view,
                               attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: captionLabel, attribute: .top, relatedBy: .equal, toItem: imageView,
                               attribute: .bottom, multiplier: 1.0, constant: padding)
            ])
    }

}
