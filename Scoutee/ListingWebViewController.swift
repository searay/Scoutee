//
//  ListingWebViewController.swift
//  Scoutee
//
//  Created by srikanth cuddapah on 5/15/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import UIKit

class ListingWebViewController : UIViewController {
    @IBOutlet weak var webControl: UIWebView!
    var webSite : String = ""
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: self.webSite)
        
        if let siteUrl = url as NSURL? {
            let req = NSURLRequest(URL: url!)
            self.webControl.loadRequest(req)
        }
    }

}