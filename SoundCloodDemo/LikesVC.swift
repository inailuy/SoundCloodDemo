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
    var imageDictionary = NSMutableDictionary()
    
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
        if trackObj.artworkURL != nil {
            if let image = self.imageDictionary.valueForKey(trackObj.artworkURL!) {
                cell!.imageView!.image = image as? UIImage
            } else {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    let url = NSURL(string: trackObj.artworkURL!)
                    // Nice snippet for loading images asynchronously
                    // http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
                    DataWorker.sharedInstance.getDataFromUrl(url!) { (data, response, error)  in
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            guard let data = data where error == nil else { return }
                            let image = UIImage(data: data)
                            cell!.imageView!.image = image
                            self.imageDictionary.setValue(image, forKey: trackObj.artworkURL!)
                        }
                    }
                }
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        let trackObj = userFavorites[indexPath.row]
        AudioPlayer.sharedInstance.playSongFromURL(NSURL(string: trackObj.streamURL!)!)
    }
}