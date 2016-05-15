//
//  AudioPlayer.swift
//  SoundCloodDemo
//
//  Created by inailuy on 5/15/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation

class AudioPlayer {
    static let sharedInstance = AudioPlayer()
    var player = AVPlayer()
    var playerItem : AVPlayerItem!

    func playSongFromURL(songURL: NSURL) {
        let scToken = NSUserDefaults.standardUserDefaults().objectForKey(SC_TOKEN) as! String
        let songUrlString = String(format: "%@?oauth_token=%@", songURL.absoluteURL, scToken)
        playerItem = AVPlayerItem(URL: NSURL(string: songUrlString)!)
        player = AVPlayer(playerItem: playerItem)
        player.play()
    }
}