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
    var URLStrings = [String]() {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        guard URLStrings.count > 0 else {
            return
        }
        
        switch type {
        case .KLine:
            let kLine = DJKLine(frame: CGRectMake(0, 100, screenWidth, 300))
            self.view.addSubview(kLine)
            kLine.updateView(URLStrings[0])
        case .ShareTime:
            let shareTimeView = DJShareTimeGraph(frame: CGRectMake(0, 100, screenWidth, 300))
            self.view.addSubview(shareTimeView)
            shareTimeView.updateView(URLStrings[0])
        case .Tape:
            let tapeView = DJTapeView(frame: CGRectMake(screenWidth - 100, 112, 100, 300))
            tapeView.center = view.center
            self.view.addSubview(tapeView)
            tapeView.updateView(URLStrings[0])
        case .Group:
            let groupView = DJGroupView(frame: CGRectMake(0, 100, screenSize.width, 300))
            view.addSubview(groupView)
            groupView.updateView(URLStrings)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = whiteColor
    }
    
}
