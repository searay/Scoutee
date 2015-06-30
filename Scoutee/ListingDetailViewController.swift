//
//  ListingDetailViewController.swift
//  WatchAround
///
//  Created by Cuddapah, /Users/sxc019/Downloads/ionicons-2.0.1/png/512/ios7-telephone.pngSrikanth on 5/5/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//
import UIKit
import CoreLocation
import MapKit


class ListingDetailViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listingPhoto: UIImageView!
    
    var listing : Listing = Listing()
    var listingDetail : ListingDetail = ListingDetail()
    var selectedImageIndex = 0
    var progressAlert = UIAlertView()
    
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var listingLocationMap: MKMapView!
    @IBOutlet weak var actionToolbar: UIToolbar!
    
    @IBOutlet weak var webBrowseActionButton: UIBarButtonItem!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBAction func callListing(sender: AnyObject) {
        if let phoneNumber = listing.phoneNumber as String?, loc = listing.location as NSString? {
            if let listingId = listing.id as String! {
                var phoneNumber = PlaceFinder().getListingContactNumber(listingId)
                self.makeTelephoneCall(phoneNumber)
            }
        }
    }
    
    @IBAction func walkHere(sender: AnyObject) {
        if let loc = listing.location as NSString? {
            var location = parseLocationString(loc as NSString!) as CLLocationCoordinate2D!
            self.goHere(location,launchOption: MKLaunchOptionsDirectionsModeWalking)
        }
    }
    
    @IBAction func driveHere(sender: AnyObject) {
        if let loc = listing.location as NSString? {
            var location = parseLocationString(loc as NSString!) as CLLocationCoordinate2D!
            self.goHere(location,launchOption: MKLaunchOptionsDirectionsModeDriving)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func getListingDetailById(id : String) {
        var listingInfo = ListingDetail()
        let queryString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(id)&key=\(PlaceFinder.apiKey)"
        
        if let url = NSURL(string: queryString)
        {
            var urlRequest : NSMutableURLRequest = NSMutableURLRequest(URL: url)
            var urlResponse : NSURLResponse?
            var error : NSErrorPointer = nil
            var session : NSURLSession = NSURLSession.sharedSession()
            
            var task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                
                if (error != nil) {
                    
                }
                else {
                    var jsonError : NSErrorPointer = nil
                    var nextPageId = ""
                    
                    if data != nil {
                        
                        // start

                        var jsonData : NSDictionary =  NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: jsonError) as! NSDictionary
                        
                        var status = jsonData.valueForKey("status") as! String
                        var result = jsonData.valueForKey("result") as! NSDictionary
                        
                        if status == "OK"
                        {
                            if result.allKeys.count > 0
                            {
                                if let phone = result.valueForKey("formatted_phone_number") as? String {
                                    listingInfo.phoneNumber = PlaceFinder().formatPhoneNumber(phone)
                                }
                                
                                if let openHours = result.valueForKey("opening_hours") as? NSDictionary {
                                    if let hours = openHours.valueForKey("weekday_text") as! NSArray? {
                                        for hour in hours {
                                            listingInfo.hours.append("\(hour)")
                                        }
                                        
                                    }
                                }
                                
                                if let photos = result.valueForKey("photos") as? NSArray {
                                    for photo in photos {
                                        var ref = (photo as! NSDictionary).valueForKey("photo_reference") as! String
                                        listingInfo.photos.append(ref)
                                    }
                                }
                                
                                if listingInfo.photos.count < 1 {
                                    listingInfo.photos.append("no-images")
                                }
                                
                                if let site = result.valueForKey("website") as? NSString {
                                    listingInfo.webSite = site
                                }
                                
                                if let reviews = result.valueForKey("reviews") as? NSArray {
                                    for review in reviews {
                                        let reviewObj = review as! NSDictionary
                                        
                                        var reviewItem = CustomerReview()
                                        
                                        if let reviewer = reviewObj.valueForKey("author_name") as? String {
                                            reviewItem.name = reviewer
                                        }
                                        
                                        if let reviewText = reviewObj.valueForKey("text") as? String{
                                            reviewItem.reviewText = reviewText
                                        }
                                        
                                        if let rating = reviewObj.valueForKey("rating") as? Double {
                                            reviewItem.rating = rating
                                        }
                                        
                                        listingInfo.reviews.append(reviewItem)
                                    }
                                }
                                
                                self.listingDetail = listingInfo
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if self.listingDetail.webSite.length < 1 {
                                self.webBrowseActionButton.enabled = false
                            }

                            self.photoCollectionView.reloadData()
                            self.reviewTable.reloadData()
                            self.reviewTable.hidden = listingInfo.reviews.count < 1
                            
                             self.progressAlert.dismissWithClickedButtonIndex(0, animated: true)
                        })
                        
                        // end
                    }
                }
            }
            
            task.resume()
        }
    }

    
    func setUp() {
        if let loc = listing.location as NSString? {
            
            self.progressAlert = UIAlertView(title: "Getting Detail Information", message: "", delegate: self, cancelButtonTitle: nil)
            self.progressAlert.show()
           
            var location = parseLocationString(loc as NSString!) as CLLocationCoordinate2D!
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
            var annotation = LocationPinAnnotation(title:listing.name!,locationName:listing.name!,discipline:listing.vicinity,coordinate:location)
            var pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinAnnotation")
            pinAnnotation.backgroundColor = UIColor.yellowColor()
            
            listingLocationMap.addAnnotation(annotation)
            listingLocationMap.setRegion(region, animated: true)
            
            var nib = UINib(nibName: "ListingPhotoCell", bundle: nil)
            
            self.photoCollectionView.registerNib(nib, forCellWithReuseIdentifier: "ListingPhotoCell")
            
            let doubleTapGuesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handlePhotoSelection:"))
            
            var nibOfReviewTable = UINib(nibName: "ListingReviewTableCell", bundle: nil)
            self.reviewTable.registerNib(nibOfReviewTable, forCellReuseIdentifier: "reviewcell")
            
            
            var flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
            
            
            self.photoCollectionView.contentSize = CGSize(width: self.view.frame.size.width+200, height: 54)
            self.photoCollectionView.setCollectionViewLayout(flowLayout, animated: true)
            self.listingLocationMap.zoomEnabled = false
            self.listingLocationMap.scrollEnabled = false
            self.listingLocationMap.userInteractionEnabled = false
            
            if let id = listing.id as String? {
                //self.listingDetail = PlaceFinder().getListingDetailById(id)
                getListingDetailById(id)
            }

            if self.listingDetail.webSite.length < 1 {
                self.webBrowseActionButton.enabled = false
            }
        }
    }
    
    func handlePhotoSelection(rec : UITapGestureRecognizer) {
        performSegueWithIdentifier("ShowImage", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier as String?
        {
            if segueIdentifier == "ShowWebSite" {
                let destinationController : ListingWebViewController = segue.destinationViewController as! ListingWebViewController
                destinationController.webSite = listingDetail.webSite as String
                destinationController.title = listing.name as String!
            }
            else if segueIdentifier == "ShowReview" {
                let destinationController : ListingReviewController = segue.destinationViewController as! ListingReviewController
                
                if let path = self.reviewTable.indexPathForSelectedRow() as NSIndexPath? {
                    let reviewCell : ListingReviewTableCell = self.reviewTable.cellForRowAtIndexPath(path) as! ListingReviewTableCell
                
                    
                    destinationController.review.name = reviewCell.reviewAuthorLabel.text as String!
                    destinationController.review.reviewText = reviewCell.reviewTextView.text as String!
                    destinationController.review.rating = Double(count(reviewCell.reviewRatingLabel.text!)) 
                }
            }
            else if segueIdentifier == "ShowImage" {
                let destinationController : ListingImageDisplayController = segue.destinationViewController as! ListingImageDisplayController
            
                destinationController.imageArray = self.listingDetail.photos
                destinationController.imageIndex = self.selectedImageIndex
                
            }
        }
    }
    
    @IBAction func showTimings(sender: AnyObject)
    {
    }
       
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingDetail.reviews.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : ListingReviewTableCell = self.reviewTable.dequeueReusableCellWithIdentifier("reviewcell", forIndexPath: indexPath) as! ListingReviewTableCell
        
        cell.reviewAuthorLabel.text = listingDetail.reviews[indexPath.row].name
        cell.reviewTextView.text = listingDetail.reviews[indexPath.row].reviewText
        cell.reviewRatingLabel.text = MiscUtil.getRatingStars(listingDetail.reviews[indexPath.row].rating)
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowReview", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell : ListingPhotoCell = self.photoCollectionView.cellForItemAtIndexPath(indexPath) as! ListingPhotoCell
        
        self.selectedImageIndex = indexPath.row
        
        performSegueWithIdentifier("ShowImage", sender: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        // align controls
        
        self.listingLocationMap.frame = CGRect(x:0,
            y:self.listingLocationMap.frame.origin.y,width:self.view.frame.width,height:self.listingLocationMap.bounds.height)
        
        let tablePos = self.listingLocationMap.bounds.height + self.listingLocationMap.frame.origin.y
        
        self.reviewTable.frame = CGRect(x:self.reviewTable.frame.origin.x,y:tablePos,
                width:self.view.frame.size.width,height:self.view.frame.height - tablePos)
        
        self.buttonContainer.frame = CGRect(x:self.buttonContainer.frame.origin.x,y:self.buttonContainer.frame.origin.y,width:self.view.frame.size.width+10,height:self.buttonContainer.frame.size.height)
        
        if listing.pics.count < 1 {
            self.photoCollectionView.hidden = true;
            self.listingLocationMap.frame = CGRect(x: self.listingLocationMap.frame.origin.x, y: 42, width: self.listingLocationMap.frame.size.width, height: self.listingLocationMap.frame.height + self.photoCollectionView.frame.size.height)
        } else {
            self.photoCollectionView.frame = CGRect(x:self.photoCollectionView.frame.origin.x,
                y:self.photoCollectionView.frame.origin.y,width:self.view.frame.width+10,height:self.photoCollectionView.bounds.height)
        }
        
        if listingDetail.reviews.count < 1 {
            self.reviewTable.hidden = true;
            self.listingLocationMap.frame = CGRect(x: self.listingLocationMap.frame.origin.x, y: self.listingLocationMap.frame.origin.y, width: self.listingLocationMap.frame.size.width, height: self.listingLocationMap.frame.height + self.reviewTable.frame.size.height)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func parseLocationString(locationString : NSString) -> CLLocationCoordinate2D
    {
        let coordinatesArray = locationString.componentsSeparatedByString(",")
        let lat = (coordinatesArray[0] as! NSString).doubleValue
        let lng = (coordinatesArray[1] as! NSString).doubleValue
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    func makeTelephoneCall(phone: String) {
        
        var alertController : UIAlertController = UIAlertController(title: "action", message: "call - \(phone) ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (action) -> Void in
            
        }
        
        let alertActionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            (actionOk) -> Void in
            let callUrl =  NSURL(string: "tel://\(phone)")
            UIApplication.sharedApplication().openURL(callUrl!)
        }
        
        alertController.addAction(alertActionOK)
        alertController.addAction(alertActionCancel)
        
        presentViewController(alertController, animated: true) { () -> Void in
            NSLog("alert action")
        }

    }
    
    func goHere(location: CLLocationCoordinate2D,launchOption : String) {
        var alertController : UIAlertController = UIAlertController(title: "action", message: (launchOption==MKLaunchOptionsDirectionsModeDriving) ? "Would you like to drive here ?" : "Would you like to walk here ? ", preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (action) -> Void in
            
        }
        
        let alertActionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            (actionOk) -> Void in
            self.openMapsForDriving(location, launchOption: launchOption)
        }
        
        alertController.addAction(alertActionOK)
        alertController.addAction(alertActionCancel)
        
        presentViewController(alertController, animated: true) { () -> Void in
            NSLog("alert action")
        }

    }
    
    func openMapsForDriving(location : CLLocationCoordinate2D,launchOption : String) {
        
        let placeMark : MKPlacemark = MKPlacemark(coordinate: location, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placeMark)
        var launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        
        NSLog("called open maps for driving method")
        
        mapItem.name = "Drive here."
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 125, height: 107)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : ListingPhotoCell = self.photoCollectionView.dequeueReusableCellWithReuseIdentifier("ListingPhotoCell", forIndexPath: indexPath) as! ListingPhotoCell
        
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
        
            if cell.businessPhotoImage == nil || cell.businessPhotoImage.image == nil {
        
            if let photos = self.listingDetail.photos as NSArray? {
                if photos.count > 0 {
                    
                    let photoName = photos[indexPath.row] as! String
                
                    if photoName == "no-images" {
                        cell.businessPhotoImage.image = UIImage(named: "noimages")
                    }
                    else {
                        let imageUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=640&maxheight=1000&photoreference=\(photos[indexPath.row])&key=\(PlaceFinder.apiKey)"
                
                        let url = NSURL(string: imageUrl)
                        var err: NSError?
                
                        if let imageData : NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err) as      NSData? {
                
                        if err == nil {
                                var img = UIImage(data:imageData)
                                cell.businessPhotoImage.image = img
                            }
                        }
                    }
                }
            }
        }
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listingDetail.photos.count
    }
   
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView : UIView = UIView(frame: CGRectMake(0, 0, self.reviewTable.frame.width, 32)) as UIView!
        
        headerView.backgroundColor = UIColor.darkGrayColor()
        
        var titleLabel = UILabel(frame: CGRectMake(20, 0, self.reviewTable.frame.width, 22)) as UILabel
        titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 18.0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Reviews"
        
        headerView.addSubview(titleLabel)
        return headerView
    }
}

