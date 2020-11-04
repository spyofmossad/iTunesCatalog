//
//  SearchAlbumTableViewCell.swift
//  iTunesCatalog
//
//  Created by Dmitry on 05.10.2020.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumPrice: UILabel!
    
    func prepare(with album: Album) {
        albumName.text = album.collectionName
        albumPrice.text = album.fullPrice
    }
}
