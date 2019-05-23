//
//  MusicListVC.swift
//  MusicChill
//
//  Created by Hemal on 1/11/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

let placeholderImage = UIImage(named: "music")

import UIKit
import SwiftyJSON
import ObjectMapper
import AlamofireImage


class MusicListVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myActivityIndicatorView: UIActivityIndicatorView!
    private var tracks = [Track]()
    
    
    //-----------------------------------------------------------------
    //MARK: - ViewController LifeCycle
    //-----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: MusicTrackCellID, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: MusicTrackCellID)
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        loadTrendingPlaylist(AppConstants.limit)
    }

    
    //-----------------------------------------------------------------
    // MARK: - Navigation
    //-----------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "selectPlaylist" {
            let destinationVC = segue.destinationViewController as! PlayListVC
            destinationVC.track = sender as? Track
        }
    }
    
    func addSongToPlaylist(sender: UIButton) {
        let model = tracks[sender.tag]
        self.performSegueWithIdentifier("selectPlaylist", sender: model)
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - UITableView Delegate & Datasource
    //-----------------------------------------------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(MusicTrackCellID) as! MusicTrackCell
        
        let accessoryButton = UIButton(type: UIButtonType.Custom)
        accessoryButton.frame = CGRectMake(10,10, 40, 40)
        accessoryButton .setImage(UIImage(named: "plus"), forState: UIControlState.Normal)
        accessoryButton.tag = indexPath.row
        accessoryButton.addTarget(self, action: "addSongToPlaylist:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.accessoryView = accessoryButton
        
        let model = tracks[indexPath.row]
        
        cell.songNameLabel.text = model.title
        cell.artistNameLabel.text = model.user?.username
        
        cell.artworkImageView.image = placeholderImage
        if let artwork_url = model.artwork_url {
            cell.artworkImageView.af_setImageWithURL(NSURL(string: artwork_url)!, placeholderImage: placeholderImage)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 70
//    }
    
    
    
    
    // ---------------------------------------------------------
    // MARK: - API -
    // ---------------------------------------------------------
    
    func loadTrendingPlaylist(limit: String) {
        
        myActivityIndicatorView.startAnimating()
        
        let params = [
            "client_id" : "25a4084909dd141d40b97fb9b93ac26b",
            "limit" : limit
        ]
        
        MCRequestManager.manager.request(.GET, AppConstants.Api.Playlists, parameters: params).responseJSON { responseData in
            
            let response = responseData.result.value
            
            if let response: AnyObject = response {
                
                self.tracks.removeAll(keepCapacity: false)
                
                let trendingPlaylists = Mapper<PlaylistModel>().mapArray(response)!
                
                for trendingPlaylist in trendingPlaylists {
                    
                    let trendingTracks = trendingPlaylist.tracks
                    
                    for trendingTrack in trendingTracks! {
                        self.tracks.append(trendingTrack)
                        
                    }
                }
                
                self.tableView.reloadData()
                
            }
            
            self.myActivityIndicatorView.stopAnimating()
        }
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Memory management
    //-----------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
