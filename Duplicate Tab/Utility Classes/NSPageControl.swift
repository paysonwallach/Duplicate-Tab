//
//  NSPageControl.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/16/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Cocoa

class NSPageControl: NSView {
    
    // MARK: - Properties
    
    var numberOfPages = 0 {
        didSet {
            drawPageControls()
        }
    }
    var currentPage = 0 {
        didSet (previousValue) {
            if currentPage < 0 {
                currentPage = 0
            }

            if currentPage > numberOfPages - 1 {
                currentPage = numberOfPages - 1
            }
            
            didSetCurrentPage(previousValue, newlySelectedPage: currentPage)
        }
    }
    
    var hideForSinglePage = true
    var indicatorTintColor: NSColor
    var currentPageIndicatorTintColor: NSColor
    var animationDuration: TimeInterval = 0.04
    var indicatorDiameter: CGFloat = 8.0
    var indicatorMargin: CGFloat = 2.0
    
    private var indicatorLayers: [CAShapeLayer] = []
    
    // MARK: - Override methods
    
    override init(frame frameRect: NSRect) {
        let defaultIndicatorTintColor = NSColor.lightGray
        let defaultCurrentPageIndicatorTintColor = NSColor.darkGray
        
        if #available (OSX 10.13, *) {
            indicatorTintColor = NSColor(named: "pageIndicator") ?? defaultIndicatorTintColor
            currentPageIndicatorTintColor = NSColor(named: "currentPageIndicator") ?? defaultCurrentPageIndicatorTintColor
        } else {
            indicatorTintColor = defaultCurrentPageIndicatorTintColor
            currentPageIndicatorTintColor = defaultCurrentPageIndicatorTintColor
        }
        
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        indicatorTintColor = decoder.decodeObject(forKey: "indicatorTintColor") as! NSColor
        currentPageIndicatorTintColor = decoder.decodeObject(forKey: "currentPageIndicatorTintColor") as! NSColor
        
        super.init(coder: decoder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        for i in 0..<numberOfPages {
            let fillColor = (i == currentPage) ? currentPageIndicatorTintColor : indicatorTintColor
            let shapeLayer = indicatorLayers[i]
            
            shapeLayer.fillColor = fillColor.cgColor
        }
    }
    
    // MARK: - Private Methods
    
    private func drawPageControls() {
        let indicatorWidthSum = indicatorDiameter * CGFloat(numberOfPages)
        let marginWidthSum = indicatorMargin * CGFloat(numberOfPages - 1)
        let minimumWidth = indicatorWidthSum + marginWidthSum
        
        frame = NSRect(x: 0, y: 0, width: minimumWidth, height: indicatorDiameter)
        
        indicatorLayers = []
        self.layer = CAShapeLayer()
        self.wantsLayer = true
        
        for i in 0..<numberOfPages {
            let x = (indicatorDiameter + indicatorMargin) * CGFloat(i)
            let y = frame.height - indicatorDiameter
            let rect = NSRect(x: x, y: y, width: indicatorDiameter, height: indicatorDiameter)
            let path = CGMutablePath()
            
            path.addEllipse(in: rect)
            
            let fillColor = (i == currentPage) ? currentPageIndicatorTintColor : indicatorTintColor
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.frame = rect
            shapeLayer.path = path
            shapeLayer.fillColor = fillColor.cgColor
            
            guard let layer = layer else {
                return
            }
            
            layer.addSublayer(shapeLayer)
            indicatorLayers.append(shapeLayer)
        }
    }
    
    private func didSetCurrentPage(_ selectedPage: Int, newlySelectedPage: Int) {
        if selectedPage == newlySelectedPage {
            return
        }
        
        let previousPageAnimation = fillColorAnimation(with: indicatorTintColor)
        let nextPageAnimation = fillColorAnimation(with: currentPageIndicatorTintColor)
        
        indicatorLayers[selectedPage].add(previousPageAnimation, forKey: "previousPageAnimation")
        indicatorLayers[newlySelectedPage].add(nextPageAnimation, forKey: "nextPageAnimation")
    }
    
    private func fillColorAnimation(with color: NSColor) -> CABasicAnimation {
        let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
        
        fillColorAnimation.toValue = color.cgColor
        fillColorAnimation.duration = animationDuration
        fillColorAnimation.fillMode = CAMediaTimingFillMode.forwards
        fillColorAnimation.isRemovedOnCompletion = false
        
        return fillColorAnimation
    }
}
