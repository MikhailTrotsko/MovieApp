//
//  FavoriteController.swift
//  MovieApp
//
//  Created by Таня on 03.12.18.
//  Copyright © 2018 Mikhail. All rights reserved.
//

import UIKit

class FavoriteController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var favoriteView: UICollectionView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
       favoriteView.delegate = self
       favoriteView.dataSource = self 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteView.reloadData()
    
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showInfo" {
                let infoVC = segue.destination as! MovieInfoController
                let cell = sender as! ImageCell
                guard let indexPath = favoriteView.indexPath(for: cell) else { return }
                infoVC.favorite = MovieDataBase.manager.getFavorites()[indexPath.row]
                infoVC.image = cell.imageView.image
        }
    }

}
extension FavoriteController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieDataBase.manager.getFavorites().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let favorite = MovieDataBase.manager.getFavorites()[indexPath.row]
        configureMovie(favorite: favorite, forCell: cell)
        return cell
    }
    
    func configureMovie(favorite: Favorite, forCell cell: ImageCell) {
        cell.imageView.image = favorite.image
    }
}
