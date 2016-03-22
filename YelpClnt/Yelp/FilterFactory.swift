//
//  FilterFactory.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FilterFactory {
    
    static let FilterList: [FilterGroup] = [
        FilterGroup(header: "", type: FilterGroupType.Single, items: [
            Filter(label: "Offering a Deal", value: false, selected: false)]),
        
        FilterGroup(header: "Distance", type: FilterGroupType.Group, items: [
            Filter(label: "Auto", value: -1),
            Filter(label: "0.5 miles", value: 5),
            Filter(label: "2 miles", value: 0.5),
            Filter(label: "5 miles", value: 2)], selectedIndex: 0),
        
        FilterGroup(header: "Sort By", type: FilterGroupType.Group, items: [
            Filter(label: "Best Match", value: YelpSortMode.BestMatched.rawValue),
            Filter(label: "Distance", value: YelpSortMode.Distance.rawValue),
            Filter(label: "Highest Rate", value: YelpSortMode.HighestRated.rawValue)], selectedIndex: 0),
        
        FilterGroup(header: "Category", type: FilterGroupType.Single, items: [
            Filter(label: "Afghan", value: "afghani", selected: false),
            Filter(label: "African", value: "african", selected: false),
            Filter(label: "American, New", value: "newamerican", selected: false),
            Filter(label: "American, Traditional", value: "tradamerican", selected: false),
            Filter(label: "Arabian", value: "arabian", selected: false),
            Filter(label: "Argentine", value: "argentine", selected: false)])
    ]
    
    static func search(keyword: String, filters: [FilterGroup], callback: ([Business]!, NSError!) -> Void) {
        let categories = getCategories(filters)
        let sortType = getSortType(filters)
        
        Business.searchWithTerm(keyword, sort: sortType, categories: categories, deals: filters[0].items[0].selected) {
            (businesses: [Business]!, error: NSError!) -> Void in
            callback(businesses, error)
        }
    }
    
    static func getCategories(filters: [FilterGroup]) -> [String] {
        var res: [String] = []
        let categoriesGroup = filters[3]
        for filter in categoriesGroup.items {
            if filter.selected {
                res.append(filter.value as! String)
            }
        }
        return res
    }
    
    static func getSortType(filters: [FilterGroup]) -> YelpSortMode {
        let index =  filters[2].selectedIndex
        return YelpSortMode(rawValue: filters[2].items[index].value as! Int)!
    }
}