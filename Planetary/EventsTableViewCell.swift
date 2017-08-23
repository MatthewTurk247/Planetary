//
//  EventsTableViewCell.swift
//  Hackin the Web
//
//  Created by Matthew Turk on 8/4/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventDescLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
