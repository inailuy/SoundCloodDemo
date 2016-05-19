//
//  DatabaseWorker.swift
//  SoundCloodDemo
//
//  Created by inailuy on 5/11/16.
//  Copyright © 2016 inailuy. All rights reserved.
//
import UIKit
import CoreData
import CoreSpotlight
import MobileCoreServices

class DataWorker {
    static let sharedInstance = DataWorker()
    var tracks = [Track]()
    var fetchedObjects = NSArray()
    var appDelegate : AppDelegate!
    //MARK: -
    init () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadSoundcloud), name: TRACKS_LOADED_NOTIFIACTION, object: nil)
        appDelegate = UIApplication.sharedApplication().delegate  as! AppDelegate
        do {
            let fetchRequest = NSFetchRequest()
            let entity = NSEntityDescription.entityForName("Track", inManagedObjectContext: appDelegate.managedObjectContext)
            fetchRequest.entity = entity
            try fetchedObjects = self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
        } catch {
            print(error)
        }
    }
    //MARK: - SoundCloud API
    func startSoundcloud() {
        if !hasConnectivity() {
            NSNotificationCenter.defaultCenter().postNotificationName("TRIGGER_ALERT", object: "No Internet Connection")
            return
        }
        
        let soundCloud = appDelegate.soundCloud
        if soundCloud.login() {
            soundCloud.loadLikedTrackArray()
        }
    }
    
    @objc func loadSoundcloud() {
        var newArray = [Track]()
        //Guarding against tracksFavorited being empty and crashing
        guard let favorites = appDelegate.soundCloud.tracksFavorited
        else {
            NSNotificationCenter.defaultCenter().postNotificationName("TRIGGER_ALERT", object: "User has no favorites to display")
            return
        }
        
        for likedTrackObject in favorites {
            let request = NSFetchRequest()
            let entity = NSEntityDescription.entityForName("Track", inManagedObjectContext: appDelegate.managedObjectContext)
            request.entity = entity
            request.predicate = NSPredicate(format: "title = %@", likedTrackObject.title)
            do {
                let list = try appDelegate.managedObjectContext.executeFetchRequest(request) as! [Track]
                var track : Track?
                // success ...
                if list.count == 0 {
                    track = createAndSaveTrack(likedTrackObject as! LikedTrackObject)
                } else {
                    track = list[0]
                }
                newArray.append(track!)
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
        
        if tracks.count > 0 {
            for track in tracks as [Track] {
                if newArray.contains(track) == false{
                    deleteTrack(track, shouldSave: false)
                }
            }
        }
        do {
            try appDelegate.managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        tracks = newArray
        NSNotificationCenter.defaultCenter().postNotificationName("FINISHED_SOUNDCLOUD", object: nil)
    }
    // Used to download images asynchronously
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    //MARK: COREDATA
    func fetchAllTracks(completion: (array: NSArray) -> Void) {
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Track")
        let sectionSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            tracks = results as! [Track]
            completion(array: tracks)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func createAndSaveTrack(likedTrackObject: LikedTrackObject) -> Track {
        let managedContext = appDelegate.managedObjectContext
        let track = NSEntityDescription.insertNewObjectForEntityForName("Track", inManagedObjectContext: managedContext) as! Track
        track.addValues(likedTrackObject)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.addTrackToSpotlight(track)
        }
       
        return track
    }
    
    func deleteTrack(track:Track, shouldSave: Bool) {
        deleteFromSpotlight(track)
        appDelegate.managedObjectContext.deleteObject(track)
        
        if shouldSave {
            do {
                try appDelegate.managedObjectContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    //MARK: Connectivity
    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    //MARK:  Spotlight
    func addTrackToSpotlight(track: Track) {
        if track.title!.isEmpty {
            return
        }
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeMP3 as String)
        let title = track.title

        attributeSet.title = title
        if track.artworkURL != nil {
            let url = NSURL(string: track.artworkURL!)
            attributeSet.thumbnailData = NSData(contentsOfURL: url!)
        }
        
        let searchableItem = CSSearchableItem(uniqueIdentifier: title, domainIdentifier: track.artworkURL, attributeSet:attributeSet)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([searchableItem], completionHandler: nil)
    }
    
    func deleteFromSpotlight(track:Track) {
        if track.title!.isEmpty {
            return
        }
        CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers([track.title!], completionHandler: nil)
    }
}