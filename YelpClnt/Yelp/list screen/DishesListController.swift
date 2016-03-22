//
//  DishesListController.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class DishesListController: UIViewController {
    
    @IBOutlet weak var dishesTableView: UITableView!
    
    var searchBar: UISearchBar!
    var searchController: UISearchController!
    
    var loadingControl: UIActivityIndicatorView!
    
    var businesses: [Business] = []
    
    var keyword: String!
    
    var filterCategories: [FilterGroup]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loading default configuration when just start app
        filterCategories = FilterFactory.FilterList
        
        setUpLoadingBar()
        
        setUpSearchView()
        
        setUpTableData()
    }
    
    func setUpLoadingBar() {
        loadingControl = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingControl.center = self.view.center
        loadingControl.startAnimating()
        self.view.addSubview(loadingControl)
    }
    
    func setUpSearchView() {
        // nil means current view controller as result controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        // prevent auto hide and add cancel button next to navigation view
        searchController.hidesNavigationBarDuringPresentation = false
        
        // make searchbar programmatically because we cannot drag searchbar into navigation view
        searchBar = searchController.searchBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        searchController.searchResultsUpdater = self
        // searchController.delegate = self
    }
    
    func setUpTableData() {
        dishesTableView.delegate = self
        dishesTableView.dataSource = self
        dishesTableView.rowHeight = UITableViewAutomaticDimension
        dishesTableView.estimatedRowHeight = 120
        
        keyword = "Thai"
        search()
    }
    
    func search() {
        FilterFactory.search(keyword, filters: filterCategories, callback: {
            (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.dishesTableView.reloadData()
            // remove loading
            self.loadingControl.stopAnimating()
        })
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let preferenceController = navigationController.viewControllers[0] as! PreferenceViewController
        preferenceController.delegate = self
        // because struct. in fact this is a new copy
        preferenceController.filterCategories = filterCategories
    }
}

// MARK: UITableViewDataSource
extension DishesListController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dishesTableView.dequeueReusableCellWithIdentifier("com.hqt.yelp.cell", forIndexPath: indexPath) as! YelpTableCell
        let dish = businesses[indexPath.row]
        
        cell.dishTitleTextView.text = dish.name
        cell.addressTextView.text = dish.address
        cell.ratingTextView.text = dish.reviewCount!.stringValue + " reviews"
        cell.categoriesTextView.text = dish.categories
        cell.priceTextView.text = dish.distance
        cell.ratingImageView.setImageWithURL(dish.ratingImageURL!)
    
        if let url = dish.imageURL {
            cell.dishImageView.setImageWithURL(url)
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension DishesListController: UITableViewDelegate {
    
}

// MARK: UISearchBar Updating Result
extension DishesListController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText =  searchController.searchBar.text {
            keyword = searchText
            search()
        }
    }
}

// MARK: SearchBar Delegate
extension DishesListController: UISearchBarDelegate {
    
}

// MARK: FilterDone Delegate
extension DishesListController: FilterDoneDelegate {
    func filterDone(filterCategories: [FilterGroup]) {
        // reset table first
        businesses = []
        dishesTableView.reloadData()
        
        // update value. we're using struct -> value will be copied
        self.filterCategories = filterCategories
        search()
    }
}

// MARK: UIScrollView Delegate
extension DishesListController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
}