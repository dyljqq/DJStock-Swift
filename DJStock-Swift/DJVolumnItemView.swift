//
//  VolumnView.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/14.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class DJVolumnItemView: UIView {
    
    var lineWidth: CGFloat = 0.5 { didSet { setNeedsDisplay() } }
    var volumnColor = KLineColor.Red { didSet { setNeedsDisplay() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = clearColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let path = UIBezierPath(rect: rect)
        path.lineWidth = lineWidth
        volumnColor.description.setFill()
        path.fill()
    }
}
