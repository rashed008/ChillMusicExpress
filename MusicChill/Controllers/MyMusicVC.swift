//
//  MyMusicVC.swift
//  MusicChill
//
//  Created by Hemal on 1/10/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import UIKit
import EZAlertController

class MyMusicVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var playlists = [PlaylistManagedObjectModel]()
    @IBOutlet weak var noPlaylistLabel: UILabel!
    @IBOutlet weak var bigPlayButtonAtHomePage: UIButton!
    
    //-----------------------------------------------------------------
    //MARK: - ViewController LifeCycle
    //-----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Navigation
    //-----------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "playlistDetails" {
            let destinationVC = segue.destinationViewController as! PlayListDetailsVC
            let item = sender as! Int
            let playlist = playlists[item]
            destinationVC.playlist = playlist
        }
        
        if segue.identifier == "NowPlayingVC" {
            return
        }
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Button Actions
    //-----------------------------------------------------------------
    @IBAction func addMusicAction(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.showAlertController()
        })
    }
    
    @IBAction func gotoNowPlayingVC(sender: UIButton) {
        
        if playlists.count > 0 {
            
            if MCPlayerManager.manager.playableMedias.count > 0 {
                let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("NowPlayingVC") as! NowPlayingVC
                destinationVC.isFromHome = true
                self.navigationController?.pushViewController(destinationVC, animated: true)
            } else {
                self.performSegueWithIdentifier("playlistDetails", sender: 0)
            }
        }
    }
    
    
    
    //-----------------------------------------------------------------
    // MARK: - Utility Methods
    //-----------------------------------------------------------------
    func showAlertController()
    {
        let alertController = UIAlertController(title: nil, message: "New Playlist", preferredStyle: .Alert)
        let subView = alertController.view.subviews.first! as UIView
        let contentView = subView.subviews.first! as UIView
        contentView.backgroundColor = UIColor.lightTextColor()
        contentView.layer.cornerRadius = 12
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            log.info("Cancel")
        }
        alertController.addAction(cancelAction)
        
        let createAction = UIAlertAction(title: "Create Playlist", style: .Default) { (action) in
            let nameField = alertController.textFields![0] as UITextField
            log.info(nameField.text)
            
            if nameField.text?.characters.count > 0 {
                
                let playlist = PlaylistModel(JSON: ["key" : "value"])
                playlist?.title = nameField.text
                MCSessionManager.manager.createPlaylist(playlist: playlist!)
                self.reloadData()
            }
        }
        alertController.addAction(createAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Playlist Name"
            textField.textAlignment = NSTextAlignment.Center
        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func reloadData(){
        playlists = MCSessionManager.manager.getPlaylists()
        if playlists.count > 0 {
            if let tracks = playlists[0].tracks {
                for track in  tracks {
                    print("track_name :: \(track.title)")
                }
            }
        }
        
        collectionView.reloadData()
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - UICollectionView
    //-----------------------------------------------------------------
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        noPlaylistLabel.hidden = (playlists.count < 1) ? false : true
        return playlists.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SongTrackCell", forIndexPath: indexPath) as! SongTrackCell
        
        let model = playlists[indexPath.row]
        cell.titleLabel.text = model.title
        
        cell.artworkImageView.image = placeholderImage
        cell.artworkImageView.backgroundColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0)
        
        if model.tracks?.count > 0 {
            
            let track = model.tracks![0] as! TrackManagedObjectModel
            let bigArtworkUrl = track.artwork_url?.stringByReplacingOccurrencesOfString("large", withString: "t500x500")
            
            if let artwork_url = bigArtworkUrl {
                cell.artworkImageView.backgroundColor = UIColor.clearColor()
                cell.artworkImageView.af_setImageWithURL(NSURL(string: artwork_url)!, placeholderImage: placeholderImage)
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let bound = UIScreen.mainScreen().bounds
            let hr: CGFloat = (160/140)
            let w: CGFloat = (bound.width/2)-20
            let h: CGFloat = hr*w
            
            return CGSize(width: ceil(w),height: ceil(h))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("playlistDetails", sender: indexPath.item)
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Memory management
    //-----------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
