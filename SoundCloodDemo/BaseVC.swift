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
    var soundCloud : SoundCloud!
    
    override func viewDidLoad() {        
        let appDelegate = UIApplication.sharedApplication().delegate  as! AppDelegate
        soundCloud = appDelegate.soundCloud
    }
}