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
    var itemColor: KLineColor
}

struct VolumnItem {
    var volumn: Int64
    var color: KLineColor
}

class DJKLine: UIView {
    
    struct Constant {
        static let dashLineNum = 3
        static let defaultLineWidth: CGFloat = 10.0
        static let minScale: CGFloat = 0.5
        static let kLineTagStart = 8888
        static let volumnTagStart = 1111
        static let maxItemNum = 1000
    }
    
    var kLineWidth: CGFloat = Constant.defaultLineWidth
    var lastLineWidth: CGFloat = Constant.defaultLineWidth
    
    var datas = [KLineModel]()
    
    var marginX: CGFloat = 1.0
    
    private var xLabels = [UILabel]()
    private var yLabels = [UILabel]()
    private var start = 0
    
    lazy var backView: UIView = {
        let width = self.bounds.size.width - 2 * self.marginX
        let view = UIView(frame: CGRectMake(self.marginX, 0, width, 2 * self.bounds.height / 3))
        view.backgroundColor = whiteColor
        
        view.layer.borderColor = lineColor.CGColor
        view.layer.borderWidth = 1.0
        
        return view
    }()
    
    lazy var volumnView: UIView = {
        let width = self.bounds.size.width - 2 * self.marginX
        let view = UIView(frame: CGRectMake(self.marginX, self.backView.dj_yh + 20, width, self.bounds.height - self.backView.dj_yh - 20))
        view.backgroundColor = whiteColor
        
        view.layer.borderColor = lineColor.CGColor
        view.layer.borderWidth = 1.0
        
        return view
    }()
    
    lazy var dataWindow: DJDataWindow = {
        let dataWindow = DJDataWindow(frame: CGRectMake(2, 2, 100, 50))
        dataWindow.backgroundColor = RGB(red: 99, green: 99, blue: 99, alpha: 1.0)
        return dataWindow
    }()
    
