//
//  ImageHelper.swift
//  Instagram Feed
//
//  Created by Huynh Quang Thao on 3/11/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class ImageHelper: NSObject {
    
    static func GetUrl(data: NSDictionary) -> String {
        let imageBlock = data["images"] as! NSDictionary
        let imageType = imageBlock["standard_resolution"] as! NSDictionary
        let url: String = imageType["url"] as! String
        return url;
    }
}
