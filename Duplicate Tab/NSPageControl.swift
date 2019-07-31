//
//  NSPageControl.swift
//  Duplicate Tab
//
//  Created by Payson Wallach on 10/16/18.
//  Copyright © 2018 Payson Wallach. All rights reserved.
//

import Cocoa

protocol NSPageControlDelegate: class {
    func onClick(_ sender: Int)
}

class NSPageControl: NSView {
    var numberOfPages = 0
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
    var indicatorTintColor = NSColor.pageIndicator!
    var currentPageIndicatorTintColor = NSColor.currentPageIndicator!
    var animationDuration: TimeInterval = 0.04
    var indicatorRadius: CGFloat = 8.0
    var indicatorMargin: CGFloat = 12.0

    private var indicatorLayers: [CAShapeLayer] = []

    weak var delegate: NSPageControlDelegate?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let indicatorWidthSum = indicatorRadius * CGFloat(numberOfPages)
        let marginWidthSum = indicatorMargin * CGFloat(numberOfPages - 1)
        let minimumWidth = indicatorWidthSum + marginWidthSum

        indicatorLayers = []
        self.layer = CAShapeLayer()
        self.wantsLayer = true

        for i in 0..<numberOfPages {
            let minX = (dirtyRect.width - minimumWidth) / 2
            let indexOffset = (indicatorRadius + indicatorMargin) * CGFloat(i)
            let verticalCenter = (dirtyRect.height - indicatorRadius)
            let x = minX + indexOffset
            let y = verticalCenter - indicatorRadius / 2
            let rect = NSRect(x: x, y: y, width: indicatorRadius, height: indicatorRadius)
            let cgPath = CGMutablePath()

            cgPath.addEllipse(in: rect)

            let fillColor = (i == currentPage) ? currentPageIndicatorTintColor : indicatorTintColor
            let shapeLayer = CAShapeLayer()

            shapeLayer.path = cgPath
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
