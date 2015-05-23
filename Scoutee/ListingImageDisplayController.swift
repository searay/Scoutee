//
//  ListingImageDisplayController.swift
//  Scoutee
//
//  Created by srikanth cuddapah on 5/15/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import UIKit

class ListingImageDisplayController : UIViewController {
    var listingImage : UIImage = UIImage()
    
    @IBOutlet weak var listingImageViewControl: UIImageView!
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
        
        self.listingImageViewControl.image = self.listingImage
    }
    
    
}