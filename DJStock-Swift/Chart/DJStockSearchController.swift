//
//  DJStockSearchController.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/20.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

private let KLinePrefix = "http://img1.money.126.net/data/hs/kline/day/history/2016/"
private let ShareTimePrefix = "http://img1.money.126.net/data/hs/time/today/"
private let TapePrefix = "http://hq.sinajs.cn/list="

class DJStockSearchController: UIViewController {
    
    struct Constant {
        static let cellIdentifier = "cell"
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = whiteColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.registerClass(DJStockCell.self, forCellReuseIdentifier: Constant.cellIdentifier)
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.barStyle = .Default
        searchBar.placeholder = "点击搜索股票"
        searchBar.backgroundColor = clearColor
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    
    var data = [DJStockModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.searchBar.frame = CGRectMake(leftSpace, 0, screenSize.width - 2 * leftSpace, 44)
        tableView.snp_makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view)
        }
    }
    
    private func setup() {
        
        title = "Stock Search"
        
        view.backgroundColor = whiteColor
        view.addSubview(self.tableView)
        
        navigationController?.navigationBar.topItem?.titleView = self.searchBar
        
        // clear the background view
        for subview in searchBar.subviews {
            if subview.subviews.count > 0 {
                subview.subviews.first?.removeFromSuperview()
            }
        }
        
        if let subviews = searchBar.subviews.last?.subviews {
            for subview in subviews {
                if let subview = subview as? UIButton {
                    subview.setTitle("取消", forState: .Normal)
                } else if let textField = subview as? UITextField {
                    textField.layer.borderWidth = 0.5
                    textField.layer.borderColor = lineColor.CGColor
                    textField.layer.cornerRadius = 3
                    textField.layer.masksToBounds = true
                }
            }
        }
    }
    
    func getCurrentPrices(array: [DJStockModel]) {
        var stockFulls = [String]()
        for stock in array {
            stockFulls.append(stock.stockFull)
        }
        DJRequest.getCurrentPriceRequest(stockFulls, callback: { arr in
            var stocks = [DJStockModel]()
            for (index, var stock) in array.enumerate() {
                stock.currentPrice = Double(arr[2 * index]) ?? 0.0
                stock.yestdayPrice = Double(arr[2 * index + 1]) ?? 0.0
                stock.rate = stock.yestdayPrice > 0 ? (stock.currentPrice - stock.yestdayPrice) / stock.yestdayPrice : 0.0
                stock.riseColor = stock.rate > 0 ? .Red : .Green
                stocks.append(stock)
            }
            self.data = stocks
        })
    }
    
    private func request(URLString: String) {
        DJRequest.stockSearchRequest(URLString, callback: { array in
            self.getCurrentPrices(array)
        })
    }
    
}

extension DJStockSearchController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // TODO
        let stockFull = data[indexPath.row].stockFull
        let sheetAction = UIAlertController(title: "Choose", message: "", preferredStyle: .ActionSheet)
        let kLineAction = UIAlertAction(title: "KLine", style: .Default, handler: { action in
            let detail = DetailViewController()
            detail.name = "KLine"
            detail.type = .KLine
            let suffix = stockFull.containsString("sh") ? "0" : "1" + self.data[indexPath.row].stockCode
            detail.URLStrings = [KLinePrefix + suffix + ".json"]
            self.navigationController?.pushViewController(detail, animated: true)
        })
        let shareTimeAction = UIAlertAction(title: "ShareTime", style: .Default, handler: { action in
            let detail = DetailViewController()
            detail.name = "ShareTime"
            detail.type = .ShareTime
            let suffix = stockFull.containsString("sh") ? "0" : "1" + self.data[indexPath.row].stockCode
            detail.URLStrings = [ShareTimePrefix + suffix + ".json"]
            self.navigationController?.pushViewController(detail, animated: true)
        })
        let tapeAction = UIAlertAction(title: "Tape", style: .Default, handler: { action in
            let detail = DetailViewController()
            detail.name = "Tape"
            detail.type = .Tape
            detail.URLStrings = [TapePrefix + stockFull]
            self.navigationController?.pushViewController(detail, animated: true)
        })
        let groupAction = UIAlertAction(title: "Group", style: .Default, handler: { action in
            let detail = DetailViewController()
            detail.name = "Group"
            detail.type = .Group
            detail.URLStrings = [ShareTimePrefix + self.data[indexPath.row].stockCode + ".json", TapePrefix + stockFull]
            self.navigationController?.pushViewController(detail, animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            // TODO
        })
        sheetAction.addAction(kLineAction)
        sheetAction.addAction(shareTimeAction)
        sheetAction.addAction(tapeAction)
        sheetAction.addAction(groupAction)
        sheetAction.addAction(cancelAction)
        presentViewController(sheetAction, animated: true, completion: nil)
    }
    
}

extension DJStockSearchController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.cellIdentifier, forIndexPath: indexPath) as! DJStockCell
        cell.update(data[indexPath.row])
        return cell
    }
    
}

extension DJStockSearchController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let URLString = "http://suggest3.sinajs.cn/suggest/type=111&key=\(searchText)&name=suggestdata_\(NSDate().timeIntervalSince1970)"
        let lockQueue = dispatch_queue_create("com.dyljqq.lockQueue", nil)
        dispatch_sync(lockQueue) {
            self.request(URLString)
        }
    }
    
}
