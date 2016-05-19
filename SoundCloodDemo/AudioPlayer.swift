//
//  AudioPlayer.swift
//  SoundCloodDemo
//
//  Created by inailuy on 5/15/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

class AudioPlayer : NSObject {
    static let sharedInstance = AudioPlayer()
    let IS_PAUSED : Float = 0.0
    let FASTFOWARD : Float = 10.0
    let REWINDBACKWARD : Float = -10.0
    let PLAY : Float = 1
    var isPlaying = false
    var player = AVPlayer()
    var playerItem : AVPlayerItem!
    var likedObjects = [LikedTrackObject]()
    var currentLikedObject = LikedTrackObject()
    var playerItemDictionary = NSMutableDictionary()
    
    func playTrack(track:LikedTrackObject, with array: [LikedTrackObject]?) {
        currentLikedObject = track
        if array != nil { likedObjects = array! }
        print(currentLikedObject.duration.intValue)
        playSongFromURL(currentLikedObject.streamURL)
        setDefaultCenter(0, duration: 0)
    }

    func playSongFromURL(songURL: NSURL) {
        let scToken = NSUserDefaults.standardUserDefaults().objectForKey(SC_TOKEN) as! String
        let songUrlString = String(format: "%@?oauth_token=%@", songURL.absoluteURL, scToken)
        if let item = playerItemDictionary.valueForKey(songURL.absoluteString) {
            playerItem = item as! AVPlayerItem
        } else {
            if !hasConnectivity() {
                NSNotificationCenter.defaultCenter().postNotificationName("TRIGGER_ALERT", object: "No Internet Connection")
                return
            }
            playerItem = AVPlayerItem(URL: NSURL(string: songUrlString)!)
            playerItemDictionary.setValue(playerItem.copy(), forKey: songURL.absoluteString)
        }

        player = AVPlayer(playerItem: playerItem)
        player.play()
        isPlaying = true
        NSNotificationCenter.defaultCenter().postNotificationName("RATE_CHANGES", object: nil)
        player.addPeriodicTimeObserverForInterval(CMTimeMake(1000,25000), queue: dispatch_get_main_queue()) {
            time in
            let seconds = Float(time.value) / Float(time.timescale)
            let duration = self.currentLikedObject.duration.floatValue / 1000
            
            self.setDefaultCenter(seconds, duration: duration)
        }
    }
    
    func audioStateChanged() {
        playNextTrack()
    }
    
    func playNextTrack() {
        if var index = likedObjects.indexOf(currentLikedObject) {
            if index + 1 < likedObjects.count {
                index = index + 1
            } else {
                index = 0
            }
            playTrack(likedObjects[index], with: nil)
        }
    }
    
    func playPreviousTrack() {
        if var index = likedObjects.indexOf(currentLikedObject) {
            let currentVale = Double(player.currentTime().value)
            let timeScale = Double(player.currentTime().timescale)
            if (currentVale / timeScale) > 3.5 {
                player.seekToTime(CMTimeMake(0, 1))
                player.play()
            } else {
                index = index - 1
                if index < 0 {
                    index = likedObjects.count - 1
                }
                playTrack(likedObjects[index], with: nil)
            }
        }
    }
    
    func pausePlayMusic() {
        if player.rate == IS_PAUSED {
            play()
        } else {
            pause()
        }
        NSNotificationCenter.defaultCenter().postNotificationName("RATE_CHANGES", object: nil)
    }
    
    func play()  {
        isPlaying = true
        player.play()
    }
    
    func pause()  {
        isPlaying = false
        player.pause()
    }
    
    func changeRate(rate: Float) {
        print(rate)
        player.rate = rate
        
    }
    
    func remoteControlWithEvent(event: UIEvent) {
        if event.type == UIEventType.RemoteControl {
            switch event.subtype {
            case UIEventSubtype.RemoteControlPlay:
                pausePlayMusic()
                break;
                
            case UIEventSubtype.RemoteControlNextTrack:
                playNextTrack()
                break;
                
            case UIEventSubtype.RemoteControlPause:
                pausePlayMusic()
                break;
                
            case UIEventSubtype.RemoteControlPreviousTrack:
                playPreviousTrack()
                break;
                
            case UIEventSubtype.RemoteControlBeginSeekingForward:
                changeRate(FASTFOWARD)
                break;
                
            case UIEventSubtype.RemoteControlEndSeekingForward:
                changeRate(PLAY)
                break;
                
            case UIEventSubtype.RemoteControlBeginSeekingBackward:
                changeRate(REWINDBACKWARD)
                break;
                
            case UIEventSubtype.RemoteControlEndSeekingBackward:
                changeRate(PLAY)
                break;
                
            default:
                break;

            }
        }
    }
    
    func setDefaultCenter(seconds: Float, duration: Float) {
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPNowPlayingInfoPropertyElapsedPlaybackTime:seconds,
            MPNowPlayingInfoPropertyPlaybackRate:self.isPlaying,
            MPMediaItemPropertyPlaybackDuration:duration,
            MPMediaItemPropertyTitle:self.currentLikedObject.title
        ]
    }
    
    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
}