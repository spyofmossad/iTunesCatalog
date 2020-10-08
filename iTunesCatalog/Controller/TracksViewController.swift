//
//  TrackTableViewController.swift
//  iTunesCatalog
//
//  Created by Dmitry on 03.10.2020.
//

import UIKit

class TracksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var albumId: Int?
    var networkService: NetworkServicePotocol?
    
    private var tracks: [Track]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner()
        getTracksData()
    }
    
    private func getTracksData() {
        if let albumId = albumId {
            networkService?.getTracks(byAlbum: albumId, completion: { [weak self] (tracks) in
                guard let self = self else { return }
                self.tracks = tracks.results.filter({ (instance) -> Bool in
                    return instance.wrapperType == .track
                })
                DispatchQueue.main.async {
                    self.navigationItem.title = tracks.results.first?.artistAlbum
                    self.tableView.reloadData()
                    self.removePlaceholder()
                }
            }
        )}
    }
}

extension TracksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tracks = tracks {
            return tracks.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCells.Track, for: indexPath) as? TrackTableViewCell
        if let cell = cell,
           let track = tracks?[indexPath.row] {
            cell.prepare(with: track)
            return cell
        }
        return UITableViewCell()
    }
}
