//
//  SearchAlbumsTableViewController.swift
//  iTunesCatalog
//
//  Created by Dmitry on 04.10.2020.
//

import UIKit

class SearchAlbumsViewController: SearchController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var albums: [Album]?
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
        tableView.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.TableCells.SearchAlbum)
        showPlaceholder(with: "Hey, looking for something?")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ShowSearchAlbumTracks {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let tracksViewController = segue.destination as? TracksViewController else { return }
                tracksViewController.albumId = albums?[indexPath.row].collectionId
                tracksViewController.networkService = networkService
            }
            
            let backItem = UIBarButtonItem()
            backItem.title = Constants.NavigationTitles.Albums
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    @objc private func getAlbums() {
        networkService.searchAlbums(by: searchController.searchBar.text!) { [weak self] (albums) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if albums.resultCount > 0 {
                    self.albums = albums.results.filter({ (album) -> Bool in
                        album.wrapperType == .collection
                    })
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

extension SearchAlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let albums = albums {
            return albums.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albums?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCells.SearchAlbum) as? AlbumTableViewCell
        if let album = album, let cell = cell {
            imagesService.getImage(from: album.artworkUrl60) { (data) in
                DispatchQueue.main.async {
                    if let data = data {
                        cell.prepare(with: album, cover: UIImage(data: data) ?? UIImage(named: "no-image")!)
                    }
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension SearchAlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.ShowSearchAlbumTracks, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchAlbumsViewController: SearchBarDelegate {
    func fetchData() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getAlbums), object: nil)
        self.perform(#selector(getAlbums), with: nil, afterDelay: 0.6)
    }
}
