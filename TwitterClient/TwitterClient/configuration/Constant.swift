//
//  Constant.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/23/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class Constant: NSObject {
    class Twitter {
        static let CONSUMER_KEY = "Ays71qrrDlFd3quqIXlRxakF4"
        static let CONSUMER_SECRET = "YR5xiNhhcsCmsyodjGJr51tf4Zouljxd1N5Qjkct6irTMH3NQ4"
        static let ACCESS_TOKEN = "67823922-Y0nD6ZDGyMarnbWs7fZzMaOifSVdGeUxfsE64DgSG"
        static let ACCESS_TOKEN_SECRET = "NZUzajCrnhXohpkWZ5Jemr7HpYz8k1Dtp1XpKstRytmSf"
        
        static let BASE_API_URL = "https://api.twitter.com"
        static let REQUEST_TOKEN_URL = "oauth/request_token"
        static let ACCESS_TOKEN_URL = "oauth/access_token"
        static let AUTHORIZE_URL = "/oauth/authorize"
        
        static let CURRENT_ACCOUNT_URL = "1.1/account/verify_credentials.json"
        static let HOME_TIMELINE_URL = "1.1/statuses/home_timeline.json"
        static let UPDATE_STATUS_URL = "1.1/statuses/update.json"
        static let FAVORITE_TWEET_URL = "1.1/favorites/create.json"
        static let UNFAVORITE_TWEET_URL = "1.1/favorites/destroy.json"
        static let RETWEET_URL = "1.1/statuses/retweet/"
        static let UNRETWEET_URL = "1.1/statuses/unretweet/"

    }
}

