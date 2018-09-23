//
//  TodayDocumentsTableViewCell.swift
//  Furgoneta
//
//  Created by Paul Oprea on 23/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class TodayDocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var documentTypeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var documentDateLabel: UILabel!
    @IBOutlet weak var documentTimeLabel: UILabel!
    @IBOutlet weak var changeStatusButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