    lazy var line: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, 1.0, self.backView.frame.height))
        view.backgroundColor = blackColor
        return view
    }()
    
    lazy var volumnLine: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, 1.0, self.volumnView.frame.height))
        view.backgroundColor = blackColor
        return view
    }()
    
    lazy var volumnLabel: UILabel = {
        let label = UILabel(frame: CGRectMake(2, 2, 100, 13))
        label.text = "成交量"
        label.textColor = blackColor
        label.font = font(fontSize: 12)
        return label
    }()
    
    var show: Bool = true {
        didSet {
            line.hidden = show
            dataWindow.hidden = show
            volumnLine.hidden = show
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        // init data
        show = true
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.addGestureRecognizer(tap)
        
        backgroundColor = clearColor
        addSubview(self.backView)
        addSubview(self.volumnView)
        backView.addSubview(self.dataWindow)
        backView.addSubview(self.line)
        volumnView.addSubview(self.volumnLine)
        
        let spaceY = backView.frame.size.height / CGFloat(Constant.dashLineNum + 1)
        var y = spaceY
        for _ in 0..<Constant.dashLineNum {
            backView.addSubview(DJDashLine(frame: CGRectMake(0, y, backView.frame.size.width, 1.0)))
            y += spaceY
        }
        
        volumnView.addSubview(DJDashLine(frame: CGRectMake(0, volumnView.frame.height / 2, backView.frame.size.width, 1.0)))
        
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
            let label = UILabel(frame: CGRectMake(marginX, CGRectGetMaxY(backView.frame), self.bounds.width, 11))
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
        
        volumnView.addSubview(self.volumnLabel)
        
    }
    
    func update(array: [KLineModel]) {
        
        datas = array
        
        let h = self.backView.frame.height
        var count = Int(backView.frame.size.width / (kLineWidth + marginX))
        start = array.count - count - 1
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
        
        var volumns = [VolumnItem]()
        var positions = [KLineItemPosition]()
        for index in start...count {
            let kLineModel = array[index]
            let y1 = CGFloat(mx - kLineModel.maxPrice) / rate
            let y2 = CGFloat(mx - kLineModel.minPrice) / rate
            let height = abs(y2 - y1)
            let points = [CGPoint(x: 0, y: CGFloat(kLineModel.maxPrice - kLineModel.closePrice) / rate), CGPoint(x: 0, y: CGFloat(kLineModel.maxPrice - kLineModel.openPrice) / rate)]
            // if it can not infer the type, you must add the type
            let color: KLineColor = (kLineModel.closePrice - kLineModel.openPrice) > 0 ? .Red : .Green
            let position = KLineItemPosition(y: y1, height: height, points: points, itemColor: color)
            positions.append(position)
            volumns.append(VolumnItem(volumn: kLineModel.volumn, color: color))
        }
        updateKLine(positions)
        updateVolumn(volumns)
        
        let diff = (mx - mn) / Double(Constant.dashLineNum + 1)
        for (index,label) in yLabels.enumerate() {
            label.text = "\(mx - diff * Double(index))"
        }
        
        let xP: Int = (count - start - 1) / (xLabels.count - 1)
        for (index, label) in xLabels.enumerate() {
            let model = array[start + index * xP]
            label.text = model.time
        }
    }
    
    func updateKLine(kLineItemPosition: [KLineItemPosition]) {
        
        if kLineItemPosition.count > Constant.maxItemNum {
            return
        }
        for view in backView.subviews {
            if view.tag >= Constant.kLineTagStart && view.tag <= Constant.kLineTagStart + Constant.maxItemNum {
                view.removeFromSuperview()
            }
        }
        
        var x = marginX
        for (index, item) in kLineItemPosition.enumerate() {
            let kLineItem = DJKLineItem()
            backView.addSubview(kLineItem)
            kLineItem.frame = CGRectMake(x, item.y, index < kLineItemPosition.count - 1 ? kLineWidth : backView.bounds.width - x, item.height)
            kLineItem.points = item.points
            kLineItem.tag = index + Constant.kLineTagStart
            kLineItem.colorType = item.itemColor
            
            x += marginX + kLineWidth
        }
        backView.bringSubviewToFront(dataWindow)
        backView.bringSubviewToFront(line)
    }
    
    func updateVolumn(volumns: [VolumnItem]) {
        
        if volumns.count > Constant.maxItemNum {
            return
        }
        
        for view in volumnView.subviews {
            if view.tag >= Constant.volumnTagStart && view.tag <= Constant.volumnTagStart + Constant.maxItemNum {
                view.removeFromSuperview()
            }
        }
        
        let h = volumnView.frame.height
        var mx = DBL_MIN
        var mn = DBL_MAX
        for volumn in volumns {
            mx = max(mx, Double(volumn.volumn))
            mn = min(mn, Double(volumn.volumn))
        }
        let rate = CGFloat(mx) / h
        var x = marginX
        for (index, volumn) in volumns.enumerate() {
            let itemView = DJVolumnItemView()
            volumnView.addSubview(itemView)
            let y = CGFloat(mx - Double(volumn.volumn)) / rate
            itemView.tag = Constant.volumnTagStart + index
            itemView.frame = CGRectMake(x, y, index < volumns.count - 1 ? kLineWidth : backView.bounds.width - x, CGFloat(volumn.volumn) / rate)
            itemView.volumnColor = volumn.color
            
            x += marginX + kLineWidth
        }
        
        volumnView.bringSubviewToFront(volumnLine)
    }
    
    // MARK: - Gesture
    func pinch(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            kLineWidth *= gesture.scale
            if kLineWidth >= Constant.defaultLineWidth {
                kLineWidth = Constant.defaultLineWidth
            } else if kLineWidth <= Constant.defaultLineWidth * Constant.minScale {
                kLineWidth = Constant.defaultLineWidth * Constant.minScale
            }
            
            if lastLineWidth != kLineWidth  {
                update(datas)
            }
            
            lastLineWidth = kLineWidth
            gesture.scale = 1.0
        }
    }
    
    func tap(gesture: UILongPressGestureRecognizer) {
        if datas.count <= 0 {
            return
        }
        
        if gesture.state == .Began || gesture.state == .Changed {
            show = false
            
            let point = gesture.locationInView(self.backView)
            let index = Int(point.x / (kLineWidth + marginX)) + start
            
            var frame = line.frame
            frame.origin.x = point.x
            line.frame = frame
            
            frame = volumnLine.frame
            frame.origin.x = point.x
            volumnLine.frame = frame
            
            let kLineModel = datas[index >= datas.count ? datas.count - 1 : index]
            
            if kLineModel.closePrice > kLineModel.openPrice {
                dataWindow.splitColor = KLineColor.Red.description
            } else {
                dataWindow.splitColor = KLineColor.Green.description
            }
            let itemDatas = [ItemData(text: "最高价: \(kLineModel.maxPrice)"), ItemData(text: "最低价: \(kLineModel.minPrice)"), ItemData(text: "开盘价: \(kLineModel.openPrice)"), ItemData(text: "收盘价: \(kLineModel.closePrice)"), ItemData(text: "时间: \(kLineModel.time)")]
            dataWindow.itemDatas = itemDatas
            
            frame = dataWindow.frame
            if point.x > backView.frame.width / 2 {
                frame.origin.x = marginX
            } else {
                frame.origin.x = backView.frame.width - dataWindow.frame.width - marginX
            }
            dataWindow.frame = frame
            
            volumnLabel.text = "成交量: \(kLineModel.volumn / 10000)(万)"
            volumnLabel.addTextColorAttribute(volumnLabel.text!, splitCharactor: ":", textColor: dataWindow.splitColor)
            
        } else {
            show = true
            volumnLabel.text = "成交量"
        }
    }
    
}
