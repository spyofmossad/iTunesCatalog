//
//  TrackTableViewCell.swift
//  iTunesCatalog
//
//  Created by Dmitry on 03.10.2020.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var track: UILabel!
    @IBOutlet weak var timing: UILabel!
    
    func prepare(with albumTrack: Track) {
        track.text = albumTrack.trackWithNumber
        timing.text = (Double(albumTrack.trackTimeMillis ?? 0) / 1000).minutesSeconds
    }
}
