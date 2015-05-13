//
//  ListingDetailController.swift
//  WatchAround
//
//  Created by srikanth cuddapah on 4/21/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit

class ListingDetailController: WKInterfaceController {
    
    var currentListing : Listing = Listing()
    var currentLocation : CLLocationCoordinate2D?
    
    @IBOutlet weak var CategoryTitle: WKInterfaceLabel!
    @IBOutlet weak var CategoryLocationMap: WKInterfaceMap!
    @IBOutlet weak var CategoryVacinity: WKInterfaceLabel!
    
    @IBAction func ActionBookmark() {
        
        if let listingId = self.currentListing.id as String! {
            var phoneNumber = PlaceFinder().getListingContactNumber(listingId)
          
            let commands : Dictionary = [
                "callNumber" :phoneNumber]
        
            WKInterfaceController.openParentApplication(commands,reply : {
                (replyInfo,error) -> Void in
            
                NSLog("replied for bookmark action")
            })
        }
    }
    
    @IBAction func ActionDrive()
    {
        WKInterfaceController.openParentApplication(["coordinates" : currentListing.location],reply : {
            (replyInfo,error) -> Void in
            
                NSLog("replied for drive action")
            
            })
    }
    
    override init() {
        super.init();
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.setUp(context)
    }
    
    func setUp(context:AnyObject?) {
        
        if let contextDict = context as? Dictionary<String,Listing> ,listing = contextDict["place"] as Listing! {
            currentListing = listing
            let coordinates = listing.location.componentsSeparatedByString(",") as [String]
            let listingLatitude = (coordinates[0] as NSString).doubleValue
            let listingLongitude = (coordinates[1] as NSString).doubleValue
        
            let location = CLLocationCoordinate2D(latitude: listingLatitude, longitude: listingLongitude)
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
        
            CategoryLocationMap.addAnnotation(location, withPinColor: .Red)
            CategoryLocationMap.setRegion(region)
            CategoryTitle.setText(listing.name)
            CategoryVacinity.setText(listing.vicinity)
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
}