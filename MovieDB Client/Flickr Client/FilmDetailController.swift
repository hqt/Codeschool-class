//
//  FilmDetailController.swift
//  Flickr Client
//
//  Created by Huynh Quang Thao on 3/11/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit
import AFNetworking

class FilmDetailController: UIViewController {
    
    var film: FilmModel!
    
    @IBOutlet weak var contentscrollView: UIScrollView!
    
    @IBOutlet weak var filmImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTitleBar()
        
        let fullSizeUrl = NSURL(string: APIHelper.getImageFullSizeUrl(film.posterPath))
        let thumbnailSizeUrl = NSURL(string: APIHelper.getThumbnailImageUrl(film.posterPath))
        
        let fullSizeRequest = NSURLRequest(URL: fullSizeUrl!)
        let thumbnailSizeRequest = NSURLRequest(URL: thumbnailSizeUrl!)
        
        // loading image
        self.filmImage.setImageWithURLRequest(
            thumbnailSizeRequest,
            placeholderImage: nil,
            success: {(request: NSURLRequest?, response: NSURLResponse?, image: UIImage?) in
                print("Download thumbnail success")
                
                // make fade animation
                self.filmImage.alpha = 0.0
                self.filmImage.image = image
                UIView.animateWithDuration(0.5,
                    animations: {() -> Void in
                        self.filmImage.alpha = 1
                    },
                    // AFNetworking allows only one request per ImageView at a time. so we must put in complete block
                    completion: {(success) -> Void in
                        // download full size image again by nest block
                        self.filmImage.setImageWithURLRequest(fullSizeRequest, placeholderImage: image,
                            success: {(request: NSURLRequest?, response: NSURLResponse?, image: UIImage?) -> Void in
                                print("Download fullsize success")
                            },
                            failure: {(request: NSURLRequest?, response: NSHTTPURLResponse?, error: NSError) -> Void in
                                print("Download fullsize failed")
                        })
                    }
                )
            },
            failure: {(request: NSURLRequest?, response: NSURLResponse?, error: NSError?) in
                print("Download thumbnail failed")
            })
        
        
        self.filmImage.setImageWithURL(NSURL(string: APIHelper.getImageFullSizeUrl(film.posterPath))!)
    }
    
    func setUpTitleBar() {
        // create UILabel
        let titleLabel = UILabel()
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        shadow.shadowOffset = CGSizeMake(2, 2);
        shadow.shadowBlurRadius = 2;
        
        // create decorated text
        let titleText = NSAttributedString(string: film.title, attributes: [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(20),
            NSForegroundColorAttributeName : UIColor(red: 0.41, green: 0.128, blue: 0.185, alpha: 0.8),
            NSShadowAttributeName : shadow
            ])
        
        titleLabel.attributedText = titleText
        titleLabel.sizeToFit()
        
        // set to navigation bar
        navigationItem.titleView = titleLabel

    }
}
