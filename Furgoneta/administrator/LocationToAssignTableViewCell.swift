//
//  LocationToAssignTableViewCell.swift
//  Furgoneta
//
//  Created by Paul Oprea on 16/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class LocationToAssignTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var checkSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
