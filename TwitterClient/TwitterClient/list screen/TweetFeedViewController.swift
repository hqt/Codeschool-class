//
//  TweetFeedViewController.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/23/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class TweetFeedViewController: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    var feed: Feed = Feed()
    var refreshControl: UIRefreshControl!
    var isMoreDataLoading = false
    
    let starImage = UIImage(named: "color_star")
    let unstarImage = UIImage(named: "star")
    let notTweetImage = UIImage(named: "tweet")
    let tweetedImage = UIImage(named: "retweet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetFeedViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        feedTableView.insertSubview(refreshControl, atIndex: 0)

        feedTableView.estimatedRowHeight = 120
        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        loadData()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        print("refresh data")
        loadData()
    }
    
    func loadData() {
        TwitterClient.sharedInstance.timeline(20, success: {
            (feed: Feed) -> Void in
            self.feed = feed
            self.refreshControl.endRefreshing()
            self.feedTableView.reloadData()
        })
    }
    
    @IBAction func signOut(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func newTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("LoginSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "PostTweetSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let postTweetController = navController.viewControllers[0] as! PostTweetController
            postTweetController.delegate = self
        } else if segue.identifier == "TweetDetailSegue" {
            let indexPath = sender as! NSIndexPath
            let navController = segue.destinationViewController as! UINavigationController
            let tweetDetailController = navController.viewControllers[0] as! DetailViewController
            tweetDetailController.delegate = self
            tweetDetailController.tweet = feed.tweets[indexPath.row]
            tweetDetailController.index = indexPath.row
        }
    }
}

extension TweetFeedViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.hqt.twitter.tweet", forIndexPath: indexPath) as! FeedCell
        let tweet = feed.tweets[indexPath.row]
        cell.avatarImageView.setImageWithURL(NSURL(string: tweet.user.profileUrl!)!)
        cell.usernameTextView.text = tweet.user.screename
        cell.casualnameTextView.text = tweet.user.name
        cell.contentTextView.text = tweet.text
        cell.totalFavTextView.text = "\(tweet.favouriteCount)"
        cell.totalRetweetTextView.text = "\(tweet.retweetCount)"
        
        if tweet.isFavourite {
            cell.favouriteImageView.image = starImage
        } else {
            cell.favouriteImageView.image = unstarImage
        }
        
        if tweet.isRetweeted {
            cell.retweetImageView.image = tweetedImage
        } else {
            cell.retweetImageView.image = notTweetImage
        }
        
        cell.timeTextView.text = tweet.formatTimeRemaining()
        
        return cell
    }
}

extension TweetFeedViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("TweetDetailSegue", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension TweetFeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
    }
}

extension TweetFeedViewController: DoneTweetDelegate {
    func doneTweet(tweet: Tweet) {
        let indexPath = feedTableView.indexPathForSelectedRow
        feed.tweets.insert(tweet, atIndex: 0)
        feedTableView.reloadData()
        StuffUtils.delay(0.2) {
            self.feedTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Middle)
        }
    }
}

extension TweetFeedViewController:  DoneUpdateTweetDelegate {
    func doneUpdateTweet(tweet: Tweet, index: Int) {
        let indexPath = feedTableView.indexPathForSelectedRow
        feed.tweets[index] = tweet
        feedTableView.reloadData()
        StuffUtils.delay(0.2) {
            self.feedTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Middle)
        }
    }
}

protocol DoneTweetDelegate: class {
    func doneTweet(tweet: Tweet)
}

protocol DoneUpdateTweetDelegate: class {
    func doneUpdateTweet(tweet: Tweet, index: Int)
}
