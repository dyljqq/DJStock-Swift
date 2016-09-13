//
//  KLine.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

// each item's position infomation
struct KLineItemPosition {
    var y: CGFloat
    var height: CGFloat
    var points: [CGPoint]
}

class DJKLine: UIView {
    
    struct Constant {
        static let dashLineNum = 3
    }
    
    var kLineWidth: CGFloat = 5.0
    var marginX: CGFloat = 1.0
    
    private var xLabels = [UILabel]()
    private var yLabels = [UILabel]()
    
    lazy var backView: UIView = {
        let width = self.bounds.size.width - 2 * self.marginX
        let view = UIView(frame: CGRectMake(self.marginX, 50, width, 2 * width / 3))
        view.backgroundColor = whiteColor
        
        view.layer.borderColor = lineColor.CGColor
        view.layer.borderWidth = 1.0
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = clearColor
        addSubview(self.backView)
        
        let spaceY = backView.frame.size.height / CGFloat(Constant.dashLineNum + 1)
        var y = spaceY
        for _ in 0..<Constant.dashLineNum {
            backView.addSubview(DJDashLine(frame: CGRectMake(0, y, backView.frame.size.width, 1.0)))
            y += spaceY
        }
        
        y = 0
        for index in 0..<Constant.dashLineNum + 2  {
            let label = UILabel(frame: CGRectMake(0, y, 100, 11))
            label.textColor = blackColor
            label.font = font(fontSize: 10)
            backView.addSubview(label)
            
            yLabels.append(label)
            y += spaceY
            
            if index == 0 {
                y -= label.frame.height
            }
            
        }
        
        for index in 0..<2 {
            let label = UILabel(frame: CGRectMake(marginX, CGRectGetMaxY(backView.frame), 100, 11))
            label.textColor = blackColor
            label.font = font(fontSize: 10)
            addSubview(label)
            
            xLabels.append(label)
            
            label.snp_makeConstraints { make in
                make.top.equalTo(backView.snp_bottom)
                if index == 0 {
                    make.left.equalTo(backView)
                } else {
                    make.right.equalTo(backView)
                }
            }
        }
        
    }
    
    func update(array: [KLineModel]) {
        
        let h = self.backView.frame.height
        var count = Int(backView.frame.size.width / (kLineWidth + marginX))
        var start = array.count - count
        if start < 0 {
            start = 0
            count = array.count
        }
        count = count + start
        
        var mx = DBL_MIN
        var mn = DBL_MAX
        for index in start..<count {
            let kLineModel = array[index]
            mx = max(mx, kLineModel.maxPrice)
            mn = min(mn, kLineModel.minPrice)
        }
        
        let rate = CGFloat(mx - mn) / h
        
        var positions = [KLineItemPosition]()
        for index in start..<count {
            let kLineModel = array[index]
            let y1 = CGFloat(mx - kLineModel.maxPrice) / rate
            let y2 = CGFloat(mx - kLineModel.minPrice) / rate
            let height = abs(y2 - y1)
            let points = [CGPoint(x: 0, y: CGFloat(kLineModel.maxPrice - kLineModel.closePrice) / rate), CGPoint(x: 0, y: CGFloat(kLineModel.maxPrice - kLineModel.openPrice) / rate)]
            let position = KLineItemPosition(y: y1, height: height, points: points)
            print("y: \(position.y), height: \(position.height)")
            positions.append(position)
        }
        updateKLine(positions)
        
        let diff = (mx - mn) / Double(Constant.dashLineNum + 1)
        for (index,label) in yLabels.enumerate() {
            label.text = "\(mx - diff * Double(index))"
        }
        
        let xP: Int = (array.count - 1) / (xLabels.count - 1)
        for (index, label) in xLabels.enumerate() {
            let model = array[index * xP]
            label.text = model.time
        }
    }
    
    func updateKLine(kLineItemPosition: [KLineItemPosition]) {
        var index = 0
        var x = marginX
        for item in kLineItemPosition {
            var kLineItem = viewWithTag(index + 8888) as? DJKLineItem
            if kLineItem == nil {
                kLineItem = DJKLineItem(frame: CGRectMake(x, item.y, kLineWidth, item.height))
            }
            kLineItem!.points = item.points
            kLineItem!.tag = index + 8888
            backView.addSubview(kLineItem!)
            
            x += marginX + kLineWidth
            index += 1
        }
    }
    
}
