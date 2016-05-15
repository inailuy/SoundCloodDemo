//
//  LikesVC.swift
//  SoundCloodDemo
//
//  Created by inailuy on 4/29/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit

class LikesVC: BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var userFavorites = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.frame = view.frame
        view.addSubview(activityIndicator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadData), name: "FINISHED_SOUNDCLOUD", object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        loadData()
    }
    
    @IBAction func refreashButtonPressed(sender: AnyObject) {
        activityIndicator.startAnimating()
        DataWorker.sharedInstance.startSoundcloud()
    }
    
    func loadData() {
        activityIndicator.stopAnimating()
        DataWorker.sharedInstance.fetchAllTracks({ (array: NSArray) in
            if !array.isEqualToArray(self.userFavorites) {
                self.userFavorites = array as! [Track]
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    //MARK: - TableView Delegate/DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFavorites.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("id")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "id")
        }
        
        let trackObj = userFavorites[indexPath.row]
        cell?.textLabel?.text = trackObj.title
        //[cell.imageView setImageWithURL:trackObj.artworkURL placeholderImage:[UIImage imageNamed:@"Icon"]];

        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
}