//
//  Constants.swift
//  AlamofireTest
//
//  Created by ebsadmin on 07/02/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import Foundation
struct Constants {
    struct Keys {
        static let feed = "feed"
        static let results = "results"
        static let artistName = "artistName"
        static let podCastName = "name"
        static let appName = "name"
        static let artistId = "artistId"
        static let podCastId = "id"
        static let releaseDate = "releaseDate"
        static let image = "artworkUrl100"
    }
    static let cellIdentifier = "cell"
    static let firstUrlPart = "https://rss.applemarketingtools.com/api/v2/"
    static let lastUrlPart = ".json"
    static let defaultCountry = "us"
    
    //MARK: - MusicViewController
    static let defaultMusicURL = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/25/albums.json"
    static let musicMiddleUrlPart = "/music/most-played/25/"
    static let musicSearchbarPlaceholder = "Search music"
    static let musicImgPlaceholder = "Default music.png"
    
    
    //MARK: - PodcastViewController
    static let defaultPodcastURL = "https://rss.applemarketingtools.com/api/v2/us/podcasts/top/10/podcast-episodes.json"
    static let podcastMiddleUrlPart = "/podcasts/top/10/"
    static let podcastSearchbarPlaceholder = "Search podcast"
    static let podcastImgPlaceholder = "Default podcast.jpeg"
    
    //MARK: - AppsViewController
    
    
    //MARK: - BooksViewController
    
    
}



