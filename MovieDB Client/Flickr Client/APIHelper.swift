//
//  APIHelper.swift
//  Flickr Client
//
//  Created by Huynh Quang Thao on 3/12/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class APIHelper: NSObject {
    static func getNowPlayingAPI() -> String {
        return Constant.MOVIE_SERVER + Constant.MOVIE_API_NOW_PLAYING + "?api_key=" + Constant.MOVIE_API_KEY;
    }
    
    static func getTopRatedAPI() -> String {
        return Constant.MOVIE_SERVER + Constant.MOVIE_API_TOP_RATED + "?api_key=" + Constant.MOVIE_API_KEY
    }
    
    static func getImageFullSizeUrl(filePath: String) -> String {
        return Constant.FULL_SIZE_SERVER + filePath
    }
    
    static func getThumbnailImageUrl(filePath: String) -> String {
        return Constant.THUMBNAIL_SIZE_SERVER + filePath
    }
}
