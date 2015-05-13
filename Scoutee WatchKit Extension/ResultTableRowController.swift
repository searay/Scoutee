//
//  ResultTableRowController.swift
//  WatchAround
//
//  Created by srikanth cuddapah on 4/19/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit

class ResultTableRowController : NSObject {
    
    @IBOutlet weak var listingRatingImageGroup: WKInterfaceGroup!
    @IBOutlet weak var listingNameLabel: WKInterfaceLabel!
    @IBOutlet weak var listingDistanceLabel: WKInterfaceLabel!
    @IBOutlet weak var listingRatingLabel: WKInterfaceLabel!
    @IBOutlet weak var listingOpenCloseLabel: WKInterfaceLabel!
    @IBOutlet weak var listingVicinity: WKInterfaceLabel!
    @IBOutlet weak var listingGroup: WKInterfaceGroup!
    
    
    @IBOutlet weak var rating1: WKInterfaceImage!
    @IBOutlet weak var rating2: WKInterfaceImage!
    @IBOutlet weak var rating3: WKInterfaceImage!
    @IBOutlet weak var rating4: WKInterfaceImage!
    @IBOutlet weak var rating5: WKInterfaceImage!
    
    override init() {
        super.init()
        
        listingNameLabel = WKInterfaceLabel()
        listingRatingLabel = WKInterfaceLabel()
        listingDistanceLabel = WKInterfaceLabel()
        
    }
}