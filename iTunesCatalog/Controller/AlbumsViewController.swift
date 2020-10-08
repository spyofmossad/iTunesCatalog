//
//  AlbumsTableViewController.swift
//  iTunesCatalog
//
//  Created by Dmitry on 02.10.2020.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var artistId: Int?
    var networkService: NetworkServicePotocol?
    var imagesService: ImageService?
    
    private var albums: [Album]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner()
        tableView.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.TableCells.Album)
        getAlbumsData()
    }
    
    private func getAlbumsData() {
        if let artistId = artistId {
            networkService?.getAlbums(byArtist: artistId) { [weak self] (albums) in
                guard let self = self else { return }
                self.albums = albums.results.filter({ (instance) -> Bool in
                    return instance.wrapperType == .collection
                })
                DispatchQueue.main.async {
                    if let artistName = self.albums?.first?.artistName {
                        self.navigationItem.title = artistName
                    }
                    self.tableView.reloadData()
                    self.removePlaceholder()
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ShowTracks {
            if let indexPath = tableView.indexPathForSelectedRow {
                let tracksViewController = segue.destination as! TracksViewController
                tracksViewController.albumId = albums?[indexPath.row].collectionId
                tracksViewController.networkService = networkService
            }
            
            let backItem = UIBarButtonItem()
            backItem.title = Constants.NavigationTitles.Albums
            navigationItem.backBarButtonItem = backItem
        }
    }
}

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let albums = albums {
            return albums.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCells.Album, for: indexPath) as? AlbumTableViewCell
        
        if let cell = cell, let album = albums?[indexPath.row] {
            imagesService?.getImage(from: album.artworkUrl60) { (data) in
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

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.ShowTracks, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
