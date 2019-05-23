//
//  NowPlayingVC.swift
//  MusicChill
//
//  Created by Hemal on 1/11/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import UIKit
import HysteriaPlayer
import MediaPlayer

class NowPlayingVC: UIViewController, HysteriaPlayerDelegate, HysteriaPlayerDataSource {
    
    
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var isFromHome: Bool = false
    var selectedIndex: Int = 0
    var mTimeObserverNew: AnyObject?
    
    
    //-----------------------------------------------------------------
    //MARK: - ViewController LifeCycle
    //-----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem?.title = ""
        activityIndicator.hidden = true
        
        syncPlayPauseButtons()
        
        
        updateUIForTrack()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hyseteriaPlayerRateChanged", name: AppConstants.Notif.PlayerRateChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hyseteriaPlayerWillChanged", name: AppConstants.Notif.PlayerWillChangedAtIndexNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hysteriaPlayerReadyToPlay", name: AppConstants.Notif.HysteriaPlayerReadyToPlayNotification, object: nil)
        
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Navigation
    //-----------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Button Actions
    //-----------------------------------------------------------------
    @IBAction func playPauseAction(sender: AnyObject) {
        self.btnPlayPause.selected = !self.btnPlayPause.selected
        
        let hysteriaPlayer = MCPlayerManager.manager.hysteriaPlayer
        
        if hysteriaPlayer.isPlaying(){
            hysteriaPlayer.pausePlayerForcibly(true)
            hysteriaPlayer.pause()
        }else{
            hysteriaPlayer.pausePlayerForcibly(false)
            hysteriaPlayer.play()
        }
    }
    
    @IBAction func playPrevious(sender: UIButton) {
        
        let hysteriaPlayer = MCPlayerManager.manager.hysteriaPlayer
        /*
        let currentTrackIndex = hysteriaPlayer.getLastItemIndex()
        
        if hysteriaPlayer.isPlaying(){
            hysteriaPlayer.pausePlayerForcibly(false)
            hysteriaPlayer.pause()
        } else{
            hysteriaPlayer.pausePlayerForcibly(false)
        }
        
        hysteriaPlayer.fetchAndPlayPlayerItem(currentTrackIndex-1)
        */
        hysteriaPlayer.playPrevious()
        //setupNextPreviousButtons()
    }
    
