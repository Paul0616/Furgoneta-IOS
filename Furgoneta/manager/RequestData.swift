//
//  RequestData.swift
//  Furgoneta
//
//  Created by Paul Oprea on 25/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class RequestData :  Codable {
    var lei_500: Int
    var lei_200: Int
    var lei_100: Int
    var lei_50: Int
    var lei_10: Int
    var lei_5: Int
    var lei_1: Int
    var bani_50: Int
    var bani_10: Int
    var bani_5: Int
    var bani_1: Int
 //   var money: [MoneyModel]
    
    init?(lei_500: Int, lei_200: Int, lei_100: Int,
          lei_50: Int, lei_10: Int, lei_5: Int, lei_1: Int,
          bani_50: Int, bani_10: Int, bani_5: Int, bani_1: Int) {
        self.lei_500 = lei_500
        self.lei_200 = lei_200
        self.lei_100 = lei_100
        self.lei_50 = lei_50
        self.lei_10 = lei_10
        self.lei_5 = lei_5
        self.lei_1 = lei_1
        self.bani_50 = bani_50
        self.bani_10 = bani_10
        self.bani_5 = bani_5
        self.bani_1 = bani_1
    }
    
    
}
