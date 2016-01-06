//
//  ViewController.swift
//  LPStatusBarBackgroundColor
//
//  Created by litt1e-p on 16/1/6.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit

enum StatusColor: Int {
    case StatusColorBlack = 0, StatusColorGreen, StatusColorRed, StatusColorBlue, StatusColorGray, StatusColorBrown
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let kCellID = "kCellID"
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "StatusBarBgColor"
        tableView = UITableView(frame: self.view.frame)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCellID)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellID, forIndexPath: indexPath)
        cell.textLabel?.text = self.configureCellColorDesc(StatusColor(rawValue: indexPath.row)!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.navigationBar.statusBarBackgroundColor = self.configureCellColor(StatusColor(rawValue: indexPath.row)!)
    }
    
    func configureCellColorDesc(row: StatusColor) -> String {
        switch row {
            case .StatusColorGreen:
                return "green"
            case .StatusColorRed:
                return "red"
            case .StatusColorBlue:
                return "blue"
            case .StatusColorGray:
                return "gray"
            case .StatusColorBrown:
                return "brown"
            default:
                return "black"
        }
    }
    
    func configureCellColor(row: StatusColor) -> UIColor {
        switch row {
            case .StatusColorGreen:
                return UIColor.greenColor()
            case .StatusColorRed:
                return UIColor.redColor()
            case .StatusColorBlue:
                return UIColor.blueColor()
            case .StatusColorGray:
                return UIColor.grayColor()
            case .StatusColorBrown:
                return UIColor.brownColor()
            default:
                return UIColor.blackColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}