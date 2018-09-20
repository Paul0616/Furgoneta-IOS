//
//  DocumentModel.swift
//  Furgoneta
//
//  Created by Paul Oprea on 19/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class DocumentModel: NSObject {
    //MARK: - Propietati
    
    var id: Int?
    var hour: String?
    var type: String?
    var typeDocId: Int?
    var status: Int?
    var location: String?
    var day: String
    var header: Bool
    
    //MARK: - Initializare
    
    init?(header: Bool,
          day: String,
          id: Int? = nil,
          hour: String? = nil,
          type: String? = nil,
          typeDocId: Int? = nil,
          status: Int? = nil,
          location: String? = nil
        ) {
        
        //Initializeaza proprietatile
        self.header = header
        self.day = day
        self.id = id
        self.location = location
        self.type = type
        self.hour = hour
        self.typeDocId = typeDocId
        self.status = status
    }
}
