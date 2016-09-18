//
//  DJShareTimeGraph.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/18.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class DJShareTimeGraph: UIView {
    
    struct Constant {
        static let dashLineNum = 3
        static let xLabelNum = 2
        static let maxPointNum = 242
        static let volumnTagStart = 1111
        static let maxItemNum = 1000
        static let volumnMargin: CGFloat = 0.5
    }
    
    var margin: CGFloat = 5.0
    
    lazy var mainView: UIView = {
        let width = self.bounds.size.width - 2 * self.margin
        let view = UIView(frame: CGRectMake(self.margin, self.margin, width, 2 * self.bounds.height / 3))
        view.backgroundColor = whiteColor
        
        view.layer.borderColor = lineColor.CGColor
        view.layer.borderWidth = 1.0
        
        return view
    }()
    
    lazy var curveLine: DJCurveLine = {
        let curveLine = DJCurveLine(frame: self.mainView.bounds)
        curveLine.isClose = true
        return curveLine
    }()
    
    lazy var volumnView: UIView = {
        let width = self.bounds.size.width - 2 * self.margin
        let view = UIView(frame: CGRectMake(self.margin, self.mainView.dj_yh + 11, width, self.bounds.height - self.mainView.dj_yh - 11))
        view.backgroundColor = whiteColor
        
        view.layer.borderColor = lineColor.CGColor
        view.layer.borderWidth = 1.0
        
        return view
    }()
    
    lazy var volumnLabel: UILabel = {
        let label = UILabel()
        label.textColor = blackColor
        label.font = font(fontSize: 10)
        label.text = "量：-- 现手： --"
        return label
    }()
    
    lazy var verticalLine: DJSegmentLine = {
        let line = DJSegmentLine(frame: CGRectMake(0, self.mainView.frame.origin.y, 1.0, self.volumnView.dj_yh - self.mainView.frame.origin.y))
        line.hidden = true
        return line
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = blackColor
        label.font = font(fontSize: 10)
        label.backgroundColor = whiteColor
        label.hidden = true
        
        label.layer.borderWidth = 0.5
        label.layer.borderColor = blackColor.CGColor
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private var xLabels = [UILabel]()
    private var yLabels = [UILabel]()
    private var yRightLabels = [UILabel]()
    
    private var show = false {
        didSet {
            self.verticalLine.hidden = !show
            self.timeLabel.hidden = !show
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
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapAction(_:)))
        self.mainView.addGestureRecognizer(gesture)
        self.userInteractionEnabled = true
        
        backgroundColor = clearColor
        
        addSubview(self.mainView)
        addSubview(self.volumnView)
        mainView.addSubview(self.curveLine)
        volumnView.addSubview(self.volumnLabel)
        
        verticalLine.segments = [mainView.frame.height, volumnView.frame.origin.y]
        
        let spaceY = mainView.frame.size.height / CGFloat(Constant.dashLineNum + 1)
        var y = spaceY
        for _ in 0..<Constant.dashLineNum {
            mainView.addSubview(DJDashLine(frame: CGRectMake(0, y, mainView.frame.size.width, 1.0)))
            y += spaceY
        }
        
        volumnView.addSubview(DJDashLine(frame: CGRectMake(0, volumnView.frame.height / 2, mainView.frame.size.width, 1.0)))
        
        y = 0
        for index in 0..<Constant.dashLineNum + 2  {
            let label = UILabel(frame: CGRectMake(0, y, 100, 11))
            label.textColor = blackColor
            label.font = font(fontSize: 10)
            mainView.addSubview(label)
            
            let rightLabel = UILabel()
            rightLabel.textColor = blackColor
            rightLabel.font = font(fontSize: 10)
            mainView.addSubview(rightLabel)
            
            rightLabel.snp_makeConstraints { make in
                make.right.equalTo(mainView)
                make.top.equalTo(y)
            }
            
            yRightLabels.append(rightLabel)
            yLabels.append(label)
            y += spaceY
            if index == 0 {
                y -= label.frame.height
            }
            
        }
        
        for index in 0..<Constant.xLabelNum {
            let label = UILabel(frame: CGRectMake(margin, CGRectGetMaxY(mainView.frame), self.bounds.width, 11))
            label.textColor = blackColor
            label.font = font(fontSize: 10)
            addSubview(label)
            
            xLabels.append(label)
            
            if index == 0 {
                label.text = "09:30"
            } else {
                label.text = "15:30"
            }
            
            label.snp_makeConstraints { make in
                make.top.equalTo(mainView.snp_bottom)
                if index == 0 {
                    make.left.equalTo(mainView)
                } else {
                    make.right.equalTo(mainView)
                }
            }
        }
        volumnLabel.snp_makeConstraints { make in
            make.left.equalTo(5)
            make.top.equalTo(2)
        }
        
        addSubview(self.verticalLine)
        addSubview(self.timeLabel)
    }
    
    private var model = DJShareTimeModel()
    private var volumnItems = [VolumnItem]()
    private var currentVolumnItem: VolumnItem!
    func update(model: DJShareTimeModel) {
        var maxPrice = DBL_MIN
        var minPrice = DBL_MAX
        model.items.forEach { item in
            maxPrice = max(maxPrice, item.currentPrice)
            minPrice = min(minPrice, item.currentPrice)
        }
        
        let spaceX = mainView.bounds.width / CGFloat(Constant.maxPointNum)
        var rate = CGFloat((maxPrice - minPrice)) / mainView.bounds.height
        rate = rate == 0 ? 1.0 : rate
        var x: CGFloat = 0.0
        var points = [CGPoint]()
        var price = model.yestdayPrice
        for item in model.items {
            let y = CGFloat(maxPrice - item.currentPrice) / rate
            let point = CGPoint(x: x, y: y)
            points.append(point)
            
            volumnItems.append(VolumnItem(volumn: item.volumn, color: item.currentPrice > price ? .Red : .Green))
            
            price = item.currentPrice
            x += spaceX
        }
        curveLine.points = points
        
        for index in 0..<yLabels.count {
            let space = maxPrice - Double(index) * (maxPrice - minPrice) / Double(yLabels.count + 1)
            yLabels[index].text = String(format: "%.2f", space)
            
            let rate = 100 * (space - model.yestdayPrice) / model.yestdayPrice
            yRightLabels[index].text = String(format: "%.2f%%", rate)
            yRightLabels[index].textColor = rate >= 0 ? KLineColor.Red.description : KLineColor.Green.description
        }
        
        self.model = model
        currentVolumnItem = volumnItems[volumnItems.count - 1]
        volumnLabel.text = "量:\(currentVolumnItem.volumn) 现手:\(currentVolumnItem.volumn)"
        
        updateVolumn(volumnItems)
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
        let lineWidth = volumnView.bounds.width / CGFloat(Constant.maxPointNum) - Constant.volumnMargin
        
        var x = Constant.volumnMargin
        for (index, volumn) in volumns.enumerate() {
            let itemView = DJVolumnItemView()
            volumnView.addSubview(itemView)
            let y = CGFloat(mx - Double(volumn.volumn)) / rate
            itemView.tag = Constant.volumnTagStart + index
            itemView.frame = CGRectMake(x, y, index < volumns.count - 1 ? lineWidth : mainView.bounds.width - x, CGFloat(volumn.volumn) / rate)
            itemView.volumnColor = volumn.color
            x += volumnView.bounds.width / CGFloat(Constant.maxPointNum)
        }
        addVolumnLabelAttr(volumnItems[model.items.count - 1].color.description)
    }
    
    // MARK: - action
    
    func longTapAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began || gesture.state == .Changed {
            let point = gesture.locationInView(mainView)
            let index = Int(point.x / (volumnView.bounds.width / CGFloat(Constant.maxPointNum)))
            guard index < model.items.count && index >= 0 else {
               return
            }
            let volumn = model.items[index].volumn
            volumnLabel.text = "量:\(volumn) 现手:\(currentVolumnItem.volumn)"
            addVolumnLabelAttr(volumnItems[index].color.description)
            
            show = true
            timeLabel.text = model.items[index].time
            let timeWidth = timeLabel.labelWidth
            let x = point.x + margin
            timeLabel.frame = CGRectMake(x - timeWidth / 2, mainView.dj_yh, timeWidth, 11)
            verticalLine.frame = CGRectMake(x, mainView.frame.origin.y, 1.0, volumnView.dj_yh - mainView.frame.origin.y)
            verticalLine.segments = [mainView.frame.height, volumnView.frame.origin.y - mainView.frame.origin.y]
            
        } else {
            show = false
            volumnLabel.text = "量:\(currentVolumnItem.volumn) 现手:\(currentVolumnItem.volumn)"
            addVolumnLabelAttr(volumnItems[model.items.count - 1].color.description)
        }
    }
    
    private func addVolumnLabelAttr(textColor: UIColor) {
        let text = volumnLabel.text ?? ""
        let attr = NSMutableAttributedString(string: volumnLabel.text ?? "")
        let arr = text.componentsSeparatedByString(" ")
        if arr.count == 2 {
            var a = arr[0].componentsSeparatedByString(":")
            if a.count > 1 {
                attr.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(a[0].length + 1, a[1].length))
                attr.addAttribute(NSForegroundColorAttributeName, value: currentVolumnItem.color.description, range: NSMakeRange(arr[1].length + a[0].length + 2, a[1].length))
            }
        }
        volumnLabel.attributedText = attr
    }
    
}
