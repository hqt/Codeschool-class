//
//  Filter.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

struct Filter {
    let label: String
    let value: NSObject
    var selected: Bool
    
    init(label: String, value: NSObject, selected: Bool = false) {
        self.label = label
        self.value = value
        self.selected = selected
    }
}
