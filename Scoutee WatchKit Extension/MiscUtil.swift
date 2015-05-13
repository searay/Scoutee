//
//  MiscUtil.swift
//  WatchAround
//
//  Created by Cuddapah, Srikanth on 5/6/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit

class MiscUtil {
    class func parseColor(colorDict : NSDictionary) -> UIColor {
        
        let red : Double = (colorDict["red"] as! NSString).doubleValue
        let green : Double = (colorDict["green"] as! NSString).doubleValue
        let blue : Double = (colorDict["blue"] as! NSString).doubleValue
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
    
    class func hexStringToUIColor(hex:NSString) -> UIColor
    {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func getDistanceFormatted(distance: Double) -> String {
        var dist = String(format: "%.2f meters",distance)
        
        if distance > 1609.0 {
            dist = String(format: "%.2f miles",distance/1609)
        } else {
            dist = String(format: "%.2f km",distance/1000)
        }
        
        return dist;
    }
    
    class func parseLocationString(locationString : String) -> CLLocationCoordinate2D
    {
        let coordinatesArray = locationString.componentsSeparatedByString(",")
        let lat = (coordinatesArray[0] as NSString).doubleValue
        let lng = (coordinatesArray[1] as NSString).doubleValue
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }

}