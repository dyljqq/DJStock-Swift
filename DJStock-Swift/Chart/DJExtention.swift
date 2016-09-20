//
//  DJExtention.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/14.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

extension UIView {
    
    var dj_yh: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
}

extension UILabel {
    
    var labelWidth: CGFloat {
        guard let text = self.text else {
            return 0.0
        }
        let attr = [NSFontAttributeName: font]
        let size = CGSize(width: CGFloat(DBL_MAX), height: frame.height)
        let rect = text.boundingRectWithSize(size, options: [.UsesLineFragmentOrigin, .TruncatesLastVisibleLine, .UsesFontLeading], attributes: attr, context: nil)
        return rect.width
    }
    
    func addTextColorAttribute(text: String, splitCharactor: String, textColor: UIColor) {
        let attr = NSMutableAttributedString(string:  text)
        var arr = text.componentsSeparatedByString(splitCharactor)
        if arr.count >= 2 {
            attr.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(arr[0].length + 1, arr[1].length))
            attributedText = attr
        }
    }
    
}

extension String {
    var length: Int {
        return characters.count
    }
}