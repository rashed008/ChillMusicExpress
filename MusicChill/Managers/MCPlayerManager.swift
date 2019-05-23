//
//  MCPlayerManager.swift
//  MusicChill
//
//  Created by AAPBD on 2/14/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import UIKit
import HysteriaPlayer

class MCPlayerManager : NSObject, HysteriaPlayerDelegate, HysteriaPlayerDataSource {
    static let manager = MCPlayerManager()
    
    var hysteriaPlayer: HysteriaPlayer!
    
    var playableMedias = [Track]()
    var currentTrackIndex: Int = 0
    
    override init() {
        super.init()
        setupHyseteriaPlayer()
    }
    
    func setupHyseteriaPlayer(){
        hysteriaPlayer = HysteriaPlayer.sharedInstance()
        hysteriaPlayer.delegate = self
        hysteriaPlayer.datasource = self
        
        self.hysteriaPlayer.removeAllItems()
        self.hysteriaPlayer.setPlayerRepeatMode(HysteriaPlayerRepeatMode.Off)
//        self.hysteriaPlayer.fetchAndPlayPlayerItem(currentTrackIndex)
    }
    
    //-----------------------------------------------------------------
    // MARK: - HyseteriaPlayer Delegate
    //-----------------------------------------------------------------
    func hysteriaPlayerDidFailed(identifier: HysteriaPlayerFailed, error: NSError!) {
        print("\(__FUNCTION__)")
    }
    
    func hysteriaPlayerReadyToPlay(identifier: HysteriaPlayerReadyToPlay) {
        
        switch (identifier) {
        case .Player:
            break
            
        case .CurrentItem:
            
            NSNotificationCenter.defaultCenter().postNotificationName(AppConstants.Notif.HysteriaPlayerReadyToPlayNotification, object: hysteriaPlayer, userInfo: nil)
            
            if !self.hysteriaPlayer.isPlaying() {
                self.hysteriaPlayer.pausePlayerForcibly(false)
                self.hysteriaPlayer.play()
            }
            
            break
            
        }
    }
    
    func hysteriaPlayerCurrentItemChanged(item: AVPlayerItem!) {
        print("\(__FUNCTION__)")
    }
    
    func hysteriaPlayerCurrentItemPreloaded(time: CMTime) {
        print("\(__FUNCTION__)")
    }
    
    func hysteriaPlayerDidReachEnd() {
        print("\(__FUNCTION__)")
    }
    
    func hysteriaPlayerRateChanged(isPlaying: Bool) {
        print("\(__FUNCTION__)")
        NSNotificationCenter.defaultCenter().postNotificationName(AppConstants.Notif.PlayerRateChangedNotification, object: hysteriaPlayer, userInfo: ["isPlaying":isPlaying])
    }
    
    func hysteriaPlayerWillChangedAtIndex(index: Int) {
        print("\(__FUNCTION__)")
        currentTrackIndex = index
        NSNotificationCenter.defaultCenter().postNotificationName(AppConstants.Notif.PlayerWillChangedAtIndexNotification, object: hysteriaPlayer, userInfo: ["index":index])
    }
    
    //-----------------------------------------------------------------
    // MARK: - HyseteriaPlayer DataSource
    //-----------------------------------------------------------------
    func hysteriaPlayerNumberOfItems() -> Int {
        print("\(__FUNCTION__)")
        return self.playableMedias.count
    }
    
    func hysteriaPlayerURLForItemAtIndex(index: Int, preBuffer: Bool) -> NSURL! {
        
        let track = playableMedias[index]
        
        //        let url = NSURL(string: AppConstants.Api.client_id, relativeToURL: NSURL(string: track.stream_url!))
        let url = NSURL(string: "\(track.stream_url!)?client_id=\(AppConstants.Api.client_id)")
        print("url = \(url)")
        
        return url
    }
}
