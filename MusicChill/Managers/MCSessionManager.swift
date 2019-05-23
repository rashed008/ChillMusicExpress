//
//  MCSessionManager.swift
//  MusicChill
//
//  Created by Shaiful Islam Sujohn on 2/3/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import UIKit
import SugarRecord
import CoreData

class MCSessionManager: NSObject {
    
    static let manager = MCSessionManager()
    
    lazy var db: CoreDataDefaultStorage = {
       
        let store = CoreData.Store.Named("music_chill_db")
        let bundle = NSBundle(forClass: MCSessionManager.classForCoder())
        let model = CoreData.ObjectModel.Merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        
        return defaultStorage
    }()
    
    /// Create play list
    func createPlaylist(playlist playlist: PlaylistModel) {
        MCSessionManager.manager.db.operation { (context, save) -> Void in
            
            let model = playlist.managedModel(context)
            try! context.insert(model)
            
            save()
        }
    }
    
    /// Get play list
    func getPlaylists()-> [PlaylistManagedObjectModel] {
        
        let playlists: [PlaylistManagedObjectModel] = try! db.fetch(Request<PlaylistManagedObjectModel>())
        return playlists
    }
    
    /// Get track lists
    func getTracklists() -> [TrackManagedObjectModel] {
        
        var tracklist = [TrackManagedObjectModel]()
        
        let playlists: [PlaylistManagedObjectModel] = try! db.fetch(Request<PlaylistManagedObjectModel>())
        
        for playlist in playlists {
            
            for track in playlist.tracks!  {
                tracklist.append(track as! TrackManagedObjectModel)
            }
        }
        return tracklist
    }
    
    /// insert track into playlist
    func insertTrackIntoPlaylist(track track: Track, playlistName: String) {
        
        let predicate = NSPredicate(format: "title == %@", playlistName)
        
        MCSessionManager.manager.db.operation { (context, save) -> Void in
            let playlist: PlaylistManagedObjectModel? = try! context.fetch(Request<PlaylistManagedObjectModel>().filteredWith(predicate: predicate)).first
            let track = track.managedModel(context)
            let mutableTracks = playlist!.tracks?.mutableCopy() as! NSMutableOrderedSet
            mutableTracks.addObject(track)
            playlist!.tracks = mutableTracks.copy() as? NSOrderedSet
            
            //try! context.insert(playlist!)
            save()
        }
    }
    
    ///Check if the track already exists in the playlist
    func isTrackExistsInPlaylist(playlist p: String, track: Track) -> Bool {
        
        var exists: Bool = false
        
        let predicate = NSPredicate(format: "title == %@", p)
        
        MCSessionManager.manager.db.operation { (context, save) -> Void in
            let playlist: PlaylistManagedObjectModel? = try! context.fetch(Request<PlaylistManagedObjectModel>().filteredWith(predicate: predicate)).first
            //let track = track.managedModel(context)
            let mutableTracks = playlist!.tracks?.mutableCopy() as! NSMutableOrderedSet
            for trackk in mutableTracks {
                let t = trackk as! TrackManagedObjectModel
                if t.title == track.title {
                    exists = true
                }
            }
        }
        
        return exists
    }
    
    
    ///Delete Track from playlist
    func deleteTrackFromPlaylist(track trk: Track, playlistName: String) {
        
        let predicate = NSPredicate(format: "title == %@", playlistName)
        
        MCSessionManager.manager.db.operation { (context, save) -> Void in
            let playlist: PlaylistManagedObjectModel? = try! context.fetch(Request<PlaylistManagedObjectModel>().filteredWith(predicate: predicate)).first
            //let track = trk.managedModel(context)
            let mutableTracks = playlist!.tracks?.mutableCopy() as! NSMutableOrderedSet
            
            var ttt: TrackManagedObjectModel?
            for t in mutableTracks {
                let tt = t as! TrackManagedObjectModel
                
                if tt.id == trk.id {
                    ttt = tt
                    break
                }
            }
            
            if let ttt = ttt {
                mutableTracks.removeObject(ttt)
            }            
            
            playlist!.tracks = mutableTracks.copy() as? NSOrderedSet
            
            //try! context.remove(searchedTrack!)
            save()
        }
    }
    
    
    //Persisit Shuffle mode for playlist
    func updateShuffleModeForPlaylist(playlistName p: String, mode: Int) {
        
        let predicate = NSPredicate(format: "title == %@", p)
        
        MCSessionManager.manager.db.operation { (context, save) -> Void in
            let playlist: PlaylistManagedObjectModel? = try! context.fetch(Request<PlaylistManagedObjectModel>().filteredWith(predicate: predicate)).first
            
            playlist?.shuffleModeON = mode
            
            save()
        }
    }
    
    func getShuffleModeForPlaylist(playlistName p: String) -> Int {
        
        let predicate = NSPredicate(format: "title == %@", p)
        var shuffleMode: Int = 0
        
        MCSessionManager.manager.db.operation { (context, save) -> Void in
            let playlist: PlaylistManagedObjectModel? = try! context.fetch(Request<PlaylistManagedObjectModel>().filteredWith(predicate: predicate)).first
            
            shuffleMode = (playlist?.shuffleModeON?.integerValue)!
        }
        
        return shuffleMode
    }
    
}



















