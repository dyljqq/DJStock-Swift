//
//  DJExtension.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/14.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

private var yh: Void?

extension UIView {
    
    var dj_yh: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
}
