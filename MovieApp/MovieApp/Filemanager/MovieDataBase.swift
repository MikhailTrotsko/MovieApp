
//  MoviDataBase.swift
//  MovieApp
//
//  Created by Таня on 03.12.18.
//  Copyright © 2018 Mikhail. All rights reserved.


import UIKit

class MovieDataBase {

    static let pathName = "FavoriteData.plist"
 
    static let manager = MovieDataBase()

    var favorites = [Favorite]() {
        didSet{
            dataSave()
        }
    }
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath(withPathName path: String) -> URL {
        return MovieDataBase.manager.documentsDirectory().appendingPathComponent(path)
    }
    func dataSave() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favorites)
            // Does the writing to disk
            try data.write(to: dataFilePath(withPathName: MovieDataBase.pathName), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
        print ("Data in \(documentsDirectory())")
       
    }

    func load() {
        let path = dataFilePath(withPathName: MovieDataBase.pathName)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            favorites = try decoder.decode([Favorite].self, from: data)
        } catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }

    func addToFavorites(movie: Movie, andImage image: UIImage) -> Bool  {
     
        let indexExist = favorites.index{ $0.imdbId == movie.imdbId }
        if indexExist != nil { print("Favorit Exist"); return false }
        let success = storeImageToDisk(image: image, andMovie: movie)
        if !success { return false }
        let newFavorite = Favorite.init(title: movie.title, imdbId: movie.imdbId, poster: movie.poster, plot: movie.plot)
        favorites.append(newFavorite)
        return true
    }

    func storeImageToDisk(image: UIImage, andMovie movie: Movie) -> Bool {

        guard let imageData = UIImagePNGRepresentation(image) else { return false }

        let imageURL = MovieDataBase.manager.dataFilePath(withPathName: movie.imdbId)
        do {
            try imageData.write(to: imageURL)
        } catch {
            print("image saving error: \(error.localizedDescription)")
        }
        return true
    }

    func isMovieInFavorites(movie: Movie) -> Bool {

        let indexExist = favorites.index{ $0.imdbId == movie.imdbId }
        if indexExist != nil {
            return true
        } else {
            return false
        }
    }

    func getFavoriteWithId(imdbId: String) -> Favorite? {
        let index = getFavorites().index{$0.imdbId == imdbId}
        guard let indexFound = index else { return nil }
        return favorites[indexFound]
    }

    func getFavorites() -> [Favorite] {
        return favorites
    }

    func deletFavorite(fromIndex index: Int, andMovieImage favorite: Favorite) -> Bool {
        favorites.remove(at: index)

        let imageURL = MovieDataBase.manager.dataFilePath(withPathName: favorite.imdbId)
        do {
            try FileManager.default.removeItem(at: imageURL)
            
            print("\(imageURL) data removed")
            
            return true
        } catch {
            print("error removing: \(error.localizedDescription)")
            return false
        }
    }

}

