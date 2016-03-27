//
//  TwitterStyleNavigationBar|.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/27/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class TwitterStyleNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change title text color
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
      
        // color apply to navigation item
        self.navigationBar.tintColor = UIColor.whiteColor()
        
        // color apply to navigation bar background
        self.navigationBar.barTintColor = UIColorFromRGB(0x55ACEE)
      
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
