//
//  ColorExtensions.swift
//  WatchAround
//
//  Created by Cuddapah, Srikanth on 5/4/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit

extension UIColor {
    
    func rgb() -> String
    {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
    
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return String(format: "#%02X%02X%02X",iRed,iGreen,iBlue,iAlpha)
        } else {
            return ""
        }
    }
    
}
