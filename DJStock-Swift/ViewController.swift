//
//  ViewController.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var kLine = DJKLine(frame: CGRectMake(0, 100, screenWidth, 300))
    
    let shareTimeView = DJShareTimeGraph(frame: CGRectMake(0, 100, screenWidth - 100, 300))
    
    let tapeView = DJTapeView(frame: CGRectMake(screenWidth - 100, 112, 100, 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
//        kLine = DJKLine(frame: CGRectMake(0, 100, screenWidth, 300))
//        self.view.addSubview(kLine)
//        
//        let gesture = UIPinchGestureRecognizer(target: kLine, action: #selector(kLine.pinch(_:)))
//        kLine.addGestureRecognizer(gesture)
//        kLine.userInteractionEnabled = true
        
//        getKLineInfo()
        
        view.addSubview(shareTimeView)
        view.addSubview(tapeView)
        view.updateView(["http://img1.money.126.net/data/hs/time/today/0000001.json", "http://hq.sinajs.cn/list=sh000001"])
//        shareTimeView.updateView("http://img1.money.126.net/data/hs/time/today/0000001.json")
        
//        getShareTimeData()
//        view.addSubview(tapeView)
//        getTapeData()
        
//        view.addSubview(kLine)
//        kLine.updateView("http://img1.money.126.net/data/hs/kline/day/history/2016/1000001.json")
        
    }
    
    func getShareTimeData() {
        DJRequest.getShareTimeRequest("http://img1.money.126.net/data/hs/time/today/0000001.json", callback: { model in
            
            self.shareTimeView.update(model as? DJShareTimeModel ?? DJShareTimeModel())
            
            }, failureCallback: nil)
    }
    
    func getTapeData() {
        DJRequest.getTapeRequest("http://hq.sinajs.cn/list=sh000001", callback: { items in
            self.tapeView.update(items)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

