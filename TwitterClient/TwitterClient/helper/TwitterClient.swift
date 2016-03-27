//
//  TwitterFactory.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/25/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: Constant.Twitter.BASE_API_URL), consumerKey: Constant.Twitter.CONSUMER_KEY,  consumerSecret: Constant.Twitter.CONSUMER_SECRET)
    
    var loginSuccessCallback: ((User) -> ())!
    var loginFailCallback: ((NSError) -> ())!
    static var currentUser: User?
    
    // MARK: step 1 in OAuth1. get request token
    func requestToken(sucessCallback: ((User) -> ()), failCallback: ((NSError) -> ())) {
        self.loginSuccessCallback = sucessCallback
        self.loginFailCallback = failCallback
        
        // little bug in library. we must log out session first
        TwitterClient.sharedInstance.deauthorize()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(Constant.Twitter.REQUEST_TOKEN_URL, method: "GET", callbackURL: NSURL(string: "twitterdemo://demo"), scope: nil, success: {
            (requestToken: BDBOAuth1Credential!) -> Void in
                print("step 1. request token: \(requestToken.token)")
                let url = NSURL(string: Constant.Twitter.BASE_API_URL + Constant.Twitter.AUTHORIZE_URL + "?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(url!)
            }, failure: { (error: NSError!) -> Void in
                print("error when getting request token: \(error.localizedDescription)")
        })
    }
    
    // MARK: step 2 in OAuth1. get access token
    func accessToken(urlQuery: String) {
        let requestToken = BDBOAuth1Credential(queryString: urlQuery)
        TwitterClient.sharedInstance.fetchAccessTokenWithPath(Constant.Twitter.ACCESS_TOKEN_URL, method: "POST", requestToken: requestToken, success: {
            (accessToken: BDBOAuth1Credential!) -> Void in
                print("step 2. Access Token. This field should be kept very secret")
            
                print("step 3. get user detail")
                self.currentUser({
                    (user: User) -> Void in
                    self.loginSuccessCallback(user)
                })
    
            }, failure: { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailCallback(error)
        })
    }
    
    func currentUser(success: (User -> Void)) {
        GET(Constant.Twitter.CURRENT_ACCOUNT_URL, parameters: nil, success: {
            (task: NSURLSessionTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let user = User(data: dictionary)
            success(user)
            
            }, failure: {
                (task: NSURLSessionTask?, error: NSError) -> Void in
                print("CurrentUser API exception: \(error.localizedDescription)")
        })
    }
    
    func timeline(total: Int, success: (Feed -> Void)) {
        GET("\(Constant.Twitter.HOME_TIMELINE_URL)?count=\(total)", parameters: nil, success: {
            (task: NSURLSessionTask, response: AnyObject?) -> Void in
            let feed = Feed()
            let dictionary  = response as! [NSDictionary]
            for data in dictionary {
                let tweet = Tweet(data: data)
                feed.tweets.append(tweet)
            }
            success(feed)
            
            }, failure: {
                (task: NSURLSessionTask?, error: NSError) -> Void in
                print("Timeline API Exception: \(error.localizedDescription)")
        })
    }
    
    // MARK: Post a tweet
    func tweet(text: String) {
        let params = ["status": text]
        
        POST(Constant.Twitter.UPDATE_STATUS_URL, parameters: params, success: {
            (request: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Success post status.")
            }, failure: {(request: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Post status exception.")
            })
    }
    
    // MARK: Reply a tweet
    func reply(text: String, repliedTweet: Tweet) {
        let params = ["status": text, "in_reply_to_status_id": repliedTweet.id]
        
        POST(Constant.Twitter.UPDATE_STATUS_URL, parameters: params, success: {
            (request: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Success reply status.")
            }, failure: {(request: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Reply status exception.")
        })
    }
    
    // MARK: Favorite a tweet
    func favoriteTweet(tweet: Tweet) {
        let params = ["id": tweet.id]
        
        POST(Constant.Twitter.FAVORITE_TWEET_URL, parameters: params, success: {
            (request: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Success Favorited tweet: \(tweet.id)")
            }, failure: {(request: NSURLSessionDataTask?, error: NSError!) -> Void in
            print("Favorite Tweet Exception: \(error.localizedDescription)")
        })
    }
    
    // MARK: Unfavourite a tweet
    func unfavoriteTweet(tweet: Tweet) {
        let params = ["id": tweet.id]
        
        POST(Constant.Twitter.UNFAVORITE_TWEET_URL, parameters: params, success: {
            (request: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Success Unfavorited tweet: \(tweet.id)")
            }, failure: {(request: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Unfavorite tweet exception: \(error.localizedDescription)")
        })
    }
    
    // MARK: Retweet
    func retweet(tweet: Tweet) {
        let params = ["id": tweet.id]
        
        POST("\(Constant.Twitter.RETWEET_URL)\(tweet.id).json", parameters: params, success: {
            (request: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Success Retweet: \(tweet.id)")
            }, failure: {(request: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Retweet exception: \(error.localizedDescription)")
        })
    }
    
    // MARK: Unretweet
    func unretweet(tweet: Tweet) {
        let params = ["id": tweet.id]
        
        POST("\(Constant.Twitter.UNRETWEET_URL)\(tweet.id).json", parameters: params, success: {
            (request: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Success UnRetweet: \(tweet.id)")
            }, failure: {(request: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Retweet exception: \(error.localizedDescription)")
        })
    }

    // MARK: logout clear all credentials
    func logout() {
        requestSerializer.removeAccessToken()
        DataBaseUtils.removeUser(TwitterClient.currentUser!)
        TwitterClient.currentUser = nil
    }
}