//
//  AppConstants.swift
//  MusicChill
//
//  Created by Shaiful Islam Sujohn on 2/3/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import Foundation

struct AppConstants {
    
    //static let IS_IOS_8_OR_LATER: Bool = (UIDevice.currentDevice().systemVersion.toFailSafeFloat() >= 8.0) //[[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
    
    static let offset = "0"
    static let limit = "50"
    
    struct Notif {
        
        static let PlayerRateChangedNotification = "PlayerRateChangedNotification"
        static let PlayerWillChangedAtIndexNotification = "PlayerWillChangedAtIndexNotification"
        static let HysteriaPlayerReadyToPlayNotification = "HysteriaPlayerReadyToPlayNotification"
    }
    
    struct Api {
        
        static let DomainUrl = "http://api.soundcloud.com/"
        static let BaseUrl = "http://api.soundcloud.com/"
        
        static let Playlists = "playlists.json"
        static let Tracks = "tracks.json"
        
        static let client_id = "25a4084909dd141d40b97fb9b93ac26b"
        
    }
}
