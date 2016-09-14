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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        kLine = DJKLine(frame: CGRectMake(0, 100, screenWidth, 300))
        self.view.addSubview(kLine)
        
        let gesture = UIPinchGestureRecognizer(target: kLine, action: #selector(kLine.pinch(_:)))
        kLine.addGestureRecognizer(gesture)
        kLine.userInteractionEnabled = true
        
        getKLineInfo()
    }
    
    func getKLineInfo() {
        KLineRequest.getKLineData({ array in
            self.kLine.update(array)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

