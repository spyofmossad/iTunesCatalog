//
//  ArtistTableViewCell.swift
//  iTunesCatalog
//
//  Created by Dmitry on 02.10.2020.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var mainGenre: UILabel!
    
    func prepare(with artist: Artist) {
        artistName.text = artist.artistName
        mainGenre.text = artist.primaryGenreName
    }

}
