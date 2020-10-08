//
//  AlbumsTableViewController.swift
//  iTunesCatalog
//
//  Created by Dmitry on 02.10.2020.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    var artistId: Int?
    private var albums: [Album]?

    override func viewDidLoad() {
        super.viewDidLoad()
        getAlbumsData()
    }
    
    private func getAlbumsData() {
        if let artistId = artistId {
            NetworkManager.shared.getAlbums(byArtistId: artistId) { (albums) in
                self.albums = albums.results.filter({ (instance) -> Bool in
                    return instance.wrapperType == .collection
                })
                DispatchQueue.main.async {
                    if let artistName = self.albums?.first?.artistName {
                        self.navigationItem.title = artistName
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let albums = albums {
            return albums.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCells.Album, for: indexPath) as? AlbumTableViewCell
        
        if let cell = cell, let album = albums?[indexPath.row] {
            cell.prepare(with: album)
            return cell
        }

        return UITableViewCell()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ShowTracks {
            if let indexPath = tableView.indexPathForSelectedRow {
                let tracksViewController = segue.destination as! TrackTableViewController
                tracksViewController.albumId = albums?[indexPath.row].collectionId
            }
            
            let backItem = UIBarButtonItem()
            backItem.title = Constants.NavigationTitles.Albums
            navigationItem.backBarButtonItem = backItem
        }
    }
}
