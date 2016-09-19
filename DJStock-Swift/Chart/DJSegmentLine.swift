//
//  DJSegmentLine.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/18.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class DJSegmentLine: UIView {
    
    let shapeLayer = CAShapeLayer()
    
    var lineWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var segments = [CGFloat]() {
        didSet {
            shapeLayer.lineDashPattern = [segments[0], segments[1] - segments[0], bounds.height - segments[1]]
            setNeedsDisplay()
        }
    }
    
    var lineColor = blackColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: (bounds.width - lineWidth) / 2, y: 0))
        path.addLineToPoint(CGPoint(x: (bounds.width - lineWidth) / 2, y: bounds.size.height))

        shapeLayer.fillColor = clearColor.CGColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = lineColor.CGColor
        shapeLayer.path = path.CGPath
        layer.addSublayer(shapeLayer)
    }
    
}
