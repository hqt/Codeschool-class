//
//  FilmListController+UITableViewDataSource.swift
//  Flickr Client
//
//  Created by Huynh Quang Thao on 3/16/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

// MARK: -UITableViewDataSource
extension FilmListController: UITableViewDataSource {
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
        return self.selectedFilmCollection.count
    }
    
    // remove background when click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
