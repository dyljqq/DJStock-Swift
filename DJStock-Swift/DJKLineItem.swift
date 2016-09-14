//
//  DJKLineItem.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

enum KLineColor {
    case Red, Green
    
    var description: UIColor {
        switch self {
        case .Red: return RGB(red: 205, green: 91, blue: 82)
        default: return RGB(red: 32, green: 165, blue: 51)
        }
    }
}

class DJKLineItem: UIView {
    
    var colorType = KLineColor.Red
    
    // item's position info, need tow point to draw...
    var points:[CGPoint] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = clearColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if points.count != 2 {
            return
        }
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: rect.width / 2, y: 0))
        path.addLineToPoint(CGPoint(x: rect.width / 2, y: points[0].y))
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        let clipPath = UIBezierPath(rect: CGRectMake(0, points[0].y, rect.width,  points[1].y - points[0].y))
        colorType.description.set()
        clipPath.addClip()
        
        let rectPath = UIBezierPath(rect: bounds)
        rectPath.fill()
        
        CGContextRestoreGState(context)
        
        path.moveToPoint(CGPointMake(rect.width / 2, points[1].y))
        path.addLineToPoint(CGPointMake(rect.width / 2, rect.height))
        path.closePath()
        
        path.lineWidth = 0.5
        colorType.description.set()
        
        path.stroke()
        
    }
    
}
