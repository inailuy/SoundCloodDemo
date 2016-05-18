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
    let IMAGE_TAG = 100
    let LABEL_TAG = 101
    let CELL_ID = "id"
    let PLAY = "PLAY"
    let PAUSE = "PAUSE"
    
    @IBOutlet weak var tableView: UITableView!
    var userFavorites = [Track]()
    
    @IBOutlet weak var playBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.frame = view.frame
        view.addSubview(activityIndicator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadData), name: "FINISHED_SOUNDCLOUD", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(rateChanged), name: "RATE_CHANGES", object: nil)

        refreshControl.addTarget(self, action: #selector(LikesVC.refreshTableView(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
    }
    
    @IBAction func playBarButtonPressed(sender: UIBarButtonItem) {
        AudioPlayer.sharedInstance.pausePlayMusic()
    }
    
    func rateChanged() {
        if AudioPlayer.sharedInstance.player.rate == 0.0 {
            playBarButton.title = PLAY
        } else {
            playBarButton.title = PAUSE
        }
    }
    
    func loadData() {
        activityIndicator.stopAnimating()
        self.refreshControl.endRefreshing()
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
        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: CELL_ID)
        }
        let trackObj = userFavorites[indexPath.row]
        
        let imageView = cell?.viewWithTag(IMAGE_TAG) as! UIImageView
        let label = cell?.viewWithTag(LABEL_TAG) as! UILabel
        label.text = trackObj.title

        if trackObj.artworkURL != nil {
            if let image = self.imageDictionary.valueForKey(trackObj.artworkURL!) {
                imageView.image = image as? UIImage
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
                            imageView.image = image
                            self.imageDictionary.setValue(image, forKey: trackObj.artworkURL!)
                        }
                    }
                }
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var array = [LikedTrackObject]()
        for track in userFavorites {
            array.append(track.createLikedObject())
        }
        
        let trackObj = array[indexPath.row]
        AudioPlayer.sharedInstance.playTrack(trackObj, with: array)
    
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
    }
    
    func refreshTableView(refreshControl: UIRefreshControl) {
        DataWorker.sharedInstance.startSoundcloud()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let track = userFavorites[indexPath.row]
            userFavorites.removeAtIndex(indexPath.row)
            soundCloud.deleteTrack(track.idValue)
            DataWorker.sharedInstance.deleteTrack(track, shouldSave: true)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        }
    }
}