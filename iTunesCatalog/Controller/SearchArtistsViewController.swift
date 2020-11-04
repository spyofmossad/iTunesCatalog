//
//  ViewController.swift
//  iTunesCatalog
//
//  Created by Dmitry on 01.10.2020.
//

import UIKit

class SearchArtistViewController: SearchController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let networkService: NetworkServicePotocol
    private var artists: Artists?
    
    required init?(coder: NSCoder) {
        self.networkService = NetworkService()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.delegate = self
        showPlaceholder(with: "Hey, looking for something?")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navHeight = self.navigationController?.navigationBar.frame.origin.y
        
        if navHeight! > 0 {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: navHeight! * 2.2)
            ])
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ShowAlbums {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let albumsViewController = segue.destination as? AlbumsViewController else { return }
                albumsViewController.artistId = artists?.results[indexPath.row].artistId
                albumsViewController.networkService = networkService
                albumsViewController.imagesService = ImageService()
            }
        }
    }
    
    @objc private func getArtists() {
        networkService.searchArtists(by: searchController.searchBar.text!) { [weak self] (artists) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if artists.resultCount > 0 {
                    self.artists = artists
                    self.tableView.reloadData()
                    self.removePlaceholder()
                    } else {
                        self.showPlaceholder(with: "Oops, found nothing")
                    }
                }
            }
            self.isLoading = false
        }
}

extension SearchArtistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let artists = artists {
            return artists.resultCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = artists?.results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCells.Artist) as? ArtistTableViewCell
        if let artist = artist, let cell = cell {
            cell.prepare(with: artist)
            return cell
        }
        return UITableViewCell()
    }
}

extension SearchArtistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchArtistViewController: SearchBarDelegate {
    func fetchData() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getArtists), object: nil)
        self.perform(#selector(getArtists), with: nil, afterDelay: 0.6)
    }
}
