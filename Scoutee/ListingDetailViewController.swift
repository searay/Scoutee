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


class ListingDetailViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var listingPhoto: UIImageView!
    let apiKey = "AIzaSyCjfOWwKoajoY8gPHaIvSyUEZPztFmWY80"
    var listing : Listing = Listing()
    
    @IBOutlet weak var listingLocationMap: MKMapView!
    @IBOutlet weak var actionToolbar: UIToolbar!
    
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
    
    func setUp() {
        if let loc = listing.location as NSString? {
           
            var location = parseLocationString(loc as NSString!) as CLLocationCoordinate2D!
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
            var annotation = LocationPinAnnotation(title:listing.name!,locationName:listing.name!,discipline:listing.vicinity,coordinate:location)
            var pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinAnnotation")
            pinAnnotation.backgroundColor = UIColor.yellowColor()
            
            listingLocationMap.addAnnotation(annotation)
            listingLocationMap.setRegion(region, animated: true)
            
                        
            var nib = UINib(nibName: "ListingPhotoCell", bundle: nil)
            self.photoCollectionView.registerNib(nib, forCellWithReuseIdentifier: "ListingPhotoCell")
            
            var flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
            
            self.photoCollectionView.contentSize = CGSize(width: self.view.frame.size.width+200, height: 54)
            self.photoCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        // align controls
        
        self.photoCollectionView.frame = CGRect(x:self.photoCollectionView.frame.origin.x,
            y:self.photoCollectionView.frame.origin.y,width:self.view.frame.width,height:self.photoCollectionView.bounds.height)
        
        self.listingLocationMap.frame = CGRect(x:0,
            y:self.listingLocationMap.frame.origin.y,width:self.view.frame.width,height:self.listingLocationMap.bounds.height)

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
        return CGSize(width: 370, height: 300)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : ListingPhotoCell = self.photoCollectionView.dequeueReusableCellWithReuseIdentifier("ListingPhotoCell", forIndexPath: indexPath) as! ListingPhotoCell
        
        if let photos = listing.pics as NSArray? {
            if photos.count > 0 {
                
                let imageUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photos[indexPath.row])&key=\(apiKey)"
                
                let url = NSURL(string: imageUrl)
                var err: NSError?
                
                if let imageData : NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err) as NSData? {
                
                    if err == nil {
                        var img = UIImage(data:imageData)
                        cell.businessPhotoImage.image = img
                    }
                }
                
            }
        }
        
        return cell;
    }

    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell : CategoryCollectionCell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionCell {
            
            cell.selectIndicatorImage.hidden = true
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos = listing.pics as NSArray? {
            return photos.count
        } else {
            return 0
        }

    }

}

