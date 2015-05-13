//
//  InterfaceController.swift
//  WatchAround
//
//  Created by Cuddapah, Srikanth on 5/4/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit

class InterfaceController : WKInterfaceController,CLLocationManagerDelegate {
    
    @IBOutlet weak var categoryTable: WKInterfaceTable!
    
    var categorySubCollection : [NSArray] = []
    
    override init() {
        super.init()
        self.setUp()
    }
    
    func setUp() {
        self.loadCategories()
    }

    
    func loadCategories() {
        
        let path = NSBundle.mainBundle().pathForResource("CatData", ofType: "json") as String!
        
        if path != nil {
            NSLog("file path " + path)
            
            var jsonData : NSData = NSData(contentsOfFile: path) as NSData!
            var error : NSErrorPointer = nil
            var catCollection : NSArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments, error: error)
                as! NSArray
            
            if error != nil {

            }
            else {
                categoryTable.setNumberOfRows(catCollection.count, withRowType: "CategoryTableRowController")
                
                for(index,categoryItem) in enumerate(catCollection) {
                    
                    if let category = categoryItem as? NSDictionary {
                        
                        var subCategories : NSArray = category["subCategories"] as! NSArray!
                        var icon = category["icon"] as! String
                        var title = category["name"] as! String
                        var colorDict : NSDictionary = category["color"] as! NSDictionary
                        var color : UIColor = MiscUtil.parseColor(colorDict)
                        var subCategoriesCollection : [Category] = []
                        
                        for(scIndex,subCategoryItem) in enumerate(subCategories) {
                            var catObjName = subCategoryItem["name"] as! String
                            var catObjIcon = subCategoryItem["icon"] as! String
                            var catObjSearchKey = subCategoryItem["search_key"] as! String
                            var catObj : Category = Category(name:catObjName,icon:catObjIcon,searchKey:catObjSearchKey)
                            
                            catObj.backColor = color
                            subCategoriesCollection.append(catObj)
                        }
                        
                        self.categorySubCollection.append(subCategoriesCollection)
                        
                        // ************ Append table rows *******************		
                        
                        let row = categoryTable.rowControllerAtIndex(index) as! CategoryTableRowController;
                        row.categoryLabel.setText(title)
                        row.categoryImage.setImage(UIImage(named: icon))
                        row.categoryGroup.setBackgroundColor(color)
                        
                    }
                }
            }
        }

    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return [
            "categories" : self.categorySubCollection[rowIndex]
        ]
    }
}