//
//  ListingWebViewController.swift
//  Scoutee
//
//  Created by srikanth cuddapah on 5/15/15.
//  Copyright (c) 2015 srikanth cuddapah. All rights reserved.
//

import Foundation
import UIKit

class ListingWebViewController : UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webControl: UIWebView!
    var webSite : String = ""
    var progressView : UIView = UIView()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func buildProgressBarDialog() {
        self.progressView = MiscUtil.buildProgressDialog("Loading",parent: self.view)
        
        if let dlg = UIApplication.sharedApplication().delegate {
            if let win = dlg.window {
                win?.rootViewController?.view.addSubview(self.progressView)
                win?.rootViewController?.view.bringSubviewToFront(self.progressView)
            }
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        hideProgressDialog()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        showProgressDialog()
    }
    
    
    func hideProgressDialog() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.progressView.hidden = true
        })
    }
    
    func showProgressDialog() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.progressView.hidden = false
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buildProgressBarDialog()
        
        let url = NSURL(string: self.webSite)
        
        if let siteUrl = url as NSURL? {
            let req = NSURLRequest(URL: url!)
            self.webControl.loadRequest(req)
        }
    }

}