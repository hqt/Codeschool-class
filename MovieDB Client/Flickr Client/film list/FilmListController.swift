//
//  FilmListController.swift
//  Flickr Client
//
//  Created by Huynh Quang Thao on 3/11/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit
import AFNetworking

class FilmListController: UIViewController, UISearchResultsUpdating {
    
    enum TabType {
        case NOW_PLAYING
        case TOP_RATED
    }
    
    @IBOutlet weak var filmTableView: UITableView!
    
    var searchController: UISearchController!
    var searchBar: UISearchBar!
    
    var refreshControl: UIRefreshControl!
    
    var loadingControl: UIActivityIndicatorView!
    
    var filmCollection: [FilmModel] = []
    var selectedFilmCollection: [FilmModel] = []
    
    var tabType: TabType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpLoadingBar()
        setUpSearchBar()
        setUpRefreshControl()
        
        // stimulate slow network
        NetworkHelper.delay(2) {
            self.setUpTableView()
            
        }
    }
    
    func setUpLoadingBar() {
        loadingControl = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingControl.center = self.view.center
        loadingControl.startAnimating()
        self.view.addSubview(loadingControl)
    }
    
    func setUpNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.grayColor().colorWithAlphaComponent(1)
            shadow.shadowOffset = CGSizeMake(2, 2);
            shadow.shadowBlurRadius = 5;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(30),
                NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
                NSShadowAttributeName : shadow
            ]
        }
    }
    
    func setUpSearchBar() {
        // nil means: use this controller for displaying result
        searchController = UISearchController(searchResultsController: nil)
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        searchBar = searchController.searchBar
        // use same controller. dim out doesn't make sense
        searchController.dimsBackgroundDuringPresentation = false
        searchBar.sizeToFit()
        
        // configure search bar programmatically because we cannot drag it into search bar
        // UIViewController come with navigationItem. this wil intialize automatically if this view controller is add to navigation controller's stack
        navigationItem.titleView = searchBar
        
        // default. navigation bar hides when presenting search interface. so we set again to false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        searchBar.delegate = self
        
    }
    
    func setUpTableView() {
        // configure table view
        filmTableView.dataSource = self
        filmTableView.delegate = self
        downloadData()
    }
    
    func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        filmTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        downloadData()
    }
    
    func downloadData() {
        // configure for downloading data
        
        // using closure for making constant base on condition
        let url: NSURL = {
            if self.tabType == TabType.NOW_PLAYING {
                return NSURL(string: APIHelper.getNowPlayingAPI())!
            } else {
                return NSURL(string: APIHelper.getTopRatedAPI())!
            }
        }()
        print(url.absoluteString)
        
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(dataOrNil: NSData?, response: NSURLResponse?, error: NSError?) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                    // parsing data
                    self.filmCollection = JSONHelper.ParsingFilmList(responseDictionary["results"] as? [NSDictionary])
                    self.selectedFilmCollection = self.filmCollection
                    
                    // reload data into table view again
                    self.filmTableView.reloadData()
                    
                    // stop spinning refresh control
                    if (self.refreshControl.refreshing) {
                        self.refreshControl.endRefreshing()
                    }
                    
                    // remove loading 
                    self.loadingControl.stopAnimating()
                }
            } else {
                let alert = UIAlertController(title: "Error!", message:"Getting data error ...", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}
            }
        })
        
        task.resume()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! FilmDetailController
        let indexPath = filmTableView.indexPathForCell(sender as! UITableViewCell)
        vc.film = self.selectedFilmCollection[indexPath!.row]
    }
}
