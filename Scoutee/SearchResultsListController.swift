//
//  SearchResultsListController.swift
//  WatchAround
//
//  Created by Cuddapah, Srikanth on 5/5/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import UIKit
import CoreLocation

class SearchResultsListController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var switchContainer: UIView!
    @IBOutlet weak var sortBySwitch: UISegmentedControl!
    @IBOutlet weak var resultsListView: UITableView!
    
    var listings : [Listing] = []
    var searchKey : NSString = ""
    var searchCategory = ""
    var locationManager : CLLocationManager = CLLocationManager()
    var currentListingIndex = 0
    
    @IBAction func sortValueChanged(sender: AnyObject) {
        var sortByDistance : Bool = sortBySwitch.selectedSegmentIndex == 0 ? true : false
        
        self.listings = self.sortListings(self.listings, byDistance: sortByDistance)
        self.resultsListView.reloadData()
    }
    
    func sortListings(listings : [Listing],byDistance : Bool) -> [Listing]{
        
        if listings.count > 1 {
            return listings.sorted {
                if byDistance == true {
                    return $0.distance < $1.distance
                } else {
                    return $0.rating > $1.rating
                }
            }
        } else {
            return listings
        }
    }

    
    func initializeLocationService() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("error getting location")
        locationManager.stopUpdatingLocation()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeLocationService()
        populateResultsList()
        
        var nib = UINib(nibName: "ListingTableCell", bundle: nil)
        self.resultsListView.registerNib(nib, forCellReuseIdentifier: "listingCell")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
         self.switchContainer.frame = CGRect(x:self.switchContainer.frame.origin.x,y:0,width:self.view.frame.width,height:self.switchContainer.bounds.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController : ListingDetailViewController = segue.destinationViewController as! ListingDetailViewController
        
        destinationController.listing = listings[self.currentListingIndex]
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentListingIndex = indexPath.row
        self.performSegueWithIdentifier("ShowListingDetails", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : ListingTableCell = self.resultsListView.dequeueReusableCellWithIdentifier("listingCell") as! ListingTableCell
        let listing : Listing = self.listings[indexPath.row]
        
        cell.listingNameLabel.text = listing.name
        cell.listingAddressLabel.text = listing.vicinity
        cell.listingDistanceLabel.text =  getDistanceFormatted(listing.distance)
        cell.listingRatingLabel.text = getRatingStars(listing.rating)
        cell.listingOpenStatusImage.hidden = false
        cell.listingAvailabilityLabel.hidden = (listing.open == "Unknown") ? true : false
        
        
        var isOpen = (listing.open == "Open") ? true : false
            
        cell.listingAvailabilityLabel.text = isOpen ? "Open" : "Closed"
        
        if isOpen == false {
            //cell.listingAvailabilityLabel.backgroundColor = UIColor.orangeColor()
        }
        
        cell.listingAvailabilityLabel.hidden = isOpen ? true : false;
        cell.listingOpenStatusImage.hidden = isOpen  ? false : true;
        //cell.listingAvailabilityLabel.textColor = isOpen ? UIColor.blackColor() : UIColor.whiteColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if listing.open == "Unknown" {
            cell.listingAvailabilityLabel.hidden = true
            cell.listingOpenStatusImage.hidden = true
        }
        
            
        
        //UIColor(red: 0.23529413342475891, green: 0.91764712333679199, blue: 0.86666673421859741, alpha: 1)
        return cell
    }
    
    func getDistanceFormatted(distance: Double) -> String {
        var dist = String(format: "%.2f meters",distance)
        
        if distance > 1609.0 {
            dist = String(format: "%.2f miles",distance/1609)
        } else {
            dist = String(format: "%.2f km",distance/1000)
        }
        
        return dist;
    }

    func getRatingStars(rating : Double) -> String {
        var ratingLabelText = ""
        var i : Double
        
        for i = 0; i < round(rating); i++ {
            ratingLabelText += "*"
        }
        
        return ratingLabelText
    }
    
    func populateResultsList() {
        var dist = 30000
        
        if(locationManager.location == nil) {
            
        }
        else {
            let encodedQueryString = self.searchKey.stringByReplacingOccurrencesOfString("|", withString: "%7C")
            let locationString = String(format: "%f,%f",locationManager.location.coordinate.latitude,
            locationManager.location.coordinate.longitude)

            let query : LocationQuery = LocationQuery(what:encodedQueryString,location:locationString,distance:dist)
            let finder : PlaceFinder = PlaceFinder()
        
            self.listings = finder.findListing(query,SortByDistance : sortBySwitch.selectedSegmentIndex==0 ? true : false) as [Listing]
       }
    }
}