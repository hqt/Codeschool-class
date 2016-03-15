//
//  JSONHelper.swift
//  Flickr Client
//
//  Created by Huynh Quang Thao on 3/12/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

/// JSON Helper class for paring data
class JSONHelper: NSObject {
    
    // parsing to list of film
    static func ParsingFilmList(data: [NSDictionary]?) -> [FilmModel] {
        var filmCollections = [FilmModel]()
        for filmObject in data! {
            let film = ParsingFilm(filmObject)
            filmCollections.append(film)
        }
        return filmCollections
    }
    
    // parsing a single film object
    static func ParsingFilm(data: NSDictionary) -> FilmModel {
        let id = data["id"] as! Int
        let originalTitle = data["original_title"] as! String
        let originalLanguage = data["original_language"] as! String
        let title = data["title"] as! String
        let backdropPath = data["backdrop_path"] as? String ?? ""           // ??: if nil. using right. otherwise using left
        let popularity = data["popularity"] as! Double
        let voteCount =  data["vote_count"] as! Int
        let isVideo = data["video"] as! Bool
        let voteAverage = data["vote_average"] as! Double
        let posterPath = data["poster_path"] as! String
        let isAdult = data["adult"] as! Bool
        let overview = data["overview"] as! String
        let releaseDate = convertStringToDate(data["release_date"] as! String)
        
        return FilmModel(id: id, title: title, originalTitle: originalTitle, originalLanguage: originalLanguage,
            backdropPath: backdropPath, popularity: popularity, voteCount: voteCount, voteAverage: voteAverage,
            isVideo: isVideo, posterPath: posterPath, isAdult: isAdult, overview: overview, releaseDate: releaseDate)
    }
    
    static func convertStringToDate(dateStr: String) -> NSDate {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.dateFromString(dateStr)!
    }
}
