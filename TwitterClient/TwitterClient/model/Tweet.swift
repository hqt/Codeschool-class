//
//  Tweet.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/25/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: String
    var text: String
    var retweetCount: Int
    var favouriteCount: Int
    var isFavourite: Bool
    var isRetweeted: Bool
    var time: NSDate?
    var user: User
    
    init(id: String, text: String, retweetCount: Int, favourteCount: Int, isFavourite: Bool, isReTweeted: Bool, time: NSDate, user: User) {
        self.id = id
        self.text = text
        self.retweetCount = retweetCount
        self.favouriteCount = favourteCount
        self.isFavourite = isFavourite
        self.isRetweeted = isReTweeted
        self.time = time
        self.user = user
    }
    
    init(data: NSDictionary) {
        self.id = data["id_str"] as! String
        self.text = data["text"] as? String ?? "blank text"
        self.isFavourite = data["favorited"] as! Bool
        self.isRetweeted = data["retweeted"] as! Bool
        self.retweetCount = data["retweet_count"] as? Int ?? 0
        self.favouriteCount = data["favourites_count"] as? Int ?? 0
    
        let timeStampStr = data["created_at"] as? String
        
        if let timeStampStr = timeStampStr {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            time = formatter.dateFromString(timeStampStr)!
        }
        
        self.user = User(data: data["user"] as! NSDictionary)

    }
    
    // MARK: get nice presentative day as guideline
    func formatTimeRemaining() -> String {
        let interval = Float(self.time!.timeIntervalSinceNow)
        let second: Float = 1.0
        let minute: Float = second * 60
        let hour: Float = minute * 60
        let day: Float = hour * 24
        
        var num: Float = abs(interval),
        beforeOrAfter = "before",
        unit = "day",
        retVal = "now";
        
        if (interval == 0) {
            return retVal
        }
        
        if (interval > 0) {
            beforeOrAfter = "after"
        }
        
        if (num >= day) {
            num /= day;
            if (num > 1) {
                unit = "d"
            }
        }
        else if (num >= hour) {
            num /= hour;
            unit = "h"
        }
        else if (num >= minute) {
            num /= minute;
            unit = "m";
        }
        else if (num >= second) {
            num /= second;
            unit = "s";
        }
        
        return "\(Int(num))\(unit)"
    }
    
    class func getDateFormatterObject() -> NSDateFormatter {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "eee, MMM dd"
        
        return dateFormatter;
    }
}
