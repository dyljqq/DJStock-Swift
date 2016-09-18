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

public class DJRequest {
    
    class func get(URLString URLString: String,
                             parameters: [[String: AnyObject]]? = nil,
                             successCallback: SuccessCallback,
                             failureCallback: FailureCallback? = nil) {
        print("URLString: \(URLString)\nparameters: \(parameters)")
        Alamofire.request(.GET, URLString).responseJSON { response in
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
    class func getKLineData(callback: Callback?) {
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
    
}