//
//  Feed.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/26/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class Feed: NSObject {
    var tweets: [Tweet]
    
    override init() {
        tweets = []
    }
}
