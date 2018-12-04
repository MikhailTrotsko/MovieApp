//
//  MovieApi.swift
//  MovieApp
//
//  Created by Таня on 01.12.18.
//  Copyright © 2018 Mikhail. All rights reserved.
//

import Foundation

class MovieApi {
    
    static let firstMovieData = "https://www.omdbapi.com/?apikey=f7214d31&s="
    static let secondMovieData = "https://www.omdbapi.com/?apikey=f7214d31&t="
    
static func searchMovie (searchword: String, completion: @escaping (Error?, [Movie]?) -> Void) {
    URLSession.shared.dataTask(with: URL(string: "\(MovieApi.firstMovieData)\(searchword)")!, completionHandler: { (data, response, error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(SearchResults.self, from: data)
                    completion(nil, searchResults.search)
                } catch {
                    print("error")
                }
            }
        }).resume()
    }
    
static func titleSearch(searchword: String, completion: @escaping (Error?, Movie?) -> Void) {
    URLSession.shared.dataTask(with: URL(string: "\(MovieApi.secondMovieData)\(searchword)")!, completionHandler: { (data, response, error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(Movie.self, from: data)
                    completion(nil, movie)
                } catch {
                    print("error")
                }
            }
        }).resume()
    }
    
}
    
    
    

