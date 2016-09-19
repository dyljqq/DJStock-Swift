//
//  DetailViewController.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/19.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var type = StockType.KLine {
        didSet {
            updateView()
        }
    }
    
    var name = "KLine" {
        didSet {
            title = name
        }
    }
    
    func updateView() {
        switch type {
        case .KLine:
            let kLine = DJKLine(frame: CGRectMake(0, 100, screenWidth, 300))
            self.view.addSubview(kLine)
            kLine.updateView("http://img1.money.126.net/data/hs/kline/day/history/2016/1000001.json")
        case .ShareTime:
            let shareTimeView = DJShareTimeGraph(frame: CGRectMake(0, 100, screenWidth, 300))
            self.view.addSubview(shareTimeView)
            shareTimeView.updateView("http://img1.money.126.net/data/hs/time/today/0000001.json")
        case .Tape:
            let tapeView = DJTapeView(frame: CGRectMake(screenWidth - 100, 112, 100, 300))
            tapeView.center = view.center
            self.view.addSubview(tapeView)
            tapeView.updateView("http://hq.sinajs.cn/list=sh000001")
        case .Group:
            let groupView = DJGroupView(frame: CGRectMake(0, 100, screenSize.width, 300))
            view.addSubview(groupView)
            groupView.updateView(["http://img1.money.126.net/data/hs/time/today/0000001.json", "http://hq.sinajs.cn/list=sh000001"])
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = whiteColor
    }
    
    
}
