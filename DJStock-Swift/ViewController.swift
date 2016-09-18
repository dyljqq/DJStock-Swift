//
//  ViewController.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/13.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var kLine: DJKLine!
    
    let shareTimeView = DJShareTimeGraph(frame: CGRectMake(0, 100, screenWidth, 300))
    
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
        
        getShareTimeData()
    }
    
    func getKLineInfo() {
        KLineRequest.getKLineData({ array in
            self.kLine.update(array)
        })
    }
    
    func getShareTimeData() {
        DJRequest.getShareTimeRequest("http://img1.money.126.net/data/hs/time/today/0000001.json", callback: { model in
            
            self.shareTimeView.update(model as? DJShareTimeModel ?? DJShareTimeModel())
            
            }, failureCallback: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

