//
//  LocationQuery.swift
//  WatchAround
//
//  Created by srikanth cuddapah on 4/19/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation

class LocationQuery {
    var what : String!
    var location : String!
    var distance : Int = 5000
    
    init(what : String,location : String,distance : Int) {
        self.what = what
        self.location = location
        self.distance = distance
    }
    
    
}

