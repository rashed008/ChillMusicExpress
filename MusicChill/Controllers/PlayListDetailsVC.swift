//
//  PlayListDetailsVC.swift
//  MusicChill
//
//  Created by Hemal on 1/12/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

let MusicTrackCellID =    "MusicTrackCell"
let PlayListDetailsTableViewHeaderID = "PlayListDetailsTableViewHeader"
let PlayListDetailsTableViewSectionHeaderID = "PlayListDetailsTableViewSectionHeader"

import UIKit

class PlayListDetailsVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var playlist: PlaylistManagedObjectModel?
    var trackList = [TrackManagedObjectModel]()
    var indexArr = [NSInteger]()
    var shouldShuffle: Bool = false
    var selectedRow: Int = 0
    
    //-----------------------------------------------------------------
    //MARK: - ViewController LifeCycle
    //-----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        let hysteriaPlayer = MCPlayerManager.manager.hysteriaPlayer
//        print(hysteriaPlayer.)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hyseteriaPlayerRateChanged", name: AppConstants.Notif.PlayerRateChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hyseteriaPlayerWillChanged", name: AppConstants.Notif.PlayerWillChangedAtIndexNotification, object: nil)
        
//        trackList = (playlist?.tracks?.array as? [TrackManagedObjectModel]) ?? []
        if let tracks = playlist!.tracks {
            var i = 0
            for track in  tracks {
                trackList.append(track as! TrackManagedObjectModel)
                indexArr.append(i)
                i++
            }
        }
        
        navigationItem.title = playlist?.title

        self.tableView.registerNib(UINib(nibName: MusicTrackCellID, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: MusicTrackCellID)
        
        self.tableView.registerNib(UINib(nibName: PlayListDetailsTableViewHeaderID, bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: PlayListDetailsTableViewHeaderID)
        
        self.tableView.registerNib(UINib(nibName: PlayListDetailsTableViewSectionHeaderID, bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: PlayListDetailsTableViewSectionHeaderID)
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.tableHeaderView = getHeaderView()
        
        //tableView.setEditing(true, animated: true)
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longpress)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Navigation
    //-----------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func addSongToPlaylist() {
        self.performSegueWithIdentifier("selectPlaylist", sender: nil)
    }
    
    //-----------------------------------------------------------------
    // MARK: - UITableView Delegate & Datasource
    //-----------------------------------------------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(MusicTrackCellID) as! MusicTrackCell
        
        let accessoryButton = UIButton(type: UIButtonType.Custom)
        accessoryButton.frame = CGRectMake(10,10, 40, 40)
        accessoryButton .setImage(UIImage(named: "plus"), forState: UIControlState.Normal)
        accessoryButton.addTarget(self, action: "addSongToPlaylist", forControlEvents: UIControlEvents.TouchUpInside)
        cell.accessoryView = accessoryButton
        cell.accessoryView?.hidden = true
        
        let model = trackList[indexPath.row]
        
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
        
        selectedRow = indexPath.row
        playTracks(nil)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(PlayListDetailsTableViewSectionHeaderID) as! PlayListDetailsTableViewSectionHeader
        
        header.playButton.selected = true
        header.playButton.addTarget(self, action: "playTracks:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let shuffleMode = MCSessionManager.manager.getShuffleModeForPlaylist(playlistName: (playlist?.title)!)
        
        let hysteriaPlayer = MCPlayerManager.manager.hysteriaPlayer
        if Bool(shuffleMode) {
            hysteriaPlayer.setPlayerShuffleMode(.On)
        } else {
            hysteriaPlayer.setPlayerShuffleMode(.Off)
        }
        
        header.shuffleButton.selected = Bool(shuffleMode)
        header.shuffleButton.addTarget(self, action: "shuffleTracks:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return header
    }
    
    //For Row Delete
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let index = indexPath.row
            
            //delete track from DB
            let tList = trackList.map({ $0.jsonModel() })
            MCSessionManager.manager.deleteTrackFromPlaylist(track: tList[index], playlistName: playlist!.title!)
            
            //delete track from trackList
            trackList.removeAtIndex(index)
            
            // delete row from tableview
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        } else if editingStyle == .None {
            print("sdjskdjks")
        }
    }
    
    //Move rows
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshotOfCell(cell)
                
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            My.cellIsAnimating = false
                            if My.cellNeedToShow {
                                My.cellNeedToShow = false
                                UIView.animateWithDuration(0.25, animations: { () -> Void in
                                    cell.alpha = 1
                                })
                            } else {
                                cell.hidden = true
                            }
                        }
                })
            }
            
        case UIGestureRecognizerState.Changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    trackList.insert(trackList.removeAtIndex(Path.initialIndexPath!.row), atIndex: indexPath!.row)
                    tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell.hidden = false
                    cell.alpha = 0.0
                }
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = cell.center
                    My.cellSnapshot!.transform = CGAffineTransformIdentity
                    My.cellSnapshot!.alpha = 0.0
                    cell.alpha = 1.0
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            Path.initialIndexPath = nil
                            My.cellSnapshot!.removeFromSuperview()
                            My.cellSnapshot = nil
                        }
                })
            }
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    /*
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        //(trackList as NSMutableArray).exchangeObjectAtIndex(sourceIndexPath.row, withObjectAtIndex: destinationIndexPath.row)
        
        tableView.moveRowAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
        //swap(&trackList[sourceIndexPath.row], &trackList[destinationIndexPath.row])
    }
    */
    
    // ---------------------------------------------------------
    // MARK: - Button Actions - 
    // ---------------------------------------------------------
    func playTracks(sender: UIButton?) {
        print("\(__FUNCTION__)")
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if trackList.count > 0 {
        
            let playerManager = MCPlayerManager.manager
            
            playerManager.currentTrackIndex = selectedRow
            playerManager.setupHyseteriaPlayer()
            
            playerManager.playableMedias = trackList.map({ $0.jsonModel() })
            playerManager.hysteriaPlayer.itemsCount = playerManager.playableMedias.count
            playerManager.hysteriaPlayer.fetchAndPlayPlayerItem(playerManager.currentTrackIndex)
            
            let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("NowPlayingVC") as! NowPlayingVC
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        }
    }
    
    func shuffleTracks(sender: UIButton) {
        
        let hysteriaPlayer = MCPlayerManager.manager.hysteriaPlayer
        /*let playerManager = MCPlayerManager.manager
        playerManager.currentTrackIndex = 0
        playerManager.playableMedias = trackList.map({ $0.jsonModel() })*/
        sender.selected = !sender.selected
        if sender.selected {
            hysteriaPlayer.setPlayerShuffleMode(.On)
            
            MCSessionManager.manager.updateShuffleModeForPlaylist(playlistName: (playlist?.title)!, mode: 1)
            
            shouldShuffle = true
            print("Shuffle ON")
        } else {
            hysteriaPlayer.setPlayerShuffleMode(.Off)
            
            MCSessionManager.manager.updateShuffleModeForPlaylist(playlistName: (playlist?.title)!, mode: 0)
            
            shouldShuffle = false
            print("Shuffle OFF")
        }
        
    }
    
    // ---------------------------------------------------------
    // MARK: - Utility methods -
    // ---------------------------------------------------------
    
    func getHeaderView() -> PlayListDetailsTableViewHeader {
        
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(PlayListDetailsTableViewHeaderID) as! PlayListDetailsTableViewHeader
        
        header.artworkImageView.image = placeholderImage
        
        if trackList.count > 0 {
            let track = trackList[0]
            let bigArtworkUrl = track.artwork_url?.stringByReplacingOccurrencesOfString("large", withString: "t500x500")
            
            if let artwork_url = bigArtworkUrl {
                header.artworkImageView.af_setImageWithURL(NSURL(string: artwork_url)!, placeholderImage: placeholderImage)
            }
        }
        
        return header
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        //
        let viewSize: CGRect = self.view.bounds
        let desiredHeight = viewSize.height * 0.42
        frame.size.height = desiredHeight
        //
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
    }
    
    func updateTableSectionHeader() {
        let header = tableView.headerViewForSection(0) as! PlayListDetailsTableViewSectionHeader
        
        header.shuffleButton.selected = !header.playButton.selected
        header.playButton.selected = !header.shuffleButton.selected
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - HyseteriaPlayer Notifications
    //-----------------------------------------------------------------
    func hyseteriaPlayerRateChanged() {
        
    }
    
    func hyseteriaPlayerWillChanged() {
        // TODO: Check if it is current playlist
//        tableView.selectRowAtIndexPath(NSIndexPath(forRow: MCPlayerManager.manager.currentTrackIndex, inSection: 0), animated: true, scrollPosition: .None)
    }
    
    
    
    //-----------------------------------------------------------------
    // MARK: - Memory management
    //-----------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        if count < 2 {return}
        for _ in 0..<(count - 1)
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}

