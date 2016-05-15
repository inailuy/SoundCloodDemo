//
//  BaseVC.swift
//  SoundCloodDemo
//
//  Created by inailuy on 4/29/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    var soundCloud : SoundCloud!
    
    override func viewDidLoad() {        
        let appDelegate = UIApplication.sharedApplication().delegate  as! AppDelegate
        soundCloud = appDelegate.soundCloud
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadAlert), name: "NO_INTERNET", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NO_INTERNET", object: nil)
    }
    
    func loadAlert() {
        let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
            self.activityIndicator.stopAnimating()
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {}
    }
}