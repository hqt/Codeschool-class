//
//  StuffUtils.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/27/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class StuffUtils: NSObject {
    static func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                closure)
    }
}
