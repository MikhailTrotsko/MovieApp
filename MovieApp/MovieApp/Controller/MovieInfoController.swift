//
//  MovieInfoController.swift
//  MovieApp
//
//  Created by Таня on 03.12.18.
//  Copyright © 2018 Mikhail. All rights reserved.
//

import UIKit

class MovieInfoController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    var imdbId: String = ""
    var image: UIImage!
    var movie: Movie!
    var favorite: Favorite!
    
override func viewDidLoad() {
        super.viewDidLoad()
       
        if let _ = movie {
         searchMovieInfo()
        }
         configView(movie: movie, favorite: favorite)
     }
    
    func configView(movie: Movie?, favorite: Favorite?) {
        DispatchQueue.main.async {
            self.imageView.image = self.image
        }
        if let movie = movie {
            imdbId = movie.imdbId
            DispatchQueue.main.async {
                self.movieInfo.text = movie.plot ?? "Downloading Info"
       }
            if MovieDataBase.manager.isMovieInFavorites(movie: movie) {
                    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icHeartActive"), style: .plain, target: self, action: #selector(deletFavorite))
                } else {
                    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icHeartNoactive"), style: .plain, target: self, action: #selector(favButton(_:)))
                }
            }else if let favorite = favorite {
                imdbId = favorite.imdbId
                movieInfo.text = favorite.plot ?? "No Description"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icHeartActive"), style: .plain, target: self, action: #selector(deletFavorite))
        }
    }
    
    func searchMovieInfo() {
        guard let encodedString = movie.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        MovieApi.titleSearch(searchword: encodedString) { (error, movie) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let movie = movie {
                
                self.configView(movie: movie,favorite: nil)
                self.movie.plot = movie.plot
            }
        }
    }
    
    @IBAction func favButton(_ sender: UIBarButtonItem) {
        guard let image = imageView.image else { return }
        let _ = MovieDataBase.manager.addToFavorites(movie: movie, andImage: image)
        navigationController?.popViewController(animated: true)
    }
        
    @objc func deletFavorite() {
        guard let favoriteToBeRemoved = MovieDataBase.manager.getFavoriteWithId(imdbId: imdbId)
            else { return }
        let index = MovieDataBase.manager.getFavorites().index{$0.imdbId == imdbId}
        if let index = index {
            let _ = MovieDataBase.manager.deletFavorite(fromIndex: index, andMovieImage: favoriteToBeRemoved)
            navigationController?.popViewController(animated: true)
        }
    }
    
}
