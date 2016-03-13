//
//  FilmModel.swift
//  Flickr Client
//
//  Created by Huynh Quang Thao on 3/12/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class FilmModel: NSObject {
    let id: Int
    let title: String
    let originalTitle: String
    let originalLanguage: String
    let backdropPath: String
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double
    let isVideo: Bool
    let posterPath: String
    let isAdult: Bool
    let overview: String
    let releaseDate: NSDate
    
    init(id: Int, title: String, originalTitle: String, originalLanguage: String, backdropPath: String,
        popularity: Double, voteCount: Int, voteAverage: Double, isVideo: Bool, posterPath: String,
        isAdult: Bool, overview: String, releaseDate: NSDate) {
            self.id = id
            self.title = title
            self.originalTitle = originalTitle
            self.originalLanguage = originalLanguage
            self.backdropPath = backdropPath
            self.popularity = popularity
            self.voteCount = voteCount
            self.voteAverage = voteAverage
            self.isVideo = isVideo
            self.posterPath = posterPath
            self.isAdult = isAdult
            self.overview = overview
            self.releaseDate = releaseDate
    }
    

}
