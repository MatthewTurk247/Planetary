//
//  PSClassTableViewCell.swift
//  Planetary
//
//  Created by Matthew Turk on 7/26/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit

class PSClassTableViewCell: UITableViewCell {
    
    @IBOutlet var PSClassImageView: UIImageView!
    @IBOutlet var PSClassDescriptionLabel: UILabel!
    @IBOutlet var PSClassTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
