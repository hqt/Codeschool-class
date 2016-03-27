//
//  User.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/25/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit
import Realm

class User: RLMObject {
    dynamic var userId: Int
    dynamic var name: String?
    dynamic var screename: String?
    dynamic var profileUrl: String?
    dynamic var tagline: String?
    
    override init() {
        self.userId = 0
        super.init()
    }
    
    init(data: NSDictionary) {
        userId = data["id"] as! Int
        name = data["name"] as? String
        screename = data["screen_name"] as? String
        profileUrl = data["profile_image_url_https"] as? String
        tagline = data["descripton"] as? String
        
        super.init()
    }
    
    override class func primaryKey() -> String {
        return "userId"
    }

}


