//
//  LocationModel.swift
//  Furgoneta
//
//  Created by Paul Oprea on 10/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class LocationModel: NSObject {
    //MARK: - Propietati
    
    var id: Int
    var locationName: String
    var selected: Bool = false

    //MARK: - Initializare
    
    init?(id: Int,
          locationName: String
        ) {
        
        //Initializeaza proprietatile
        self.id = id
        self.locationName = locationName
    }
    
   
}
