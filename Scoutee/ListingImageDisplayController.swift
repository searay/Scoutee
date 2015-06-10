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
    var imageArray : [NSString] = []
    var imageIndex = 0
    
    @IBOutlet weak var listingImageViewControl: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.listingImageViewControl.frame = CGRect(x: 0, y: self.listingImageViewControl.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var recognizerLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swiped:"))
        recognizerLeft.direction = .Left
        
        var recognizerRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swiped:"))
        
        
        self.view.addGestureRecognizer(recognizerLeft)
        self.view.addGestureRecognizer(recognizerRight)
        
        loadImage()
    }
    
    func loadImage() {
        let imageUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=640&maxheight=1000&photoreference=\(self.imageArray[self.imageIndex])&key=\(PlaceFinder.apiKey)"
        
        let url = NSURL(string: imageUrl)
        var err: NSError?
        
        if let imageData : NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err) as      NSData? {
            
            if err == nil {
                var img = UIImage(data:imageData)
                self.listingImageViewControl.image = img
            }
        }

    }
    
    func swiped(sender : UISwipeGestureRecognizer) {
        
        if sender.direction == .Left {
            println("left swipe")
            
            if self.imageIndex < (self.imageArray.count-1) {
                self.imageIndex++
                self.loadImage()
            }
            
        } else {
            println("right swipe")
            
            if self.imageIndex > 0 {
                self.imageIndex--
                self.loadImage()
            }
        }

    }
    
    
}