    @IBAction func playNext(sender: UIButton) {
        
        let hysteriaPlayer = MCPlayerManager.manager.hysteriaPlayer
        /*
        let currentTrackIndex = hysteriaPlayer.getLastItemIndex()
        
        if hysteriaPlayer.isPlaying(){
            hysteriaPlayer.pausePlayerForcibly(false)
            hysteriaPlayer.pause()
        } else{
            hysteriaPlayer.pausePlayerForcibly(false)
        }
        
        hysteriaPlayer.fetchAndPlayPlayerItem(currentTrackIndex+1)
        */
        hysteriaPlayer.playNext()
        //setupNextPreviousButtons()
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Utility Methods
    //-----------------------------------------------------------------
    
    func updateUIForTrack() {
        
        setupNextPreviousButtons()
        let playerManager = MCPlayerManager.manager
        
        if playerManager.playableMedias.count > 0 {
            
            let track = playerManager.playableMedias[playerManager.currentTrackIndex]
            
            let totalSec = (Double(track.duration)/1000)
            let mnt = totalSec / 60;
            let sec = totalSec % 60;
            
            elapsedTimeLabel.text = "0:0"
            durationTimeLabel.text = NSString(format: "%01d:%02d", Int(mnt) ?? 0, Int(sec) ?? 0) as String
            
            titleLabel.text = track.title
            artistLabel.text = track.user?.username
            
            artworkImageView.image = placeholderImage
            
            let bigArtworkUrl = track.artwork_url?.stringByReplacingOccurrencesOfString("large", withString: "t500x500")
            
            if let artwork_url = bigArtworkUrl {
                artworkImageView.af_setImageWithURL(NSURL(string: artwork_url)!, placeholderImage: placeholderImage)
            }
            
            // call time observer
            if mTimeObserverNew == nil {
                mTimeObserverNew = MCPlayerManager.manager.hysteriaPlayer.addPeriodicTimeObserverForInterval(CMTimeMake(1000, 1000), queue: nil, usingBlock: { (time) -> Void in
                    
                    let totalSecond = CMTimeGetSeconds(time)
                    let minute = Int(totalSecond) / 60
                    let second = Int(totalSecond) % 60
                    self.elapsedTimeLabel.text = NSString(format: "%01d:%02d", Int(minute) ?? 0, Int(second) ?? 0) as String
                    self.updateProgressViewsWithTimePosition(totalSecond)
                    
                })
            }
            
            // call updateProgressView
            //let totalSecond = playerManager.hysteriaPlayer.getPlayingItemCurrentTime
            //let minut = Int(totalSecond) / 60
            //let secon = Int(totalSecond) % 60
            //self.elapsedTimeLabel.text = [NSString stringWithFormat:@"%01d:%02d", mnt, sec];
            updateProgressViewsWithTimePosition(Double(playerManager.hysteriaPlayer.getPlayingItemCurrentTime()))
        }
        
    }
    
    func setupNextPreviousButtons() {
        
        let player = MCPlayerManager.manager
        let hysteriaPlayer = player.hysteriaPlayer
        let currentTrackIndex = player.currentTrackIndex
        
        if(currentTrackIndex==0)
        {
            self.previousButton.enabled = false
            if(player.playableMedias.count>1)
            {
                self.nextButton.enabled = true
            }
            else {
                self.nextButton.enabled = false
            }
        }
        else
        {
            if(currentTrackIndex==player.playableMedias.count-1)
            {
                self.nextButton.enabled = false
                if(hysteriaPlayer.playerItems.count>=1)
                {
                    self.previousButton.enabled = true
                }
                else {
                    self.previousButton.enabled = false
                }
            }
            else
            {
                self.nextButton.enabled = true
                self.previousButton.enabled = true
            }
        }
    }
    
    func syncPlayPauseButtons() {
        
        let hysteriaPlayer = MCPlayerManager.manager.hysteriaPlayer
        
        switch (hysteriaPlayer.getHysteriaPlayerStatus()) {
        case .Unknown:
            btnPlayPause.hidden = true
            activityIndicator.hidden = false
            break
            
        case .ForcePause:
            btnPlayPause.hidden = false
            activityIndicator.hidden = true
            self.btnPlayPause.selected = false
            break
            
        case .Buffering:
            btnPlayPause.hidden = true
            activityIndicator.hidden = false
            break
            
        case .Playing:
            btnPlayPause.hidden = false
            activityIndicator.hidden = true
            self.btnPlayPause.selected = true
            break
        }
    }
    
    func updateProgressViewsWithTimePosition(timePosition: NSTimeInterval) {
        
        var duration: NSTimeInterval = 0
        let playerManager = MCPlayerManager.manager
        let track = playerManager.playableMedias[playerManager.currentTrackIndex]
        duration = Double(track.duration)/1000
        
        if self.slider.state == UIControlState.Normal {
            self.slider.value = Float(timePosition/duration)
        }
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - HyseteriaPlayer Notifications
    //-----------------------------------------------------------------
    func hyseteriaPlayerRateChanged() {
        syncPlayPauseButtons()
    }
    
    func hyseteriaPlayerWillChanged() {
        
        updateUIForTrack()
        setupNextPreviousButtons()
    }
    
    func hysteriaPlayerReadyToPlay() {
        
        if mTimeObserverNew == nil {
            mTimeObserverNew = MCPlayerManager.manager.hysteriaPlayer.addPeriodicTimeObserverForInterval(CMTimeMake(1000, 1000), queue: nil, usingBlock: { (time) -> Void in
                
                let totalSecond = CMTimeGetSeconds(time)
                let minute = Int(totalSecond) / 60
                let second = Int(totalSecond) % 60
                self.elapsedTimeLabel.text = NSString(format: "%01d:%02d", Int(minute) ?? 0, Int(second) ?? 0) as String
                self.updateProgressViewsWithTimePosition(totalSecond)
                
            })
        }
    }
    
    
    
    //-----------------------------------------------------------------
    // MARK: - Memeory Management
    //-----------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


