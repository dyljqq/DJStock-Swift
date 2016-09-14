//
//  Utility.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

func RGB(red red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat? = 1.0)-> UIColor {
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha!)
}

let clearColor = UIColor.clearColor()
let whiteColor = UIColor.whiteColor()
let redColor = UIColor.redColor()
let blackColor = UIColor.blackColor()

let textGrayColor = RGB(red: 175, green: 175, blue: 175)
let lineColor = RGB(red: 204, green: 204, blue: 204)
