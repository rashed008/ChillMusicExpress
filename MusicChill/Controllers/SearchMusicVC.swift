//
//  SearchMusicVC.swift
//  MusicChill
//
//  Created by Hemal on 1/12/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class SearchMusicVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    var searchBar: UISearchBar!
    var searchReq: Request?
    
    private var tracks = [Track]()
    private var localTracks = [Track]()
    
    
    //-----------------------------------------------------------------
    //MARK: - ViewController LifeCycle
    //-----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: MusicTrackCellID, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: MusicTrackCellID)
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
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
    
    
    //-----------------------------------------------------------------
    // MARK: - SearchBar Delegates -
    //-----------------------------------------------------------------
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.tracks.removeAll(keepCapacity: false)
            tableView.reloadData()
            return
        } else {
            if segmentControll.selectedSegmentIndex == 0 {
                loadAutocompleteListFromSoundCloud(querytring: searchText)
            } else {
                loadAutocompleteListFromLocal(querytring: searchText)
            }
        }
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Button Actions -
    //-----------------------------------------------------------------
    @IBAction func searchFilter(sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
            case 0:
                print("Sound Cloud")
                break
            
            case 1:
                print("Local")
                loadTracksFromDB()
                break
            
            default:
                break
        }
        
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Utility Methods -
    //-----------------------------------------------------------------
    
    //Search From Local
    func loadAutocompleteListFromLocal(querytring q: String) {
        let filteredTracklist = localTracks.filter { (track:Track) -> Bool in
            return (track.title?.contains(q))!
            //return (track.title?.lowercaseString.rangeOfString(q)) != nil
        }
        
        if filteredTracklist.count > 0 {
            self.tracks.removeAll(keepCapacity: false)
            self.tracks = filteredTracklist
            self.tableView.reloadData()
        }
        
    }
    
    // Load data from local DB
    func loadTracksFromDB(){
        
        if localTracks.count == 0 {
            
            let tracklists = MCSessionManager.manager.getTracklists()
            if tracklists.count > 0 {
                localTracks = tracklists.map({ $0.jsonModel() })
            }
        }
    }
    
    
    // ---------------------------------------------------------
    // MARK: - API -
    // ---------------------------------------------------------
    
    func loadAutocompleteListFromSoundCloud(querytring q: String) {
        
        let params = [
            "client_id" : "25a4084909dd141d40b97fb9b93ac26b",
            "limit" : AppConstants.limit,
            "q" : q
        ]
        
        searchReq?.cancel()
        searchReq = MCRequestManager.manager.request(.GET, AppConstants.Api.Tracks, parameters: params).responseJSON { responseData in
            
            let response = responseData.result.value
            
            print("response:: \(response)")
            
            if let response: AnyObject = response {
                
                self.tracks.removeAll(keepCapacity: false)
                
                self.tracks = Mapper<Track>().mapArray(response)!
                
                self.tableView.reloadData()
                
            }
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

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}
