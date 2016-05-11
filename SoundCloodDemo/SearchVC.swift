//
//  SearchVC.swift
//  SoundCloodDemo
//
//  Created by inailuy on 4/29/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit

class SearchVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchQueryResults = NSMutableArray()
    
    //MARK: - TableView Delegate/DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchQueryResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("id")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "id")
        }
        
        let obj = searchQueryResults[indexPath.row]
        cell?.textLabel?.text = obj.title
        //[cell.imageView setImageWithURL:obj.artworkURL placeholderImage:[UIImage imageNamed:@"Icon"]];
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    //MARK: - UITextField Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.window?.endEditing(true)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.searchQueryResults = self.soundCloud.searchForTracksWithQuery(searchBar.text)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
}