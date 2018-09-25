//
//  MoneyModel.swift
//  Furgoneta
//
//  Created by Paul Oprea on 22/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class MoneyModel: NSObject {
    //MARK: - Propietati
    
    var value: Double
    var type: String
    var id: Int
    var pieces: Int
    var textField: UITextField
    var label: UILabel
    var key: String
   
    //MARK: - Initializare
    
    init?(type: String,
          value: Double,
          id: Int, textField: UITextField, pieces: Int, label: UILabel, key: String) {
        
        //Initializeaza proprietatile
        self.value = value
        self.type = type
        self.id = id
        self.textField = textField
        self.pieces = pieces
        self.label = label
        self.key = key
    }
}
