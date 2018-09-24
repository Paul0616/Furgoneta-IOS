//
//  DocumentItem.swift
//  Furgoneta
//
//  Created by Paul Oprea on 19/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class DocumentItem: NSObject {
    //MARK: - Propietati
    
    var product: String
    var um: String
    var quantity: Double
    var motivation: String
    var productId: Int
    
    //MARK: - Initializare
    
    init?(product: String,
          um: String,
          quantity: Double,
          motivation: String,
          id: Int) {
        
        //Initializeaza proprietatile
        self.product = product
        self.um = um
        self.quantity = quantity
        self.motivation = motivation
        self.productId = id
    }
}
