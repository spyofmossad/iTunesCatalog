//
//  MovieViewController.swift
//  iTunesCatalog
//
//  Created by Dmitry on 04.10.2020.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    var movie: Movie?
    var coverImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie,
           let coverImage = coverImage {
            prepareScreen(with: movie, cover: coverImage)
        }
    }
    
    private func prepareScreen(with movie: Movie, cover: UIImage) {
        genre.text = movie.primaryGenreName
        price.text = movie.fullPrice
        movieDescription.text = movie.longDescription
        self.cover.image = cover
    }
}
