//
//  RoleModel.swift
//  Furgoneta
//
//  Created by Paul Oprea on 11/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class RoleModel: NSObject {
    //MARK: - Propietati
    
    var id: Int
    var roleName: String
    
    //MARK: - Initializare
    
    init?(id: Int,
          roleName: String
        ) {
        
        //Initializeaza proprietatile
        self.id = id
        self.roleName = roleName
    }
}
