//
//  ApplicationEnum.swift
//  AlamofireTest
//
//  Created by ebsadmin on 08/02/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import Foundation
struct Enum {
    enum CountryMenu: String, CaseIterable {
        case India     = "in"
        case Usa       = "us"
        case HongKong  = "hk"
        case Egypt     = "eg"
    }
    enum TypeMenu: String {
        case Albums         = "albums"
        case MusicVideos    = "music-videos"
        case Playlist       = "playlists"
        case Songs          = "songs"
        case PodcastEpisode = "podcast-episodes"
        case Podcasts       = "podcasts"
    }
}
