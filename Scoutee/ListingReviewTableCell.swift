//
//  ListingReviewTableCell.swift
//  WatchAround
//
//  Created by Cuddapah, Srikanth on 5/14/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import UIKit

class ListingReviewTableCell : UITableViewCell  {
    
    @IBOutlet weak var reviewTextView: UILabel!
    @IBOutlet weak var reviewDateTimeLabel: UILabel!
    @IBOutlet weak var reviewRatingLabel: UILabel!
    @IBOutlet weak var reviewAuthorLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        /*let xPos = self.contentView.frame.width -  (15+self.reviewRatingLabel.frame.width)
        
        self.reviewRatingLabel.frame = CGRect(x: xPos, y: self.reviewRatingLabel.frame.origin.y, width: self.reviewRatingLabel.frame.size.width, height: self.reviewRatingLabel.frame.size.height)
        
        self.reviewDateTimeLabel.frame = CGRect(x: xPos, y: self.reviewDateTimeLabel.frame.origin.y, width: self.reviewDateTimeLabel.frame.size.width, height: self.reviewDateTimeLabel.frame.size.height)
        
        self.reviewTextView.frame = CGRect(x: 5, y: self.reviewTextView.frame.origin.y, width: self.reviewTextView.frame.size.width, height: self.reviewTextView.frame.size.height)*/
        
    }
}