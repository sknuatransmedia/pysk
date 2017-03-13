//
//  LiveTVPlayerViewController.swift
//  Puthuyugam
//
//  Created by Apple on 06/03/17.
//  Copyright © 2017 nuatransmedia. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import GoogleMobileAds
import MediaPlayer

class LiveTVPlayerViewController: UIViewController,GADBannerViewDelegate,GADInterstitialDelegate,GADRewardBasedVideoAdDelegate {

    @IBOutlet var viwPlayer: UIView!
    var gameTimer:Timer!
    
    var moviePlayer : MPMoviePlayerController?
    var interstitial:GADInterstitial?
     var player:AVPlayer?
    
    @IBOutlet var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-8907198535429240/8341092219")
        
        
        bannerView.adUnitID = "ca-app-pub-8907198535429240/6074081017"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        gameTimer = Timer.scheduledTimer(timeInterval:480, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "952k")      //let playerurlVals = name
        
        
        playVideo(playerUrl: name!)
    }
    func playVideo(playerUrl:String) {
        let url = NSURL (string: playerUrl)
        moviePlayer = MPMoviePlayerController(contentURL: url as URL!)
        NotificationCenter.default.addObserver(self, selector: Selector(("moviePlayerPlaybackStateDidChange:")) , name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: moviePlayer)
        if let player = moviePlayer {
            player.view.frame = self.viwPlayer.bounds
            player.prepareToPlay()
            player.scalingMode = .aspectFill
            player.controlStyle = .none
            self.viwPlayer.addSubview(player.view)
            

       }
        
        
//        let defaultCenter: NotificationCenter = NotificationCenter.default
//      defaultCenter.addObserver(self, selector: Selector(("moviePlayerPlaybackStateDidChange:")), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: nil)
        
    }

    
    func moviePlayerPlaybackStateDidChange(notification: NSNotification) {
        let moviePlayerController = notification.object as! MPMoviePlayerController
        
        var playbackState: String = "Unknown"
        switch moviePlayerController.playbackState {
        case .stopped:
            moviePlayer!.play()
            playbackState = "Stopped"
            
            print("Stopped")
            
        case .playing:
            playbackState = "Playing"
            
            print("Playing")
        case .paused:
            playbackState = "Paused"
            print("Paused")
        case .interrupted:
            playbackState = "Interrupted"
            print("Interrupted")
        case .seekingForward:
            playbackState = "Seeking Forward"
            print("Seeking Forward")
        case .seekingBackward:
            playbackState = "Seeking Backward"
            print("Seeking Backward")
        }
        
        print("Playback State: %@", playbackState)
    }

    func puthuyugamLiveTVPlayer(playerUrl:String)
    {
        let videoURL = NSURL(string: playerUrl)
        player = AVPlayer(url: videoURL! as URL)
        let playerLayer = AVPlayerLayer(player: player)
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        playerLayer.frame = self.viwPlayer.bounds
        self.viwPlayer.layer.addSublayer(playerLayer)
        player!.play()
        
    }

    func playerDidFinishPlaying(note: NSNotification){
        //Called when player finished playing
        
        player!.play()
        
    }
    func runTimedCode() {
        interstitial = createAndLoadInterstitial()
    }
    
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        if((self.presentingViewController) != nil){
            
            gameTimer.invalidate()
            
            self.dismiss(animated: false, completion: nil)
            //println(cancel")
        }
    }
    
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8907198535429240/6864359019")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        // Remove the following line before you upload the app
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    
    
    
    
    
    
    
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidOpen")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidClose")
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-8907198535429240/8341092219")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidReceive")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidStartPlaying")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdWillLeaveApplication")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Should reward user with \(reward.amount) \(reward.type)")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error?) {
        print("didFailToLoadWithError")
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-8907198535429240/8341092219")
    }
    
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
        print("Interstitial loaded successfully")
        
        moviePlayer?.stop()
        
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial!) {
        print("Fail to receive interstitial")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        moviePlayer?.play()
    }
    
    
    
}
