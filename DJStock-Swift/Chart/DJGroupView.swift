//
//  DJGroupView.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/19.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

public class DJGroupView: UIView {
    
    let shareTimeView = DJShareTimeGraph(frame: CGRectMake(0, 100, screenWidth - 100, 300))
    let tapeView = DJTapeView(frame: CGRectMake(screenWidth - 100, 112, 100, 288))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(shareTimeView)
        addSubview(tapeView)
    }
    
}
