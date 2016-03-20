//
//  Filter.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Filter: NSObject {
    let label: String
    let value: String
    let selected: Bool
    
    init(label: String, value: String, selected: Bool) {
        self.label = label
        self.value = value
        self.selected = selected
    }
}
