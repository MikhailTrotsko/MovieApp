//
//  ImageCell.swift
//  MovieApp
//
//  Created by Таня on 02.12.18.
//  Copyright © 2018 Mikhail. All rights reserved.
//


import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieLable: UILabel!
    
    func displayContent(image: UIImage, title: String) {
        imageView.image = image
        movieLable.text = title
    }
}
    

