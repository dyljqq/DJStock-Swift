//
//  DJStockModel.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/20.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation


struct DJStockModel {
    var stockCode = ""
    var stockFull = ""
    var stockName = ""
    
    var currentPrice = 0.0
    var yestdayPrice = 0.0
    var rate = 0.0
    var riseColor: KLineColor = .Red
    
    mutating func convert(array: [String]) {
        guard array.count >= 5 else {
            return
        }
        stockCode = array[2]
        stockFull = array[3]
        stockName = array[4]
    }
}