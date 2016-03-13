//
//  ViewController.swift
//  Instagram Feed
//
//  Created by Huynh Quang Thao on 3/9/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var imageBlockList = [NSDictionary]()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PhotoDetailsViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        vc.imageUrl = ImageHelper.GetUrl(imageBlockList[indexPath!.row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set property
        tableView.rowHeight = 100
        
        // assign delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // build request
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=" + clientId)
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession(configuration:
            NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let task : NSURLSessionTask = session.dataTaskWithRequest(request,
            completionHandler: {
                (dataOrNil: NSData?, response: NSURLResponse?, error: NSError?) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options: []) as? NSDictionary {
                            self.imageBlockList = responseDictionary["data"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        })
        
        task.resume()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageBlockList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.hqt.imagecell", forIndexPath: indexPath) as! ImageCell
        let urlStr = ImageHelper.GetUrl(imageBlockList[indexPath.row])
        let url = NSURL(string: urlStr)
        cell.imageView?.setImageWithURL(url!)
        return cell
    }
    
    // remove background when click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

