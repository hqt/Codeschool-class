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
    var filterCategories: [FilterGroup]!
    
    @IBOutlet weak var prefTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefTableView.delegate = self
        prefTableView.dataSource = self
    }
    
    @IBAction func cancelFilter(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchFilter(sender: AnyObject) {
        print(FilterFactory.FilterList[0].items[0].selected)
        self.delegate.filterDone(filterCategories)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension PreferenceViewController: UITableViewDelegate {
}

// MARK: UITableViewDataSource
extension PreferenceViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterCategories.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterCategories[section].type == FilterGroupType.Group {
            return 1
        } else {
            return filterCategories[section].items.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterCategories[section].header
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get section and row
        let section = indexPath.section
        let row = indexPath.row
        
        // get element base on section and row
        let category = filterCategories[section]
        let filter = category.items[row]
        
        // single: using switch cell
        if category.type == FilterGroupType.Single {
            let cell = tableView.dequeueReusableCellWithIdentifier("com.hqt.yelp.pref.switch", forIndexPath: indexPath) as! PreferenceSwitchCell
            cell.switchLabel.text = filter.label
            cell.switchPicker.setOn(filter.selected, animated: true)
            cell.switchPicker.addTarget(self, action: "switchCategoryChanged:", forControlEvents: UIControlEvents.ValueChanged)
            return cell
        }
            // multiple: using picker
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("com.hqt.yelp.pref.spinner", forIndexPath: indexPath) as! PreferenceSpinnerCell
//            let t0 = CGAffineTransformMakeTranslation (0, cell.dataPicker.bounds.size.height/2);
//            let s0 = CGAffineTransformMakeScale       (1.0, 0.5);
//            let t1 = CGAffineTransformMakeTranslation (0, -cell.dataPicker.bounds.size.height/2);
//            cell.dataPicker.transform = CGAffineTransformConcat          (t0, CGAffineTransformConcat(s0, t1));
            
            cell.dataPicker.delegate = self
            cell.dataPicker.dataSource = self
            return cell
        }
    }
    
    func switchCategoryChanged(sender: AnyObject) {
        // TODO: need more elegan way not depend on autolayout
        // get cell. base on layout implementation.
        let switchView = sender as! UISwitch
        let view = switchView.superview
        let cell = view?.superview as! UITableViewCell
        
        if let indexPath = prefTableView.indexPathForCell(cell) {
            let row = indexPath.row
            let section = indexPath.section
            filterCategories[section].items[row].selected = switchView.on
        }
    }
}

// MARK: UIPickerView Delegate
extension PreferenceViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // TODO: find the way more elegant here
        let cell = pickerView.superview?.superview as! UITableViewCell
        
        if let indexPath = prefTableView.indexPathForCell(cell) {
            let section = indexPath.section
            return filterCategories[section].items[row].label
        }
        return "Unidentify"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = pickerView.superview?.superview as! UITableViewCell
        
        if let indexPath = prefTableView.indexPathForCell(cell) {
            let section = indexPath.section
            filterCategories[section].selectedIndex = row
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
         return (self.view.frame.size.width * 55 ) / 100
    }

}

// MARK: UIPickerView DataSource
extension PreferenceViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // TODO: find the way more elegant here
        let cell = pickerView.superview?.superview as! UITableViewCell
        
        if let indexPath = prefTableView.indexPathForCell(cell) {
            let section = indexPath.section
            return filterCategories[section].items.count
        }
        return 0
    }
}