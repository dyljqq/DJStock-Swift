//
//  DJTapeView.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/19.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

// 大盘

public class DJTapeView: UIView {
    
    struct Contant {
        static let defaultNum = 10
        static let tag = 8888
    }
    
    private var views = [UIView]()
    
    var viewNum = Contant.defaultNum
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.layer.borderColor = lineColor.CGColor
        self.layer.borderWidth = 0.5
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        let remarkLabel = UILabel()
        remarkLabel.text = "五档"
        remarkLabel.textColor = blackColor
        remarkLabel.font = font(fontSize: 10)
        addSubview(remarkLabel)
        
        let firstLine = UIView()
        firstLine.backgroundColor = lineColor
        addSubview(firstLine)
        
        let secondLine = UIView()
        secondLine.backgroundColor = lineColor
        addSubview(secondLine)
        
        remarkLabel.snp_makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(5)
        }
        firstLine.snp_makeConstraints { make in
            make.top.equalTo(remarkLabel.snp_bottom).offset(5)
            make.left.width.equalTo(self)
            make.height.equalTo(0.5)
        }
        secondLine.snp_makeConstraints { make in
            make.width.left.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        for index in 0..<viewNum {
            addView(index)
        }
        
        var lastView: UIView?
        for (index, view) in views.enumerate() {
            view.snp_makeConstraints { make in
                if let lastView = lastView {
                    make.height.equalTo(lastView)
                    make.top.equalTo(lastView.snp_bottom)
                } else {
                    make.top.equalTo(remarkLabel.snp_bottom).offset(5)
                }
                make.left.width.equalToSuperview()
            }
            if index == 4 {
                secondLine.snp_makeConstraints { make in
                    make.centerY.equalTo(view.snp_bottom)
                }
            }
            
            lastView = view
        }
        lastView?.snp_makeConstraints { make in
            make.bottom.equalTo(self)
        }
    }
    
    func update(items: [DJTapeModel]) {
        
        for (index, item) in items.enumerate() {
            let view = views[index]
            (view.viewWithTag(Contant.tag) as! UILabel).text = item.remark
            (view.viewWithTag(Contant.tag + 1) as! UILabel).text = String(format: "%.2f", item.price)
            (view.viewWithTag(Contant.tag + 2) as! UILabel).text = String(format: "%ld", item.volumn)
        }
        
    }
    
    private func addView(index: Int) {
        let backView = UIView()
        
        let remarkLabel = UILabel()
        remarkLabel.textColor = blackColor
        remarkLabel.font = font(fontSize: 10)
        remarkLabel.tag = Contant.tag
        backView.addSubview(remarkLabel)
        
        let priceLabel = UILabel()
        priceLabel.textColor = KLineColor.Red.description
        priceLabel.font = font(fontSize: 10)
        priceLabel.tag = Contant.tag + 1
        backView.addSubview(priceLabel)
        
        let volumnLabel = UILabel()
        volumnLabel.textColor = blueColor
        volumnLabel.font = font(fontSize: 10)
        volumnLabel.tag = Contant.tag + 2
        backView.addSubview(volumnLabel)
        
        remarkLabel.snp_makeConstraints { make in
            make.centerY.equalTo(backView)
            make.left.equalTo(5)
        }
        priceLabel.snp_makeConstraints { make in
            make.top.equalTo(remarkLabel)
            make.left.equalTo(remarkLabel.snp_right).offset(5)
        }
        volumnLabel.snp_makeConstraints { make in
            make.top.equalTo(remarkLabel)
            make.right.equalTo(backView).offset(-5)
        }
        
        addSubview(backView)
        views.append(backView)
        
    }
    
}
