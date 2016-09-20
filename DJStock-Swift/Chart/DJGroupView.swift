//
//  DJGroupView.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/19.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

public class DJGroupView: UIView {
    
    var shareTimeView: DJShareTimeGraph!
    var tapeView: DJTapeView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        shareTimeView =  DJShareTimeGraph(frame: CGRectMake(0, 0, screenWidth * 2 / 3, bounds.height))
        tapeView = DJTapeView(frame: CGRectMake(screenWidth * 2 / 3, 12, screenSize.width / 3, bounds.height - 12))
        
        addSubview(shareTimeView)
        addSubview(tapeView)
    }
    
}
