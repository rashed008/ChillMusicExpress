//
//  MusicTrackCell.swift
//  MusicChill
//
//  Created by Hemal on 1/11/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import UIKit

class MusicTrackCell: UITableViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
