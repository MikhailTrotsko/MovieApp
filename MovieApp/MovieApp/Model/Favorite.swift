//
//  Favorite.swift
//  MovieSearch
//
//  Created by Таня on 03.12.18.
//  Copyright © 2018 Mikhail. All rights reserved.

import UIKit

struct Favorite: Codable {
    let title: String
    let imdbId: String
    let poster: URL
    let plot: String?
 
    var image: UIImage? {
        set{}
        get {
            let imageURL = MovieDataBase.manager.dataFilePath(withPathName: imdbId)
            let docImage = UIImage(contentsOfFile: imageURL.path)
            return docImage
        }
    }
}


