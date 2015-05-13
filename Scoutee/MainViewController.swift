//
//  ViewController.swift
//  WatchAround
//
//  Created by srikanth cuddapah on 4/18/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var mainCategoriesCollView: UICollectionView!
    @IBOutlet weak var subCategoryTableView: UITableView!
    
    var categorySubCollection : [NSArray] = []
    var categoryHeaderNames : [String] = []
    var categoryIcons : [String] = []
    var currentIndex : Int = 0
    
    let TABLE_CELL_NIB_NAME = "CategoryToggleCell"
    let TABLE_CELL_REUSE_ID  = "listingCell"
    
    let COLLECTION_VIEW_CELL_NAME = "CategoryCollectionCell"
    let COLLECTION_VIEW_REUSE_ID = "categoryCollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
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
        
        self.mainCategoriesCollView.contentSize = CGSize(width: self.view.frame.size.width+200, height: 74)
        self.mainCategoriesCollView.setCollectionViewLayout(flowLayout, animated: true)
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
        
        if segue.identifier == "ShowResults" {
            let destinationController : SearchResultsListController = segue.destinationViewController as! SearchResultsListController
            destinationController.searchKey = getSearchKeyFromSelectedRow()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowResults", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorySubCollection[currentIndex].count
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        self.subCategoryTableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.blueColor()
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
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
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

