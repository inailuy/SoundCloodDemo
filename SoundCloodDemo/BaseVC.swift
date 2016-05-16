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
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var soundCloud : SoundCloud!
    
    override func viewDidLoad() {        
        let appDelegate = UIApplication.sharedApplication().delegate  as! AppDelegate
        soundCloud = appDelegate.soundCloud
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseVC.loadAlert(_:)), name: "TRIGGER_ALERT", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TRIGGER_ALERT", object: nil)
    }
    
    func loadAlert(notification:NSNotification) {
        let message = notification.object as! String
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            if message == "Please login to SoundCloud" {
                self.soundCloud.performLogin()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {}
    }
}