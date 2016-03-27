//
//  DetailViewController.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/26/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var retweetTextView: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var casualNameTextView: UILabel!
    @IBOutlet weak var userNameTextView: UILabel!
    @IBOutlet weak var dateCreatedTextView: UILabel!
    @IBOutlet weak var totalRetweetTextView: UILabel!
    @IBOutlet weak var totalFavouriteTextView: UILabel!
    @IBOutlet weak var tweetContentTextView: UILabel!
    @IBOutlet weak var retweetButton: UIImageView!
    @IBOutlet weak var favButton: UIImageView!
    
    let starImage = UIImage(named: "color_star")
    let unstarImage = UIImage(named: "star")
    let notTweetImage = UIImage(named: "tweet")
    let tweetedImage = UIImage(named: "retweet")

    
    var delegate: DoneUpdateTweetDelegate!
    
    var tweet: Tweet!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.setImageWithURL(NSURL(string: tweet.user.profileUrl!)!)
        casualNameTextView.text = tweet.user.name
        userNameTextView.text = tweet.user.screename
        dateCreatedTextView.text = tweet.formatTimeRemaining()
        totalRetweetTextView.text = "\(tweet.retweetCount)"
        totalFavouriteTextView.text = "\(tweet.favouriteCount)"
        tweetContentTextView.text = tweet.text
        
        if tweet.isFavourite {
            favButton.image = starImage
        } else {
            favButton.image = unstarImage
        }
        
        if tweet.isRetweeted {
            retweetButton.image = tweetedImage
        } else {
            retweetButton.image = notTweetImage
        }

        
        let retweetGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DetailViewController.buttonTapped(_:)))
        retweetButton.userInteractionEnabled = true
        retweetButton.tag = 1
        retweetButton.addGestureRecognizer(retweetGestureRecognizer)

        let favGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DetailViewController.buttonTapped(_:)))
        favButton.userInteractionEnabled = true
        favButton.tag = 0
        favButton.addGestureRecognizer(favGestureRecognizer)
        
           }
    
    func buttonTapped(sender: UITapGestureRecognizer) {
        if sender.view?.tag == 0 {
            print("fav")
            if (tweet.isFavourite) {
                TwitterClient.sharedInstance.unfavoriteTweet(tweet)
                tweet.favouriteCount -= 1
                tweet.isFavourite = false
                totalFavouriteTextView.text = "\(tweet.favouriteCount)"
                favButton.image = unstarImage
            } else {
                TwitterClient.sharedInstance.favoriteTweet(tweet)
                tweet.favouriteCount += 1
                tweet.isFavourite = true
                totalFavouriteTextView.text = "\(tweet.favouriteCount)"
                favButton.image = starImage
            }
        } else if sender.view?.tag == 1 {
            if (tweet.isRetweeted) {
                TwitterClient.sharedInstance.unretweet(tweet)
                tweet.retweetCount -= 1
                tweet.isRetweeted = false
                totalRetweetTextView.text = "\(tweet.retweetCount)"
                retweetButton.image = notTweetImage
            } else {
                TwitterClient.sharedInstance.retweet(tweet)
                tweet.retweetCount += 1
                tweet.isRetweeted = true
                totalRetweetTextView.text = "\(tweet.retweetCount)"
                retweetButton.image = tweetedImage
            }
            
        }
    }
    
    
    @IBAction func gotoHomeScreen(sender: AnyObject) {
        delegate.doneUpdateTweet(tweet, index: index)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplySegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let tweetFeedController = navController.viewControllers[0] as! PostTweetController
            tweetFeedController.replyTweet = tweet
            tweetFeedController.delegate = self
        }
    }
}

extension DetailViewController: DoneTweetDelegate {
    func doneTweet(tweet: Tweet) {
    }
}
