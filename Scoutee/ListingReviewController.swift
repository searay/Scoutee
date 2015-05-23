//
//  ListingReviewController.swift
//  Scoutee
//
//  Created by srikanth cuddapah on 5/15/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import UIKit

class ListingReviewController : UIViewController {
    
    @IBOutlet weak var reviewRatingText: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    var review : CustomerReview = CustomerReview()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.review.name
        self.reviewTextView.text = self.review.reviewText
        self.reviewRatingText.text = MiscUtil.getRatingStars(self.review.rating)
    }

}