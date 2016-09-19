//
//  DJCurveLine.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/18.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class DJCurveLine: UIView {
    
    var points = [CGPoint]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var closeColor = RGB(red: 205, green: 223, blue: 250) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineColor = RGB(red: 72, green: 135, blue: 238) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isClose = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = clearColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard points.count > 1 else {
            return
        }
        let path = UIBezierPath()
        path.moveToPoint(points[0])
        for point in points {
            path.addLineToPoint(point)
        }
        path.lineWidth = lineWidth
        path.lineJoinStyle = .Round
        path.lineCapStyle = .Round
        lineColor.setStroke()
        path.stroke()
        
        if isClose {
            
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context)
            
            guard let clipPath = path.copy() as? UIBezierPath else {
                return
            }
            clipPath.addLineToPoint(CGPointMake(points[points.count - 1].x, rect.height))
            clipPath.addLineToPoint(CGPointMake(0, rect.height))
            clipPath.closePath()
            clipPath.addClip()
            closeColor.setFill()
            
            let p = UIBezierPath(rect: bounds)
            p.fill()
            
            CGContextSaveGState(context)
            
        }
        
    }
    
}
