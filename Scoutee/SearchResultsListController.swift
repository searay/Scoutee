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
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    func sortListings(listings : [Listing],byDistance : Bool) -> [Listing] {
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
        setUp()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.resultsListView.reloadData()
    }
    
    func setUp() {
        //self.initializeLocationService()
        var nib = UINib(nibName: "ListingTableCell", bundle: nil)
        self.resultsListView.registerNib(nib, forCellReuseIdentifier: "listingCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        self.resultsListView.frame = CGRect(x:self.resultsListView.frame.origin.x,y:self.resultsListView.frame.origin.y,
            width:self.view.frame.size.width,height:self.view.frame.height)
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
        return 115.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : ListingTableCell = self.resultsListView.dequeueReusableCellWithIdentifier("listingCell") as! ListingTableCell
        let listing : Listing = self.listings[indexPath.row]
        
        cell.listingNameLabel.text = listing.name
        cell.listingAddressLabel.text = listing.vicinity
        cell.listingDistanceLabel.text =  MiscUtil.getDistanceFormatted(listing.distance)
        cell.listingRatingLabel.text = MiscUtil.getRatingStars(listing.rating)
        cell.listingOpenStatusImage.hidden = false
        cell.listingAvailabilityLabel.hidden = (listing.open == "Unknown") ? true : false
        
        
        var isOpen = (listing.open == "Open") ? true : false
            
        cell.listingAvailabilityLabel.text = isOpen ? "Open" : "Closed"
        cell.listingAvailabilityLabel.hidden = isOpen ? true : false;
        cell.listingOpenStatusImage.hidden = isOpen  ? false : true;
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        
        if listing.open == "Unknown" {
            cell.listingAvailabilityLabel.hidden = true
            cell.listingOpenStatusImage.hidden = true
        }
        
        return cell
    }
}