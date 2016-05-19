//
//  BaseVC.swift
//  SoundCloodDemo
//
//  Created by inailuy on 4/29/16.
//  Copyright © 2016 inailuy. All rights reserved.
//
import UIKit

class BaseVC: UIViewController {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var soundCloud : SoundCloud!
    var imageDictionary = NSMutableDictionary()
    var appDelegate : AppDelegate!
    let refreshControl = UIRefreshControl()
    //MARK: -
    override func viewDidLoad() {
        appDelegate = UIApplication.sharedApplication().delegate  as! AppDelegate
        soundCloud = appDelegate.soundCloud
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseVC.loadAlert(_:)), name: "TRIGGER_ALERT", object: nil)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TRIGGER_ALERT", object: nil)
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        resignFirstResponder()
    }
    //MARK: Notifications
    func loadAlert(notification:NSNotification) {
        let message = notification.object as! String
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            if message == "Please login to SoundCloud" {
                self.soundCloud.performLogin()
            } else {
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {}
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        AudioPlayer.sharedInstance.remoteControlWithEvent(event!)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
}