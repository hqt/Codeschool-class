//
//  FilmListController+SearchBarDelegate.swift
//  Flickr Client
//
//  Created by Huynh Quang Thao on 3/16/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

extension FilmListController: UISearchBarDelegate {
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
            selectedFilmCollection = []
            for film in filmCollection {
                if film.title.rangeOfString(searchText) != nil {
                    selectedFilmCollection.append(film)
                }
            }
            if searchText == "" {
                selectedFilmCollection = filmCollection
            }
        } else {
            //selectedFilmCollection = filmCollection
        }
        filmTableView.reloadData()
    }
}
