//
//  SubCategoriesController.swift
//  WatchAround
//
//  Created by Cuddapah, Srikanth on 5/4/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit

class SubCategoriesController : WKInterfaceController,CLLocationManagerDelegate {
    
    @IBOutlet weak var subCategoryTable: WKInterfaceTable!
    
    var categories : [Category] = []
    var locationManager : CLLocationManager = CLLocationManager()
    
    @IBAction func onShowBookmarks() {
        
        let commands : Dictionary = [
            "getBookmarks" : "true"]
        
        WKInterfaceController.openParentApplication(commands,reply : {
            (replyInfo,error) -> Void in
            NSLog("replied to get book marks")
        })
    }
    
    override init() {
        super.init()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.setUp(context)
    }
    
    func setUp(context : AnyObject?) {
        if let categories = (context as! NSDictionary)["categories"] as! [Category]? {
            self.initializeLocationService()
            self.categories = categories
            self.loadTableData()
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
        locationManager.stopUpdatingLocation()
        pushControllerWithName("ErrorInfoController", context:nil)
    }
    
    @IBAction func showErrorDialog() {
        
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    private func loadTableData() {
        subCategoryTable.setNumberOfRows(categories.count, withRowType: "CategoryTableRowController");
        var index = 0
        
        for(index,categoryObj) in enumerate(categories) {
            let row = subCategoryTable.rowControllerAtIndex(index) as! CategoryTableRowController;
            row.categoryLabel.setText(categoryObj.name)
            row.categoryGroup.setBackgroundColor(categoryObj.backColor)
            row.categoryImage.setImage(UIImage(named: categoryObj.icon))
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
            let locationString = String(format: "%f,%f",locationManager.location.coordinate.latitude,
                locationManager.location.coordinate.longitude)
        
            let key = categories[rowIndex].name as String
            let filter = categories[rowIndex].searchKey as String
            let bgColor = categories[rowIndex].backColor
        
            return [
                "data" : key,
                "filter" : filter,
                "location" : locationString,
                "color" : bgColor.rgb()
            ]
        }
}