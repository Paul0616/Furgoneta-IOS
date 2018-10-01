//
//  SupplyTableViewCell.swift
//  Furgoneta
//
//  Created by Paul Oprea on 30/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class SupplyTableViewCell: UITableViewCell {

    @IBOutlet weak var documentNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var documentNumberLabel: UILabel!
    @IBOutlet weak var documentDateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var switchDocSeen: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
