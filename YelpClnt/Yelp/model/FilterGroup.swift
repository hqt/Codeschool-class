//
//  FilterGroup.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

struct FilterGroup {
    let header: String
    let type: FilterGroupType
    var items: [Filter]
    var selectedIndex: Int
    
    init(header: String, type: FilterGroupType, items: [Filter], selectedIndex: Int = -1) {
        self.header = header
        self.items = items
        self.type = type
        self.selectedIndex = selectedIndex
    }
}

enum FilterGroupType {
    case Single
    case Group
}

