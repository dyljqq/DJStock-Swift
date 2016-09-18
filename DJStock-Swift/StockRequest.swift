//
//  Request.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation
import Alamofire

class StockRequest {
    
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
    
}
