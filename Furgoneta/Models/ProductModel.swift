//
//  ProductModel.swift
//  Furgoneta
//
//  Created by Paul Oprea on 09/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ProductModel: NSObject {
    //MARK: - Propietati
    
    var id: Int
    var supply: Bool
    var expediture: Bool
    var fixture: Bool
    var productName: String
    var productUnit: String
    
    
    
    //MARK: - Initializare
    
    init?(id: Int, supply: Bool,
          expediture: Bool,
          fixture: Bool,
          productName: String,
          productUnit: String
        ) {
        
        //Initializeaza proprietatile
        self.id = id
        self.supply = supply
        self.expediture = expediture
        self.fixture = fixture
        self.productName = productName
        self.productUnit = productUnit
    }
}
