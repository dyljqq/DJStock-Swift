//
//  DataWindow.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/14.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

struct ItemData {
    var text: String
    var fontSize: CGFloat = 10
    var textColor: UIColor = textGrayColor
    
    init(text: String) {
        self.text = text
    }
}

class DJDataWindow: UIView {
    
    struct Constant {
        static let tagStart = 8888
        static let marginX: CGFloat = 5.0
        static let marginY: CGFloat = 5.0
    }
    
    var splitColor: UIColor = textGrayColor
    
    var itemDatas = [ItemData]() {
        didSet {
            var y: CGFloat = 5.0
            var maxWidth: CGFloat = CGFloat.min
            for (index, itemData) in itemDatas.enumerate() {
                var label = viewWithTag(Constant.tagStart + index) as? UILabel
                if label == nil {
                    label = UILabel(frame: CGRectMake(Constant.marginX, y, self.bounds.width, 11))
                    label?.tag = Constant.tagStart + index
                    addSubview(label!)
                }
                label?.textColor = itemData.textColor
                label?.font = font(fontSize: itemData.fontSize)
                label?.text = itemData.text
                label?.addTextColorAttribute(itemData.text, splitCharactor: ":", textColor: splitColor)
                
                y += Constant.marginY + 11
                maxWidth = max(maxWidth, (label?.labelWidth)!)
            }
            
            // reset frame
            var frame = self.frame
            frame.size.height = y
            frame.size.width = maxWidth + 10
            self.frame = frame
        }
    }
    
}
