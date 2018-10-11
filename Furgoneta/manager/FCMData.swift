//
//  FCMData.swift
//  Furgoneta
//
//  Created by Paul Oprea on 10/10/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class FCMData: Codable {
    var to: String
    
    var notification: NotificationModel
    var data: NotificationModel
   
    
    init?(to: String, sound: String, body: String,
          title: String, location: String) {
        self.to = to
        let n = NotificationModel.init(sound: sound, body: body, title: title, location: location)
        self.notification = n!
        self.data = n!
    
    }
    
    class NotificationModel: Codable {
        var sound: String
        var body: String
        var title: String
        var location: String
        
        init?(sound: String, body: String,
              title: String, location: String) {
            self.sound = sound
            self.body = body
            self.title = title
            self.location = location
        }
        
    }
}
