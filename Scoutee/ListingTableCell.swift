//
//  ListingTableCell.swift
//  WatchAround
//
//  Created by Cuddapah, Srikanth on 5/5/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit

class ListingTableCell : UITableViewCell  {

    @IBOutlet weak var listingNameLabel: UILabel!
    @IBOutlet weak var listingRatingLabel: UILabel!
    @IBOutlet weak var listingDistanceLabel: UILabel!
    @IBOutlet weak var listingAddressLabel: UILabel!
    @IBOutlet weak var listingAvailabilityLabel: UILabel!
    @IBOutlet weak var listingOpenStatusImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let xPos = self.contentView.frame.width -  (5+self.listingAvailabilityLabel.frame.width)
        
        self.listingAvailabilityLabel.frame = CGRect(x: xPos, y: self.listingAvailabilityLabel.frame.origin.y, width: self.listingAvailabilityLabel.frame.size.width, height: self.listingAvailabilityLabel.frame.size.height)
        
        self.listingDistanceLabel.frame = CGRect(x: xPos, y: self.listingDistanceLabel.frame.origin.y, width: self.listingDistanceLabel.frame.size.width, height: self.listingDistanceLabel.frame.size.height)
        
        self.listingOpenStatusImage.frame = CGRect(x: xPos+6, y: self.listingOpenStatusImage.frame.origin.y, width: self.listingOpenStatusImage.frame.size.width, height: self.listingOpenStatusImage.frame.size.height)

    }
}