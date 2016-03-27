//
//  PostTweetController.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/27/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class PostTweetController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var casualNameTextView: UILabel!
    
    @IBOutlet weak var userNameTextView: UILabel!
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    @IBOutlet weak var contentTextField: UITextView!
    
    var user: User!
    var replyTweet: Tweet?
    
    var delegate: DoneTweetDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetButton.enabled = false
        
        user = TwitterClient.currentUser!
        avatarImageView.setImageWithURL(NSURL(string:user.profileUrl!)!)
        casualNameTextView.text = user.name
        userNameTextView.text = user.screename
        contentTextField.text = ""
        contentTextField.delegate = self
        
        if replyTweet != nil {
            navigationController?.navigationBar.topItem?.title = "Reply Tweet"
        } else {
            navigationController?.navigationBar.topItem?.title = "New Tweet"
        }
    }
    
    
    @IBAction func cancelTweet(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTweet(sender: AnyObject) {
        if let replyTweet = replyTweet {
            TwitterClient.sharedInstance.reply(contentTextField.text!, repliedTweet: replyTweet)
        } else {
            TwitterClient.sharedInstance.tweet(contentTextField.text!)
        }
        
        let tweet = Tweet(id: "", text: contentTextField.text, retweetCount: 0, favourteCount: 0, isFavourite: false, isReTweeted: false, time: NSDate(), user: user)
        delegate.doneTweet(tweet)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func remainingContent() -> Int {
        let usedCharacters = contentTextField.text?.characters.count ?? 0
        return 140 - usedCharacters
    }
}

extension PostTweetController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        if contentTextField.text?.characters.count == 0 {
            tweetButton.enabled = false
        } else if remainingContent() <= 0 {
            tweetButton.enabled = false
            tweetButton.title = "Tweet(0)"
        } else {
            tweetButton.enabled = true
            tweetButton.title = "Tweet(\(remainingContent()))"
        }
    }
}