//
//  MovieCollectionViewCell.swift
//  iTunesCatalog
//
//  Created by Dmitry on 04.10.2020.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genre: UILabel!
    
    func prepare(with movie: Movie, cover image: UIImage) {
        name.text = movie.trackName
        genre.text = movie.primaryGenreName
        cover.image = image
    }
}
