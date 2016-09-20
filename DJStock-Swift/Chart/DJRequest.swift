//
//  DJRequest.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/18.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation
import Alamofire

typealias SuccessCallback = (value: [String: AnyObject])-> ()
typealias FailureCallback = (error: NSError)-> ()

typealias ModelCallback = (model: Any)-> ()
typealias ArrayCallback = (array: [AnyObject])-> ()

struct DJRequestUtil {
    static let data = "data"
}

enum DJRequestType {
    case JSON, HTTP
}

public class DJRequest {
    
    class func get(URLString URLString: String,
                             parameters: [[String: AnyObject]]? = nil,
                             type: DJRequestType? = .JSON,
                             successCallback: SuccessCallback,
                             failureCallback: FailureCallback? = nil) {
        print("URLString: \(URLString)\nparameters: \(parameters)")
        
        let request = Alamofire.request(.GET, URLString)
        if type == .JSON {
            request.responseJSON { response in
                switch response.result {
                case .Success(let value):
                    print("response value: \(value)")
                    successCallback(value: value as! [String : AnyObject])
                case .Failure(let error):
                    print("Network error: \(error)")
                    if let failureCallback = failureCallback {
                        failureCallback(error: error)
                    }
                }
            }
        } else {
            request.responseData { responseData in
                switch responseData.result {
                case .Success(let value):
                    print("response value: \(value)")
                    let cfEnc = CFStringEncodings.GB_18030_2000
                    let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                    let dogString: String = NSString(data: value, encoding: enc) as! String
                    successCallback(value: [DJRequestUtil.data: dogString])
                case .Failure(let error):
                    print("Network error: \(error)")
                    if let failureCallback = failureCallback {
                        failureCallback(error: error)
                    }
                }
                
            }
        }
    }
    
    /**
     20160304,时间
     "5.4",收盘价
     "5.37",开盘价
     "5.48",最高价
     "5.12",最低价
     6517543,成交量
     "-0.92"，涨跌幅
     **/
    class func getKLineData(URLString: String, callback: ((data: [KLineModel])-> ())?) {
        DJRequest.get(URLString: URLString, successCallback: { response in
            guard let datas = response[DJRequestUtil.data] as? [AnyObject] else {
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
    
    class func getShareTimeRequest(URLString: String, callback: ModelCallback? = nil, failureCallback: FailureCallback? = nil) {
        DJRequest.get(URLString: URLString, successCallback: { response in
            
            var model = DJShareTimeModel()
            model.convert(response)
            if let callback = callback {
                callback(model: model)
            }
            
            }, failureCallback: { error in
                if let failureCallback = failureCallback {
                    failureCallback(error: error)
                }
        })
    }
    
    /**
     0：”大秦铁路”，股票名字；
     1：”27.55″，今日开盘价；
     2：”27.25″，昨日收盘价；
     3：”26.91″，当前价格；
     4：”27.55″，今日最高价；
     5：”26.20″，今日最低价；
     6：”26.91″，竞买价，即“买一”报价；
     7：”26.92″，竞卖价，即“卖一”报价；
     8：”22114263″，成交的股票数，由于股票交易以一百股为基本单位，所以在使用时，通常把该值除以一百；
     9：”589824680″，成交金额，单位为“元”，为了一目了然，通常以“万元”为成交金额的单位，所以通常把该值除以一万；
     10：”4695″，“买一”申请4695股，即47手；
     11：”26.91″，“买一”报价；
     12：”57590″，“买二”
     13：”26.90″，“买二”
     14：”14700″，“买三”
     15：”26.89″，“买三”
     16：”14300″，“买四”
     17：”26.88″，“买四”
     18：”15100″，“买五”
     19：”26.87″，“买五”
     20：”3100″，“卖一”申报3100股，即31手；
     21：”26.92″，“卖一”报价
     (22, 23), (24, 25), (26,27), (28, 29)分别为“卖二”至“卖五的情况”
     30：”2008-01-11″，日期；
     31：”15:05:32″，时间；
     **/
    class func getTapeRequest(URLString: String, callback: (array: [DJTapeModel])-> (), failureCallback: FailureCallback? = nil) {
        DJRequest.get(URLString: URLString, type: DJRequestType.HTTP, successCallback: { response in
            
            guard let dogString = response[DJRequestUtil.data] as? String else {
                print("tape: data is nil")
                return
            }
            
            let arr = dogString.componentsSeparatedByString("\"")
            let data = arr.count >= 2 ? arr[1].componentsSeparatedByString(",") : []
            
            guard data.count >= 30 else {
                print("tape: data is not valid...")
                return
            }
            var contents = [DJTapeModel]()
            var start = 29
            for index in 0..<5 {
                contents.append(DJTapeModel(remark: "卖\(index + 1)", price: NSNumberFormatter().numberFromString(data[start - index])!.doubleValue, volumn: NSNumberFormatter().numberFromString(data[start - index - 1])!.longLongValue))
                start -= 2
            }
            
            start = 10
            for index in 0..<5 {
                contents.append(DJTapeModel(remark: "买\(index + 1)", price: NSNumberFormatter().numberFromString(data[start + index + 1])!.doubleValue, volumn: NSNumberFormatter().numberFromString(data[start + index])!.longLongValue))
                start += 2
            }
            
            callback(array: contents)
            
            }, failureCallback: { error in
            
                if let failureCallback = failureCallback {
                    failureCallback(error: error)
                }
                
            })
    }
    
    // stock search
    class func stockSearchRequest(URLString: String, callback: (array: [DJStockModel])-> (), failureCallback: FailureCallback? = nil) {
        DJRequest.get(URLString: URLString, type: .HTTP, successCallback: { response in
            guard let dogString = response[DJRequestUtil.data] as? String else {
                return
            }
            
            let array = dogString.componentsSeparatedByString("\"")
            guard array.count >= 2 else{
                return
            }
            
            let stocks = array[1].componentsSeparatedByString(";")
            var mutableArray = [DJStockModel]()
            
            guard stocks[0] != "" else {
                callback(array: mutableArray)
                return
            }
            for stock in stocks {
                var model = DJStockModel()
                model.convert(stock.componentsSeparatedByString(","))
                mutableArray.append(model)
            }
            callback(array: mutableArray)
        })
    }
    
    // stock current price
    class func getCurrentPriceRequest(stocks: [String], callback: (array: [String])-> ()) {
        let URLString = ("http://hq.sinajs.cn/list=" + stocks.joinWithSeparator(",")).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? ""
        DJRequest.get(URLString: URLString, type: .HTTP, successCallback: { response in
            guard let dogString = response[DJRequestUtil.data] else {
                return
            }
            //var hq_str_sh000001="上证指数,3027.1717,3026.0513,3022.9995,3027.8165,3015.8804,0,0,118924117,139662303158,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2016-09-20,15:01:57,00";
            var prices = [String]()
            let array = dogString.componentsSeparatedByString("\n")
            for str in array {
                var arr = str.componentsSeparatedByString("\"")
                if arr.count >= 3 {
                    let a = arr[1].componentsSeparatedByString(",")
                    if a.count >= 3 {
                        prices += [a[2], a[3]]
                    } else {
                        prices += ["", ""]
                    }
                } else {
                    prices += ["", ""]
                }
            }
            callback(array: prices)
        })
    }
    
}