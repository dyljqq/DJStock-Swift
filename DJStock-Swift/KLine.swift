//
//  KLineModel.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

let kline_url = "http://img1.money.126.net/data/hs/kline/day/history/2016/1000001.json"

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

typealias Callback = (data: [KLineModel])-> ()

struct KLineRequest {
    
    static func getKLineData(callback: Callback?) {
        /**
         20160304,时间
         "5.4",收盘价
         "5.37",开盘价
         "5.48",最高价
         "5.12",最低价
         6517543,成交量
         "-0.92"，涨跌幅
         **/
        StockRequest.get(URLString: kline_url, successCallback: { response in
            guard let datas = response["data"] as? [AnyObject] else {
                print("no k line data...")
                return
            }
            var arrays = [KLineModel]()
            for data in datas {
                var model = KLineModel()
                model.convert(data as! [AnyObject])
                arrays.append(model)
            }
            if let callback = callback {
                callback(data: arrays)
            }
        })
    }
    
}