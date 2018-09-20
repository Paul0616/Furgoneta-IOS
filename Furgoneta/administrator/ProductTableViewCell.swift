//
//  ProductTableViewCell.swift
//  Furgoneta
//
//  Created by Paul Oprea on 09/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var unitsProductLabel: UILabel!
    @IBOutlet weak var supplySwitch: UISwitch!
    @IBOutlet weak var expeditureSwitch: UISwitch!
    @IBOutlet weak var fixtureSwitch: UISwitch!
  
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var delButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
