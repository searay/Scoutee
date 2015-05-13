//
//  ResultsListInterfaceController.swift
//  WatchAround
//
//  Created by srikanth cuddapah on 4/18/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit


class ResultsListInterfaceController : WKInterfaceController {
    
    @IBOutlet weak var distanceLabel: WKInterfaceLabel!
    @IBOutlet weak var resultsTable : WKInterfaceTable!
    
    var listings : [Listing]!
    var location : CLLocationCoordinate2D!
    
    override init() {
        super.init()
     }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let contextDictionary = context as? NSDictionary
        {
            if let category = contextDictionary["data"] as? String,
                let locationInformation = contextDictionary["location"] as? String,
                    let filter = contextDictionary["filter"] as? String,
                        let backColor = contextDictionary["color"] as? String
            {
                if let queryString = filter as String!, let locationInf = locationInformation as String!,color = backColor as String!
                {
                    self.setTitle(category)
                    self.location = MiscUtil.parseLocationString(locationInf)
            
                    let dist = 30000
                    let encodedQueryString = queryString.stringByReplacingOccurrencesOfString("|", withString: "%7C",
                                    options: NSStringCompareOptions.LiteralSearch, range: nil)
                    let query : LocationQuery = LocationQuery(what:encodedQueryString,location:locationInf,distance:dist)
                    var finder : PlaceFinder = PlaceFinder()
            
                    listings = finder.findListing(query,SortByDistance : true) as [Listing]
            
                    if(listings.count > 0)
                    {
                        resultsTable.setNumberOfRows(listings.count, withRowType: "ResultTableRowController")
                
                        for (rowIndex,listing) in enumerate(listings)
                        {
                            let row  = resultsTable.rowControllerAtIndex(rowIndex) as! ResultTableRowController
                    
                            row.listingNameLabel.setText(listing.name)
                            row.listingDistanceLabel.setText(MiscUtil.getDistanceFormatted(listing.distance))
                            row.listingOpenCloseLabel.setText(listing.open ? " Open" : " Closed")
                            row.listingGroup.setBackgroundColor(MiscUtil.hexStringToUIColor(color))
                    
                            if listing.rating > 0 {
                                row.listingRatingLabel.setText(String(format:"%.1f stars",listing.rating))
                            }
                        }
                    }
                }
            }
        } else {
            pushControllerWithName("ErrorInfoController", context: ["errior": "unable to retrieve location information"])
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
            return [
            "place" :  listings[rowIndex]
        ]
    }
}
