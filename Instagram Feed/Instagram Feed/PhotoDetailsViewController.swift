//
//  PhotoDetailsViewController.swift
//  Instagram Feed
//
//  Created by Huynh Quang Thao on 3/11/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageDetail: UIImageView!
    
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDetail.setImageWithURL(NSURL(string: imageUrl!)!)
    }
}
