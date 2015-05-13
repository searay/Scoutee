    //
    //  PlaceFinder.swift
    //  WatchAround
    //
    //  Created by srikanth cuddapah on 4/18/15.
    //  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
    //
    
    import Foundation
    import WatchKit
    
    
    class PlaceFinder : NSObject,NSURLConnectionDataDelegate {
        
        let apiKey = "AIzaSyCjfOWwKoajoY8gPHaIvSyUEZPztFmWY80"
        
        override init() {
            super.init()
        }
        
        func getListingContactNumber(placeId : String) -> String{
            var phone = String("")
            let queryString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(apiKey)&rankby=distance"
            
            if let url = NSURL(string: queryString)
            {
                var urlRequest : NSMutableURLRequest = NSMutableURLRequest(URL: url)
                var urlResponse : NSURLResponse?
                var error : NSErrorPointer = nil
                let data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &urlResponse, error: error)
                
                if data != nil
                {
                    var jsonData : NSDictionary =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: error) as! NSDictionary
                    
                    var status = jsonData.valueForKey("status") as! String
                    var result = jsonData.valueForKey("result") as! NSDictionary
                    
                    if status == "OK"
                    {
                        if result.allKeys.count > 0
                        {
                            phone = result.valueForKey("formatted_phone_number") as! String
                            phone = formatPhoneNumber(phone)
                        }
                    }
                }
            }
            
            return phone
        }
        
        
        func formatPhoneNumber(phoneNumber : String) -> String {
            var stringParts : NSArray = phoneNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) as NSArray
            return stringParts.componentsJoinedByString("")
        }
        
        
        func calculateDistance(lat : Double, lng : Double, clat : Double, clng : Double) -> Double
        {
            var currLoc : CLLocation = CLLocation(latitude: clat, longitude: clng)
            var listLoc : CLLocation = CLLocation(latitude: lat, longitude: lng)
            
            var distInMeters = currLoc.distanceFromLocation(listLoc) as Double!
            
            return distInMeters
        }
        
        func findListing(Query : LocationQuery,SortByDistance : Bool) -> [Listing]
        {
            var listings : [Listing] = []
            var queryString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(Query.location!)&radius=\(Query.distance)&types=\(Query.what!)&key=\(apiKey)"
            
            
            if let url = NSURL(string: queryString)
            {
                let urlRequest : NSMutableURLRequest = NSMutableURLRequest(URL: url)
                var urlResponse : NSURLResponse?
                var error : NSErrorPointer = nil
                
                let data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &urlResponse, error: error)
                
                if data != nil {
                    let jsonData : NSDictionary =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: error) as! NSDictionary
                    
                    let status = jsonData.valueForKey("status") as! String
                    let results = jsonData.valueForKey("results") as! Array<NSDictionary>
                    let nextPageToken = jsonData.valueForKey("next_page_token") as? NSString
                    
                    if status == "OK" {
                        if results.capacity > 0 {
                            for result in results {
                                if result.allKeys.count > 0 {
                                    let listingItem = getListingFromDict(result,queryLocation:Query.location)
                                    listings.append(listingItem)
                                }
                            }
                            
                            // get data from second page if available
                            
                            if let pageToken = nextPageToken as NSString? {
                                if pageToken.length > 0 {
                                    var queryStringNextPage = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=\(pageToken)&key=\(apiKey)"
                                    
                                    if let nextPageUrl = NSURL(string: queryStringNextPage)
                                    {
                                        let urlRequestnp : NSMutableURLRequest = NSMutableURLRequest(URL: nextPageUrl)
                                        var urlResponsenp : NSURLResponse?
                                        var errornp : NSErrorPointer = nil
                                        
                                        let datanp = NSURLConnection.sendSynchronousRequest(urlRequestnp, returningResponse: &urlResponsenp, error: errornp)
                                        
                                        if datanp != nil {
                                            let jsonDatanp : NSDictionary =  NSJSONSerialization.JSONObjectWithData(datanp!, options: NSJSONReadingOptions.AllowFragments, error: error) as! NSDictionary
                                            
                                            let statusnp = jsonDatanp.valueForKey("status") as! String
                                            let resultsnp = jsonDatanp.valueForKey("results") as! Array<NSDictionary>
                                            
                                            if statusnp == "OK" {
                                                if resultsnp.capacity > 0 {
                                                    for resultnp in resultsnp {
                                                        if resultnp.allKeys.count > 0 {
                                                            listings.append(getListingFromDict(resultnp, queryLocation: Query.location))
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return sortListings(listings,byDistance : SortByDistance)
        }
        
        func getListingFromDict(result : NSDictionary,queryLocation : String) -> Listing {
            let id = result.valueForKey("place_id") as! String
            let name = result.valueForKey("name") as! String
            let vacinity = result.valueForKey("vicinity") as! String
            let geometry = result.valueForKey("geometry") as! NSDictionary
            let location = geometry.valueForKey("location") as! NSDictionary
            let latitude = location.valueForKey("lat") as! Double
            let longitude = location.valueForKey("lng") as! Double
            let icon = result.valueForKey("icon") as! String
            
            var listingItem = Listing()
            
            if let photos = result.valueForKey("photos") as? Array<NSDictionary> {
                
                if photos.capacity > 0 {
                    for photo in photos {
                        let photoRef = photo.valueForKey("photo_reference") as! NSString
                        listingItem.pics.append(photoRef)
                        
                    }
                }
            }
            
            if let openHoursRoot = result.valueForKey("opening_hours") as? NSDictionary {
                let isOpen =    openHoursRoot.valueForKey("open_now") as! Bool
                listingItem.open = isOpen
            }
            
            // current location
            
            let clat = (queryLocation.componentsSeparatedByString(",")[0] as NSString).doubleValue
            let clng = (queryLocation.componentsSeparatedByString(",")[1] as NSString).doubleValue
            
            listingItem.id = id
            listingItem.name = name
            listingItem.vicinity = vacinity
            listingItem.iconUrl = icon
            listingItem.distance = calculateDistance(latitude, lng: longitude, clat: clat, clng: clng)
            
            if let rating = result.valueForKey("rating") as? Double {
                listingItem.rating = rating
            }
            
            listingItem.location = String(format:"%f,%f",latitude,longitude)
            
            return listingItem
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
    }
    
    