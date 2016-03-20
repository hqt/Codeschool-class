//
//  PreferenceViewController.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController {
    
    var delegate: FilterDoneDelegate!
    @IBOutlet weak var prefTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefTableView.delegate = self
        prefTableView.dataSource = self
        
    }
}

extension PreferenceViewController: UITableViewDelegate {
    
    
}

extension PreferenceViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return FilterFactory.FilterList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterFactory.FilterList[section].items.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FilterFactory.FilterList[section].header
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let category = FilterFactory.FilterList[section]
        let filter = category.items[row]
        
        if FilterFactory.FilterList[section].type == FilterGroupType.Single {
            let cell = tableView.dequeueReusableCellWithIdentifier("com.hqt.yelp.pref.switch", forIndexPath: indexPath) as! PreferenceSwitchCell
            cell.switchLabel.text = filter.label
            cell.switchPicker.setOn(filter.selected, animated: true)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("com.hqt.yelp.pref.spinner", forIndexPath: indexPath) as! PreferenceSpinnerCell
            return cell
        }
    }
    
    
    @IBAction func cancelFilter(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchFilter(sender: AnyObject) {
        self.delegate.filterDone()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
