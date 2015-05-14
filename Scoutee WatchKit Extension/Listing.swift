//
//  Listing.swift
//  WatchAround
//
//  Created by srikanth cuddapah on 4/19/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation

class Listing 
{
    var id : String?
    var name : String?
    var vicinity : String = ""
    var distance : Double = 0.0
    var phoneNumber : String = ""
    var iconUrl : String = "http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png"
    
    var location : String = "0,0"
    var rating : Double = 0.0
    var open : String = "Unknown"
    var pics : [NSString] = []
}
