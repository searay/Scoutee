//
//  CategoryToggleCell.swift
//  WatchAround
//
//  Created by Cuddapah, Srikanth on 5/5/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import WatchKit

class CategoryToggleCell : UITableViewCell  {
        
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryOnOffSwitch: UISwitch!
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func setSelected(selected: Bool, animated: Bool) {
        self.backgroundColor = (selected) ? UIColor(red: 0.19607844948768616, green: 0.61960786581039429, blue: 0.90588241815567017, alpha: 1) : UIColor.clearColor()
    }
    
}