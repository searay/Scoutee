//
//  Category.swift
//  WatchAround
//
//  Created by srikanth cuddapah on 4/29/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit


class Category : NSObject {
    
    var name : String
    var icon : String
    var searchKey : String
    var backColor : UIColor = UIColor(red: CGFloat(0.19607844948768616), green: CGFloat(0.61960786581039429), blue: CGFloat(0.90588241815567017), alpha: 1)
    
    init(name: String, icon : String, searchKey : String) {
        self.name = name
        self.icon = icon
        self.searchKey = searchKey
    }
    
}