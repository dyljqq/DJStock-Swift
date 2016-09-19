//
//  KLineModel.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

struct KLineModel {
    var time: String!
    var closePrice: Double!
    var openPrice: Double!
    var minPrice: Double!
    var maxPrice: Double!
    var volumn: Int64!
    var rate: Double!
    
    mutating func convert(array: [AnyObject]) {
        time = array[0] as? String ?? ""
        closePrice = NSNumberFormatter().numberFromString(String(array[1]))?.doubleValue
        openPrice = NSNumberFormatter().numberFromString(String(array[2]))?.doubleValue
        maxPrice = NSNumberFormatter().numberFromString(String(array[3]))?.doubleValue
        minPrice = NSNumberFormatter().numberFromString(String(array[4]))?.doubleValue
        volumn =  NSNumberFormatter().numberFromString(String(array[5]))?.longLongValue
        rate = NSNumberFormatter().numberFromString(String(array[6]))?.doubleValue
    }
}