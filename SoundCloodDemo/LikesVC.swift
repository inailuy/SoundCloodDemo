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
    var userFavorites = NSMutableArray()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadData), name: TRACKS_LOADED_NOTIFIACTION, object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        if soundCloud.login() {
            activityIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
            self.soundCloud.loadLikedTrackArray()
        }
    }
    
    @IBAction func refreashButtonPressed(sender: AnyObject) {
        
    }
    //MARK: - TableView Delegate/DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFavorites.count
    }
    
    func loadData() {
        activityIndicator.stopAnimating()
        userFavorites = soundCloud.tracksFavorited
        tableView.reloadData()
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