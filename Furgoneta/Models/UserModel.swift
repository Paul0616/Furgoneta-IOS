//
//  UserModel.swift
//  Furgoneta
//
//  Created by Paul Oprea on 10/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    //MARK: - Propietati
    
    var id: Int
    var status: Bool
    var userFirstName: String
    var userLastName: String
    var role: String
    var nickName: String
    var password: String
    var phone: String?
    var email: String?
    
    
    //MARK: - Initializare
    
    init?(id: Int, status: Bool,
          userFirstName: String,
          userLastName: String,
          role: String,
          nickName: String,
          password: String,
          phone: String? = nil,
          email: String? = nil
        ) {
        
        //Initializeaza proprietatile
        self.id = id
        self.status = status
        self.userLastName = userLastName
        self.userFirstName = userFirstName
        self.role = role
        self.nickName = nickName
        self.password = password
        self.phone = phone
        self.email = email
    }
}
