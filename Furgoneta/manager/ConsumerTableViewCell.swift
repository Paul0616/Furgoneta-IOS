//
//  ConsumerTableViewCell.swift
//  Furgoneta
//
//  Created by Paul Oprea on 19/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ConsumerTableViewCell: UITableViewCell {

    @IBOutlet weak var um: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var motivation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
