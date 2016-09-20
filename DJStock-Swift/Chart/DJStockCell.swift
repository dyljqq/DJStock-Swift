//
//  DJStockCell.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/20.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class DJStockCell: UITableViewCell {
    
    lazy var stockNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = blackColor
        label.font = UIFont.systemFontOfSize(15)
        return label
    }()
    
    lazy var stockCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = textGrayColor
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    lazy var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = textGrayColor
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Right
        return label
    }()
    
    lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = whiteColor
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.backgroundColor = KLineColor.Red.description
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stockNameLabel.snp_makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(leftSpace)
        }
        stockCodeLabel.snp_makeConstraints { make in
            make.bottom.equalTo(-5)
            make.left.equalTo(stockNameLabel)
        }
        
        let width = labelWidth("100.00%", labelSize: CGSizeMake(50, rateLabel.bounds.height), font: rateLabel.font) + 10
        rateLabel.snp_makeConstraints { make in
            make.right.equalTo(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(width)
        }
        currentPriceLabel.snp_makeConstraints { make in
            make.right.equalTo(rateLabel.snp_left).offset(-13)
            make.centerY.equalTo(rateLabel)
        }
    }
    
    func update(model: DJStockModel) {
        stockNameLabel.text = model.stockName
        stockCodeLabel.text = model.stockFull
        currentPriceLabel.text = String(format: "%.2f", model.currentPrice)
        rateLabel.text = String(format: "%.2f%%", model.rate * 100)
    }
    
    private func setup() {
        contentView.addSubview(self.stockNameLabel)
        contentView.addSubview(self.stockCodeLabel)
        contentView.addSubview(self.rateLabel)
        contentView.addSubview(self.currentPriceLabel)
    }
    
}
