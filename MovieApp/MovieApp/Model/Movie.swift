//
//  Movie.swift
//  MovieSearch
//
//  Created by Таня on 03.12.18.
//  Copyright © 2018 Mikhail. All rights reserved.

import Foundation

struct Movie: Decodable {
    let title: String
    let imdbId: String
    let poster: URL
    var plot: String?
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case imdbId = "imdbID"
        case poster = "Poster"
        case plot = "Plot"
    }
}

struct SearchResults: Decodable {
    let search: [Movie]
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}



