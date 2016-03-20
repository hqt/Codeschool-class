//
//  FilterGroup.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FilterGroup: NSObject {
    let header: String
    let type: FilterGroupType
    let items: [Filter]
    
    init(header: String, type: FilterGroupType, items: [Filter]) {
        self.header = header
        self.items = items
        self.type = type
    }
}

enum FilterGroupType {
    case Single
    case Group
}

