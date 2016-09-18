//
//  DJShareTimeModel.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/18.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

//date = 20160914;
//lastVolume = 42148125;
//name = "\U5e73\U5b89\U94f6\U884c";
//symbol = 000001;
//yestclose = "9.19";

//1459, time
//"9.07", current price
//"9.131", average price
//0 volumn

struct DJShareTimeModel {
    
    struct Item {
        var time: String!
        var currentPrice: Double!
        var averagePrice: Double!
        var volumn: Int64!
        
        mutating func convert(array: [AnyObject]) {
            time = array[0] as? String ?? ""
            currentPrice = array[1] as? Double ?? 0.0
            averagePrice = array[2] as? Double ?? 0.0
            volumn = (array[3] as? NSNumber)!.longLongValue / 10000 ?? 0
        }
    }
    
    var date: String!
    var name: String!
    var symbol: String!
    var lastVolumn: Int64!
    var count: Int64!
    var yestdayPrice: Double!
    var items: [Item] = [Item]()
    
    mutating func convert(dic: [String: AnyObject]) {
        date = dic["date"] as? String ?? ""
        name = dic["name"] as? String ?? ""
        symbol = dic["symbol"] as? String ?? ""
        count = (dic["count"] as? NSNumber)!.longLongValue ?? 0
        yestdayPrice = dic["yestclose"] as? Double ?? 0.0
        lastVolumn = (dic["lastVolume"] as? NSNumber)!.longLongValue / 10000 ?? 0
        
        guard let items = dic["data"] as? [[AnyObject]] else {
            return
        }
        
        for d in items {
            var item = Item()
            item.convert(d)
            self.items.append(item)
        }
        
    }
    
}
