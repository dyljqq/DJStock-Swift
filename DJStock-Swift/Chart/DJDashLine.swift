//
//  DJDashLine.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

enum DashLineType {
    case Vertical, Horizontal, Rectangle
}

class DJDashLine: UIView {
    
    var lineWidth: CGFloat = 0.5
    var dashLineColor = lineColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: bounds.size.height / 2))
        path.addLineToPoint(CGPoint(x: bounds.width, y: bounds.size.height / 2))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = clearColor.CGColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = dashLineColor.CGColor
        shapeLayer.path = path.CGPath
        shapeLayer.lineDashPattern = [2]
        layer.addSublayer(shapeLayer)
    }
}
