//
//  SearchMoviesViewController.swift
//  iTunesCatalog
//
//  Created by Dmitry on 04.10.2020.
//

import UIKit

class SearchMoviesViewController: SearchController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let itemsCount: CGFloat = 2
    private let padding: CGFloat = 10
    private var movies: Movies?
    private let networkService: NetworkServicePotocol
    private let imagesService: ImageService
    
    required init?(coder: NSCoder) {
        self.networkService = NetworkService()
        self.imagesService = ImageService()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.delegate = self
        showPlaceholder(with: "Hey, looking for something?")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ShowMovie {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let movieViewCotroller = segue.destination as! MovieViewController
                movieViewCotroller.movie = movies?.results[indexPath.row]
                imagesService.getImage(from: movies?.results[indexPath.row].artworkUrl100) { (data) in
                    if let data = data {
                        movieViewCotroller.coverImage = UIImage(data: data)
                    }
                }
                
            }
        }
    }
    
    @objc private func getMovies() {
        networkService.searchMovies(by: searchController.searchBar.text!) { [weak self] (movies) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if movies.resultCount > 0 {
                    self.movies = movies
                    self.collectionView.reloadData()
                    self.removePlaceholder()
                } else {
                    self.showPlaceholder(with: "Oops, found nothing")
                }
            }
            self.isLoading = false
        }
    }
}

extension SearchMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - padding * (itemsCount + 1)
        let itemWidth = width / itemsCount
        return CGSize(width: itemWidth, height: itemWidth * 1.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
}

extension SearchMoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.resultCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionCells.Movie, for: indexPath) as? MovieCollectionViewCell
        if let cell = cell, let movie = movies?.results[indexPath.row] {
            imagesService.getImage(from: movie.artworkUrl100) { (data) in
                DispatchQueue.main.async {
                    if let data = data {
                        cell.prepare(with: movie, cover: UIImage(data: data) ?? UIImage(named: "no-image")!)
                    }
                }
            }
            return cell
        }
    
        return UICollectionViewCell()
    }
}

extension SearchMoviesViewController: SearchBarDelegate {
    func fetchData() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getMovies), object: nil)
        self.perform(#selector(getMovies), with: nil, afterDelay: 0.6)
    }
}
