//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/23/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup button style
        loginButton.backgroundColor = UIColor.clearColor()
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func viewDidAppear(animated: Bool) {
        setUpScreen()
    }
    
    func setUpScreen() {
        // check if user is logged in
        if let user = DataBaseUtils.getSignedInUser() {
            print("user already log in")
            TwitterClient.currentUser = user
            self.performSegueWithIdentifier("FeedListSegue", sender: nil)
        } else {
            print("not log in")
        }
    }
    
    @IBAction func loginTwitter(sender: AnyObject) {
        TwitterClient.sharedInstance.requestToken({
            (user: User) -> () in
                print("login success")
                // save user to database
                DataBaseUtils.saveUser(user)
                TwitterClient.currentUser = user
            
                // switch to list screen
                self.performSegueWithIdentifier("FeedListSegue", sender: nil)
            }, failCallback: {
                (error: NSError) -> () in
                print("Login fail")
        })
    }
}
