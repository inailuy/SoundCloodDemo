//
//  Track+CoreDataProperties.swift
//  SoundCloodDemo
//
//  Created by inailuy on 5/12/16.
//  Copyright © 2016 inailuy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Track {

    @NSManaged var streamURL: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var duration: NSNumber?
    @NSManaged var artworkURL: String?
    @NSManaged var title: String?
    @NSManaged var streamable: NSNumber?
    @NSManaged var idValue: NSNumber?
    
    func addValues(likedTrackObject: LikedTrackObject) {
        if likedTrackObject.streamURL != nil {
            streamURL = likedTrackObject.streamURL.absoluteString
        }
        if likedTrackObject.createdAt != nil {
            createdAt = likedTrackObject.createdAt
        }
        if likedTrackObject.duration != nil {
            duration = likedTrackObject.duration
        }
        if likedTrackObject.artworkURL != nil {
            artworkURL = likedTrackObject.artworkURL.absoluteString
        }
        if likedTrackObject.title != nil {
            title = likedTrackObject.title
        }
        if likedTrackObject.streamable != nil {
            streamable = likedTrackObject.streamable
        }
        if likedTrackObject.idValue != nil {
            idValue = likedTrackObject.idValue
        }
    }
}
