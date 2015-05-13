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
}