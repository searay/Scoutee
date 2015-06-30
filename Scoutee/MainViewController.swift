//
//  ViewController.swift
//  WatchAround
//
//  Created by srikanth cuddapah on 4/18/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate {

    @IBOutlet weak var mainCategoriesCollView: UICollectionView!
    @IBOutlet weak var subCategoryTableView: UITableView!
    
    var categorySubCollection : [NSArray] = []
    var categoryHeaderNames : [String] = []
    var categoryIcons : [String] = []
    var currentIndex : Int = 0
    var locationManager : CLLocationManager = CLLocationManager()
    var searchResults : [Listing] = []
    var progressAlert : UIAlertView = UIAlertView()
    var queryByRank : String = ""
    var allResults : NSMutableDictionary = NSMutableDictionary()
    
    
    let TABLE_CELL_NIB_NAME = "CategoryToggleCell"
    let TABLE_CELL_REUSE_ID  = "listingCell"
    
    let COLLECTION_VIEW_CELL_NAME = "CategoryCollectionCell"
    let COLLECTION_VIEW_REUSE_ID = "categoryCollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
       locationManager.stopUpdatingLocation()
    }
    
    func setUp() {
        
        var screenSize : CGRect = UIScreen.mainScreen().bounds
        self.readDataFromCatalag()
        
        var nib = UINib(nibName: self.TABLE_CELL_NIB_NAME, bundle: nil)
        self.subCategoryTableView.registerNib(nib, forCellReuseIdentifier: TABLE_CELL_REUSE_ID)
        
        var collectionCellNib = UINib(nibName: COLLECTION_VIEW_CELL_NAME, bundle: nil)
        self.mainCategoriesCollView.registerNib(collectionCellNib, forCellWithReuseIdentifier: COLLECTION_VIEW_REUSE_ID)

        var flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        self.mainCategoriesCollView.contentSize = CGSize(width: self.view.frame.size.width-100, height: 74)
        self.mainCategoriesCollView.setCollectionViewLayout(flowLayout, animated: true)
        
        self.locationManagerTest()
    }
    
    func locationManagerTest() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath
        indexPath: NSIndexPath) {
            
            var cell : CategoryCollectionCell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionCell
            
            if (cell.selected) {
                
                for col in self.mainCategoriesCollView.visibleCells() {
                    (col as! CategoryCollectionCell).selectIndicatorImage.hidden=true
                }
                
                cell.selectIndicatorImage.hidden = false
                currentIndex = indexPath.row
                self.subCategoryTableView.reloadData()
            }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.mainCategoriesCollView.frame = CGRect(x:self.mainCategoriesCollView.frame.origin.x,y:0,width:self.view.frame.width,height:self.mainCategoriesCollView.bounds.height)
        self.subCategoryTableView.frame = CGRect(x:0,y:self.subCategoryTableView.frame.origin.y,width:self.view.frame.width,height: self.subCategoryTableView.bounds.height)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 90)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : CategoryCollectionCell = mainCategoriesCollView.dequeueReusableCellWithReuseIdentifier(COLLECTION_VIEW_REUSE_ID, forIndexPath: indexPath) as! CategoryCollectionCell
        
        cell.categoryNameLabel.text = categoryHeaderNames[indexPath.row]
        cell.categoryNameIcon.image = UIImage(named: categoryIcons[indexPath.row])
        cell.selectIndicatorImage.hidden = self.currentIndex == indexPath.row ? false : true
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell : CategoryCollectionCell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionCell {
        
            cell.selectIndicatorImage.hidden = true
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryHeaderNames.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if self.locationManager.location != nil {
            if segue.identifier == "ShowResults" {
                let destinationController : SearchResultsListController = segue.destinationViewController as! SearchResultsListController
                destinationController.searchKey = getSearchKeyFromSelectedRow()
                destinationController.listings = self.searchResults
            }
        }
    }
    
    func getSearchKeyFromSelectedRow() -> NSString {
        let indexPath = self.subCategoryTableView.indexPathForSelectedRow()
        
        if let section = indexPath?.section, row = indexPath?.row {
            let dict = self.categorySubCollection[currentIndex][row] as! NSDictionary
            return dict.valueForKey("search_key") as! NSString
        }
        else {
            return "restaurant"
        }
    }
    
    func getRowTitle() -> String {
        let indexPath = self.subCategoryTableView.indexPathForSelectedRow()
        
        if let section = indexPath?.section, row = indexPath?.row {
            var cell : CategoryToggleCell = self.subCategoryTableView.cellForRowAtIndexPath(indexPath!) as! CategoryToggleCell
            
            return cell.categoryTitle.text!
            
        }
        else {
            return "restaurant"
        }
    }
    
    func searchResultsHandler(searchError : String, location : String, results : NSMutableDictionary) {
        if (searchError != "") {
            
            NSLog("error -> \(searchError)");
            
            var msgBox : UIAlertView = UIAlertView()
            msgBox.title = "Error"
            msgBox.message = "Unable to perform search \(searchError)."
            msgBox.delegate = self
            msgBox.addButtonWithTitle("OK")
            msgBox.show()
        }
        else {
            
            self.allResults = results
            self.getResults(self.queryByRank, location: location, finishHandler: searchResultsHandlerByRank)
        }
    }
    
    func searchResultsHandlerByRank(searchError : String, location : String, results : NSMutableDictionary) {
        if (searchError != "") {
            
            NSLog("error -> \(searchError)");
            
            var msgBox : UIAlertView = UIAlertView()
            msgBox.title = "Error"
            msgBox.message = "Unable to perform search \(searchError)."
            msgBox.delegate = self
            msgBox.addButtonWithTitle("OK")
            msgBox.show()
        }
        else {
            
            var placeIdsRanked : [String] = results.allKeys as! [String]
            var allPlaceIds : [String]  = self.allResults.allKeys as! [String]
            
            for (index,placeid) in enumerate(placeIdsRanked) {
                if contains(allPlaceIds, placeid) == false {
                    allResults.setObject(results[placeid] as! Listing, forKey: placeid)
                }
            }
            
            var items : [Listing] =  allResults.allValues as! [Listing]
            self.searchResults = PlaceFinder().sortListings(items, byDistance: true)
            self.navigateToResultsController()
        }
    }

    
    func navigateToResultsController() {
        self.progressAlert.dismissWithClickedButtonIndex(0, animated: true)
        
        if (self.searchResults.count > 0) {
            dispatch_async(dispatch_get_main_queue())
                {
                    self.performSegueWithIdentifier("ShowResults", sender:self)
            }
            
            NSLog("result count -> \(self.searchResults.count)")
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var rect = CGRect(x: self.subCategoryTableView.center.x, y: self.subCategoryTableView.center.y, width: 150, height: 150)
        
        if self.locationManager.location != nil {
            let dist = 30000
            let encodedQueryString = getSearchKeyFromSelectedRow().stringByReplacingOccurrencesOfString("|", withString: "%7C")
            let locationString = String(format: "%f,%f",locationManager.location.coordinate.latitude,
                locationManager.location.coordinate.longitude)
            
            let query : LocationQuery = LocationQuery(what:encodedQueryString,location:locationString,distance:dist)
            let finder : PlaceFinder = PlaceFinder()
            
            self.progressAlert = UIAlertView(title: "Searching for \(self.getRowTitle().lowercaseString)", message: "", delegate: self, cancelButtonTitle: nil)
            self.progressAlert.show()
            
            let queryString = buildQueryString(query, SortByDistance: false, Rank: false)
            self.queryByRank = buildQueryString(query, SortByDistance: false, Rank: true)
            
            self.getResults( queryString, location : query.location, finishHandler : searchResultsHandler)
        } else {
            
            var msgBox : UIAlertView = UIAlertView()
            msgBox.title = "Error"
            msgBox.message = "Unable to get current location. Please check if location services is enabled on this device."
            msgBox.delegate = self
            msgBox.addButtonWithTitle("OK")
            msgBox.show()
        }
        
    }
    
    func buildQueryString(Query : LocationQuery, SortByDistance : Bool,Rank : Bool) -> String {
        
        var queryString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(Query.location!)&radius=\(Query.distance)&types=\(Query.what!)&key=\(PlaceFinder.apiKey)"
        
        if Rank == true {
            queryString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(Query.location!)&rankby=distance&types=\(Query.what!)&key=\(PlaceFinder.apiKey)"
        }
        
        return queryString
    }
    

    
    func getResults(queryString : String, location : String, finishHandler : (searchError : String, location : String , results : NSMutableDictionary) -> Void )
    {
        var listings : NSMutableDictionary = NSMutableDictionary()
        var errorMessage : NSString = ""
        
        
        if let url = NSURL(string: queryString) {
        
            let urlRequest : NSURLRequest = NSURLRequest(URL: url)
            var error : NSErrorPointer = nil
            var urlSession : NSURLSession = NSURLSession.sharedSession()
            var task = urlSession.dataTaskWithRequest(urlRequest)
            {
                (data, response, error) -> Void in
                
                if (error != nil) {
                    finishHandler(searchError: error.description, location : location, results: NSMutableDictionary())
                }
                else {
                    var jsonError : NSErrorPointer = nil
                    var nextPageId = ""
                    
                    if data != nil {
                        let jsonData : NSDictionary =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: jsonError) as! NSDictionary
                        
                        let status = jsonData.valueForKey("status") as! String
                        let results = jsonData.valueForKey("results") as! Array<NSDictionary>
                        
                        if let nextPage = jsonData.valueForKey("next_page_token") as? String {
                            nextPageId = nextPage
                        }
                        
                        if status != "OK" {
                            if let errMessage = jsonData.valueForKey("error_message") as! String? {
                                finishHandler(searchError: errMessage, location: location, results: NSMutableDictionary())
                            }
                        }
                        else {
                            if results.capacity > 0 {
                                for result in results {
                                    if result.allKeys.count > 0 {
                                        let listingItem = PlaceFinder().getListingFromDict(result,queryLocation:location)
                                        listings.setValue(listingItem, forKey: listingItem.id!)
                                    }
                                }

                            }
                        }
                        
                        // get next page results
                        
                        if nextPageId != "" {
                            
                                var queryStringNextPage = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=\(nextPageId)&key=\(PlaceFinder.apiKey)"
                                
                                if let nextPageUrl = NSURL(string: queryStringNextPage)
                                {
                                    let urlRequestnp : NSMutableURLRequest = NSMutableURLRequest(URL: nextPageUrl)
                                    var urlResponsenp : NSURLResponse?
                                    var errornp : NSErrorPointer = nil
                                    
                                    let datanp = NSURLConnection.sendSynchronousRequest(urlRequestnp, returningResponse: &urlResponsenp, error: errornp)
                                    
                                    if datanp != nil {
                                        let jsonDatanp : NSDictionary =  NSJSONSerialization.JSONObjectWithData(datanp!, options: NSJSONReadingOptions.AllowFragments, error: errornp) as! NSDictionary
                                        
                                        let statusnp = jsonDatanp.valueForKey("status") as! String
                                        let resultsnp = jsonDatanp.valueForKey("results") as! Array<NSDictionary>
                                        
                                        if statusnp == "OK"
                                        {
                                            if resultsnp.capacity > 0
                                            {
                                                for resultnp in resultsnp
                                                {
                                                    if resultnp.allKeys.count > 0
                                                    {
                                                        var listing : Listing = PlaceFinder().getListingFromDict(resultnp, queryLocation: location)
                                                        
                                                        listings.setValue(listing, forKey: listing.id!)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                    }
                  finishHandler(searchError: "", location : location, results: listings)
                }
            }
            
            if task.state != NSURLSessionTaskState.Running {
                task.resume()
            } else {
                task.cancel()
            }
        }
    }
    
    // end code from place finder
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorySubCollection[currentIndex].count
    }
    
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
         self.subCategoryTableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : CategoryToggleCell = self.subCategoryTableView.dequeueReusableCellWithIdentifier("listingCell") as! CategoryToggleCell
        var dict = self.categorySubCollection[currentIndex][indexPath.row] as! NSDictionary
        
        if let name = dict.valueForKey("name") as? String {
            cell.categoryTitle.text = name
        }
        
        if let image = dict.valueForKey("icon") as? String {
            cell.categoryImage.image = UIImage(named: image)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    
    func readDataFromCatalag() {
        let path = NSBundle.mainBundle().pathForResource("CatData", ofType: "json") as String!
        
        if path != nil {
            var jsonData : NSData = NSData(contentsOfFile: path) as NSData!
            var error : NSErrorPointer = nil
            var catCollection : NSArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments, error: error)
                as! NSArray
            
            if error != nil {
                
            }
            else {
                for(index,categoryItem) in enumerate(catCollection) {
                    
                    if let category = categoryItem as? NSDictionary {
                        
                        var subCategories : NSArray = category["subCategories"] as! NSArray!
                        var title = category["name"] as! String
                        var icon = category["icon"] as! String
                        var bigIcon = category["big-icon"] as! String
                        
                        self.categoryIcons.append(bigIcon)
                        self.categoryHeaderNames.append(title)
                        self.categorySubCollection.append(subCategories)
                    }
                }
            }
        }
    }
}

