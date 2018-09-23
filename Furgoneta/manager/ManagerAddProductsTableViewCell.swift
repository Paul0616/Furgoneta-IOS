//
//  ManagerAddProductsTableViewCell.swift
//  Furgoneta
//
//  Created by Paul Oprea on 23/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ManagerAddProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var umLabel: UILabel!
    @IBOutlet weak var selectedProductSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
