//
//  DJStockSearchController.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/20.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

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
        searchBar.becomeFirstResponder()
        return searchBar
    }()
    
    
    var data = [DJStockModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.snp_makeConstraints { make in
            make.left.equalToSuperview().offset(leftSpace)
            make.right.equalToSuperview().offset(-leftSpace)
            make.height.equalTo(44)
            make.top.equalToSuperview()
        }
        tableView.snp_makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view)
        }
    }
    
    private func setup() {
        view.backgroundColor = whiteColor
        
        addTitleView()
        view.addSubview(self.tableView)
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
    
    private func addTitleView() {
        navigationItem.titleView = self.searchBar
        
        if let subviews = searchBar.subviews.last?.subviews {
            for subview in subviews {
                if subview is UIButton {
                    (subview as! UIButton).setTitle("取消", forState: .Normal)
                }
            }
        }
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let URLString = "http://suggest3.sinajs.cn/suggest/type=111&key=\(searchText)&name=suggestdata_\(NSDate().timeIntervalSince1970)"
        let lockQueue = dispatch_queue_create("com.dyljqq.lockQueue", nil)
        dispatch_sync(lockQueue) {
            self.request(URLString)
        }
    }
    
}
