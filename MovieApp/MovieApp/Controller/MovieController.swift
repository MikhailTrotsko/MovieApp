//
//  MovieController.swift
//  MovieApp
//
//  Created by Таня on 02.12.18.
//  Copyright © 2018 Mikhail. All rights reserved.
//

import UIKit

class MovieController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var moviesView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
   
    var image: UIImage!
    var movies = [Movie]() {
       didSet {
         DispatchQueue.main.async {
       self.moviesView.reloadData()
        }
      }
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
             
        moviesView.delegate = self
        moviesView.dataSource = self
        searchBar.delegate = self
               
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo" {
            let infoVC = segue.destination as! MovieInfoController
            let cell = sender as! ImageCell
        if let indexPath = moviesView.indexPath(for: cell) {
            infoVC.movie = movies[indexPath.row]
            infoVC.image = cell.imageView.image
                
            }
        }
    }
}

    extension MovieController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
             guard let searchText = searchBar.text else { return }
            if !searchText.isEmpty {
             guard let encodedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
              MovieApi.searchMovie(searchword: encodedString, completion: { (error, movies) in
                if let error = error {
                    let alertController = UIAlertController(title: "Search error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    } else if let movies = movies {
                        self.movies = movies
                    }
                })
            }
        }
    }

    extension MovieController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return movies.count
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            let movie = movies[indexPath.row]
            configureMovie(movie: movie, forCell: cell, lable: movie.title)
            
            return cell
        }
        
    func configureMovie(movie: Movie, forCell cell: ImageCell, lable: String ) {
            DispatchQueue.global().async {
                do {
                    let imageData = try Data.init(contentsOf: movie.poster)
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage.init(data: imageData)
                        cell.movieLable.text = movie.title
                      }
                   } catch {
                    print("image processing error: \(error.localizedDescription)")
                }
            }
        }
    }
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

