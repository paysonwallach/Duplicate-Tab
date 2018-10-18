//
//  SetupPageController.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/15/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Cocoa

class SetupPageController: NSPageController {
    let width: CGFloat = 600
    let height: CGFloat = 400
    let objectsArray: NSArray
    let pageControl = NSPageControl()
    let nextButton = NSButton()
    let prevButton = NSButton()
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        objectsArray = NSArray(arrayLiteral:
            (image: NSImage.init(named: "page-1")!,
             caption: "1. Open Safari Preferences"),
            (image: NSImage.init(named: "page-2")!,
             caption: "2. Go to the \"Extensions\" tab"),
            (image: NSImage.init(named: "page-3")!,
             caption: "3. Select \"Duplicate Tab\""))
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        objectsArray = coder.decodeObject(forKey: "objectsArray") as! NSArray
        super.init(coder: coder)
    }
    
    override func loadView() {
        let frame = NSRect(x: 0, y: 0, width: width, height: height)
        
        view = NSView(frame: frame)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.title = "Next"
        nextButton.bezelStyle = .rounded
        nextButton.action = #selector(navigateForward(_:))
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        prevButton.title = "Prev"
        prevButton.isEnabled = false
        prevButton.bezelStyle = .rounded
        prevButton.action = #selector(navigateBack(_:))
        prevButton.translatesAutoresizingMaskIntoConstraints = false
 
        delegate = self
        arrangedObjects = objectsArray as! [Any]
        transitionStyle = .horizontalStrip

        pageControl.numberOfPages = 3
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageControl)
        view.addConstraints([
            NSLayoutConstraint(item: pageControl, attribute: .width, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1.0, constant: 48),
            NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: view,
                               attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: view,
                               attribute: .bottom, multiplier: 1.0, constant: -32)
            ])
        
        view.addSubview(prevButton)
        view.addConstraints([
            NSLayoutConstraint(item: prevButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 44),
            NSLayoutConstraint(item: prevButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -24)
            ])
        
        view.addSubview(nextButton)
        view.addConstraints([
            NSLayoutConstraint(item: nextButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -44),
            NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -24)
            ])
    }
}

extension SetupPageController: NSPageControllerDelegate {
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        let caption = (object as! (image: NSImage, caption: String)).caption
        let index = Int("\(caption.first!)")! - 1
        
        return "\(index)"
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        guard let index = Int(identifier) else {
            fatalError()
        }
        
        let content = objectsArray[index] as! (image: NSImage, caption: String)
        let setupViewController = SetupViewController()
        
        setupViewController.image = content.image
        setupViewController.caption = content.caption
        return setupViewController
    }
    
    func pageController(_ pageController: NSPageController, didTransitionTo object: Any) {
        let caption = (object as! (image: NSImage, caption: String)).caption
        let index = Int("\(caption.first!)")! - 1
        
        if index == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
        
        if index == objectsArray.index(of: objectsArray.lastObject) {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        pageControl.currentPage = index
    }
    
    func pageControllerDidEndLiveTransition(_ pageController: NSPageController) {
        self.completeTransition()
    }
}
