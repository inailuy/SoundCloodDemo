//
//  SearchVC.swift
//  SoundCloodDemo
//
//  Created by inailuy on 4/29/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit

class SearchVC: BaseVC, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var searchQueryResults = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.frame = CGRectMake(view.frame.size.width/2 - 25, view.frame.size.height/2 - 25, 50, 50);
        view.addSubview(activityIndicator)
        
        refreshControl.addTarget(self, action: #selector(SearchVC.refreshCollectionView(_:)), forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    //MARK: - TableView Delegate/DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchQueryResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("id", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(100) as! UIImageView
        let label = cell.viewWithTag(101) as! UILabel
        let trackObj = searchQueryResults[indexPath.row] as! LikedTrackObject
        label.text = trackObj.title
        
        if trackObj.artworkURL != nil {
            if let image = self.imageDictionary.valueForKey(trackObj.artworkURL.absoluteString) {
                imageView.image = image as? UIImage
            } else {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    let url = trackObj.artworkURL
                    // Nice snippet for loading images asynchronously
                    // http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
                    DataWorker.sharedInstance.getDataFromUrl(url!) { (data, response, error)  in
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            guard let data = data where error == nil else { return }
                            let image = UIImage(data: data)
                            print(image)
                            imageView.image = image
                            self.imageDictionary.setValue(image, forKey: url.absoluteString)
                        }
                    }
                }
            }
        } else {
            imageView.image = UIImage()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let trackObj = searchQueryResults[indexPath.row] as! LikedTrackObject
        let array = NSArray(array: searchQueryResults) as! [LikedTrackObject]
        AudioPlayer.sharedInstance.playTrack(trackObj, with: array)
    }
    
    func refreshCollectionView(refreshControl: UIRefreshControl) {
        handleQuery(searchBar.text!)
    }
    //MARK: - UITextField Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.window?.endEditing(true)
        
        activityIndicator.startAnimating()
        handleQuery(searchBar.text!)
    }
    
    func handleQuery(searchText: String) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.searchQueryResults = self.soundCloud.searchForTracksWithQuery(searchText)
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
            })
        }
    }
}