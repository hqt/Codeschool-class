//
//  PreferenceSwitchDelegate.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol PreferenceSwitchDelegate: class {
    func preferenceSwitchCellDidToggle(cell: PreferenceSwitchCell, newValue:Bool)
}
