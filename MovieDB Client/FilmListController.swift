//
//  FilmListController.swift
//  Flickr Client
//
//  Created by Huynh Quang Thao on 3/11/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit
import AFNetworking

class FilmListController: UIViewController, UITableViewDataSource, UITableViewDelegate,
                            UISearchBarDelegate, UISearchResultsUpdating {
    
    enum TabType {
        case NOW_PLAYING
        case TOP_RATED
    }
    
    @IBOutlet weak var filmTableView: UITableView!
    
    var searchController: UISearchController!
    var searchBar: UISearchBar!
    
    var refreshControl: UIRefreshControl!
    
    var filmCollection: [FilmModel] = []
    var selectedFilmCollection: [FilmModel] = []
    
    var tabType: TabType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        setUpRefreshControl()
        setUpTableView()
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
            if tabType == TabType.NOW_PLAYING {
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
                }
            }
        })
        
        task.resume()

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! FilmDetailController
        let indexPath = filmTableView.indexPathForCell(sender as! UITableViewCell)
        vc.film = self.filmCollection[indexPath!.row]
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // Table View Delegate //////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.hqt.flickr.cell", forIndexPath: indexPath) as! FilmCell
        let film = selectedFilmCollection[indexPath.row]
        cell.filmDescriptionTextView.text = film.overview
        cell.filmTitleTextView.text = film.title
        
        // make fading effect for image when downloading from network
        let url = NSURL(string: APIHelper.getThumbnailImageUrl(film.posterPath))
        let request = NSURLRequest(URL: url!)
        
        cell.filmImageView.setImageWithURLRequest(request, placeholderImage: nil,
            success:{(imageRequest: NSURLRequest?, imageResponse: NSURLResponse?, image: UIImage?) -> Void in
                // imageResponse will be nil if image is loaded from cache
                if imageResponse != nil {
                    // intialize property before animate
                    cell.filmImageView.alpha = 0.0
                    cell.filmImageView.image = image
                    // make animation
                    UIView.animateWithDuration(1, animations: {() -> Void in
                        cell.filmImageView.alpha = 1.0
                    })
                } else {
                    // from cache. simply load
                    cell.filmImageView.image = image
                }
            },
            failure: {(imageRequest: NSURLRequest?, imageResponse: NSURLResponse?, error: NSError?) -> Void in
                print("loading image from network failed")
            })
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedFilmCollection.count
    }
    
    // remove background when click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    // Search Bar Delegate //////////////////////////////////////////////////////////////////////
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            print(searchText)
            //selectedFilmCollection = [FilmModel]()
            for film in filmCollection {
                if film.title.lowercaseString.rangeOfString(searchText) != nil {
                    print(film.title)
                    selectedFilmCollection.append(film)
                }
            }
        } else {
            //selectedFilmCollection = filmCollection
        }
        
        print(selectedFilmCollection.count)
        
        filmTableView.reloadData()
    }
}
