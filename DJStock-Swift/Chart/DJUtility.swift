//
//  Utility.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

let screenSize = UIScreen.mainScreen().bounds.size
let screenWidth = screenSize.width
let screenHeight = screenSize.height

let leftSpace: CGFloat = 15.0

func labelWidth(text: String, labelSize: CGSize, font: UIFont)-> CGFloat {
    let attr = [NSFontAttributeName: font]
    let size = CGSize(width: CGFloat(DBL_MAX), height: labelSize.height)
    let rect = text.boundingRectWithSize(size, options: [.UsesLineFragmentOrigin, .TruncatesLastVisibleLine, .UsesFontLeading], attributes: attr, context: nil)
    return rect.width
}