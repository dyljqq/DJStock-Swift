//
//  DJStock.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/19.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

public enum StockType {
    case KLine // Default
    case ShareTime
    case Tape
    case Group // means ShareTime + Tape, it is the normal situation
    
    var description: Int {
        switch self {
        case .KLine: return DJTag.kLineTag
        case .ShareTime: return DJTag.shareTimeTag
        case .Tape: return DJTag.tapeTag
        case .Group: return DJTag.groupTag
        }
    }
    
}

public typealias ViewCallback = (view: UIView)-> ()

public struct DJTag {
    static let kLineTag = 6888
    static let shareTimeTag = 7888
    static let tapeTag = 8888
    static let groupTag = 9888
}

public struct StockItem {
    var type: StockType
    var isAdd: Bool
}

extension UIView {
    
    // update the indicate view
    public func updateView(URLString: AnyObject) {
        
        var shareTimeURLString = ""
        var tapeURLString = ""
        var string = ""
        if let URLStrings = URLString as? [String] {
            guard URLStrings.count == 2 else {
                print("invalid params...")
                return
            }
            shareTimeURLString = URLStrings[0].containsString("money") ? URLStrings[0] : URLStrings[1]
            tapeURLString = URLStrings[0].containsString("sina") ? URLStrings[0] : URLStrings[1]
        } else if let URLString = URLString as? String {
            string = URLString
        } else {
            print("param is not valid...")
            return
        }
        
        if let view = self as? DJKLine {
            updateKLineView(string, kLineView: view)
        } else if let view = self as? DJShareTimeGraph {
            updateShareTimeView(string, shareTimeView: view)
        } else if let view = self as? DJTapeView {
            updateTapeView(string, tapeView: view)
        } else {
            
            for subview in subviews {
                if let subview = subview as? DJShareTimeGraph {
                    subview.updateView(shareTimeURLString)
                } else if let subview = subview as? DJTapeView {
                    subview.updateView(tapeURLString)
                }
            }
            
        }
        
    }
    
}

func updateKLineView(URLString: String, kLineView: DJKLine) {
    DJRequest.getKLineData(URLString) { array in
        kLineView.update(array)
    }
}

func updateShareTimeView(URLString: String, shareTimeView: DJShareTimeGraph) {
    DJRequest.getShareTimeRequest(URLString, callback: { model in
        shareTimeView.update(model as? DJShareTimeModel ?? DJShareTimeModel())
    }, failureCallback: nil)
}


func updateTapeView(URLString: String, tapeView: DJTapeView) {
    DJRequest.getTapeRequest(URLString, callback: { items in
        tapeView.update(items)
    }, failureCallback: nil)
}


// get the indicate view
public func update(URLString: AnyObject, type: StockType? = .KLine, callback: ViewCallback) {
    var shareTimeURLString = ""
    var tapeURLString = ""
    var string = ""
    if let URLStrings = URLString as? [String] {
        
        guard URLStrings.count == 2 else {
            print("invalid params...")
            return
        }
        
        shareTimeURLString = URLStrings[0].containsString("money") ? URLStrings[0] : URLStrings[1]
        tapeURLString = URLStrings[0].containsString("sina") ? URLStrings[0] : URLStrings[1]
    } else if let URLString = URLString as? String {
        string = URLString
    } else {
        print("param is not valid...")
        return
    }
    
    switch type! {
    case .ShareTime:
        getShareTimeView(string) { view in
            view.tag = DJTag.shareTimeTag
            callback(view: view)
        }
    case .Tape:
        getTapView(string) { view in
            view.tag = DJTag.tapeTag
            callback(view: view)
        }
    case .Group:
        
        let container = UIView()
        
        let group = dispatch_group_create()
        dispatch_group_enter(group)
        getShareTimeView(shareTimeURLString) { view in
            view.tag = DJTag.shareTimeTag
            container.addSubview(view)
            dispatch_group_leave(group)
        }
        
        dispatch_group_enter(group)
        getTapView(tapeURLString) { view in
            view.tag = DJTag.tapeTag
            container.addSubview(view)
            dispatch_group_leave(group)
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            container.tag = DJTag.groupTag
            callback(view: container)
        }
        
    default:
        getKLineView(string) { view in
            view.tag = DJTag.kLineTag
            callback(view: view)
        }
    }
    
}

func getKLineView(URLString: String, callback: ViewCallback) {
    DJRequest.getKLineData(URLString) { array in
        let kLineView = DJKLine()
        kLineView.update(array)
        callback(view: kLineView)
    }
}

func getShareTimeView(URLString: String, callback: ViewCallback) {
    DJRequest.getShareTimeRequest(URLString, callback: { model in
        
        let shareTimeGraph = DJShareTimeGraph()
        shareTimeGraph.update(model as? DJShareTimeModel ?? DJShareTimeModel())
        callback(view: shareTimeGraph)
        
        }, failureCallback: nil)
}

func getTapView(URLString: String, callback: ViewCallback) {
    DJRequest.getTapeRequest(URLString, callback: { items in
        let tapeView = DJTapeView()
        tapeView.update(items)
        
        callback(view: tapeView)
    }, failureCallback: nil)
}