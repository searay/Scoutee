//
//  CategoryRowController.swift
//  WatchAround
//
//  Created by srikanth cuddapah on 4/18/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import WatchKit

class CategoryTableRowController : NSObject {
    
    @IBOutlet weak var categoryGroup: WKInterfaceGroup!
    @IBOutlet weak var categoryImage: WKInterfaceImage!
    @IBOutlet weak var categoryLabel: WKInterfaceLabel!
    
    
    override init() {
        super.init()
        
        categoryLabel = WKInterfaceLabel()
        categoryImage = WKInterfaceImage()
        categoryGroup = WKInterfaceGroup()
    }
}