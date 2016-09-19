//
//  ChartTableViewController.swift
//  DJStock-Swift
//
//  Created by 季勤强 on 16/9/19.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class ChartTableViewController: UITableViewController {
    
    struct Constant {
        static let cellIdentifier = "cell"
    }
    
    var contents = ["KLine", "ShareTimeGraph", "TapeView", "Group"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constant.cellIdentifier)
    }
    
}


// data source
extension ChartTableViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = contents[indexPath.row]
        return cell
    }
    
}

// delegate

extension ChartTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let detail = DetailViewController()
        switch indexPath.row {
        case 0: detail.type = .KLine
        case 1: detail.type = .ShareTime
        case 2: detail.type = .Tape
        case 3: detail.type = .Group
        default:
            break
        }
        detail.name = contents[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }
    
}
