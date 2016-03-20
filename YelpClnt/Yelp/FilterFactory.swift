//
//  FilterFactory.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FilterFactory: NSObject {
    
    static let FilterList: [FilterGroup] = [
        FilterGroup(header: "", type: FilterGroupType.Single, items: [
            Filter(label: "Offering a Deal", value: "", selected: false)]),
        
        FilterGroup(header: "Distance", type: FilterGroupType.Group, items: [
            Filter(label: "5 miles", value: "5", selected: false),
            Filter(label: "0.5 miles", value: "0.5", selected: false),
            Filter(label:  "2 miles", value: "2", selected: false)]),
        
        FilterGroup(header: "Sort By", type: FilterGroupType.Group, items: [
            Filter(label: "Best Match", value: "", selected: false),
            Filter(label: "Distance", value: "", selected: false),
            Filter(label: "Highest Rate", value: "", selected: false)])
    ]
    

}
