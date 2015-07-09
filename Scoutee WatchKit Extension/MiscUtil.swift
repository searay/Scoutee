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
    
    class func getRatingStars(rating : Double) -> String {
        var ratingLabelText = ""
        var i : Double
        
        for i = 0; i < round(rating); i++ {
            ratingLabelText += "*"
        }
        
        return ratingLabelText
    }

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
    
    class func buildProgressDialog(title : String,parent : UIView) -> UIView {
        var view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        
        view.backgroundColor = UIColor.brownColor()
        view.alpha = 0.9
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        view.center = CGPoint(x: parent.bounds.width/2, y: parent.bounds.height/2)
        view.hidden = true
        
        var progress : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        progress.frame = CGRect(x: 35, y: 25, width: 50, height: 50)
        view.addSubview(progress)
        
        var label : UILabel = UILabel(frame: CGRect(x: 5, y: 36, width: 115, height: 100))
        label.text = title
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Helvetica Neue Condense-Bold", size: 15.0)
        label.textColor = UIColor.whiteColor()
        view.addSubview(label)
        
        progress.startAnimating()
        
        return view
    }
    
    class func getDistanceFormatted(distance: Double) -> String {
        //var dist = String(format: "%.2f meters",distance)
        
        //if distance > 1609.0 {
            var dist = String(format: "%.2f mi",distance/1609)
        //} //else {
          //  dist = String(format: "%.2f km",distance/1000)
        //}
        
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